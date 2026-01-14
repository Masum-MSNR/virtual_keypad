import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'enums.dart';
import 'models.dart';
import 'scope.dart';
import 'theme.dart';

/// A customizable virtual on-screen keyboard.
///
/// This keyboard integrates with [VirtualKeypadScope] to automatically
/// send input to the focused [VirtualKeypadTextField].
///
/// Example:
/// ```dart
/// VirtualKeypadScope(
///   child: Column(
///     children: [
///       VirtualKeypadTextField(controller: controller),
///       VirtualKeypad(
///         type: KeyboardType.text,
///         theme: VirtualKeypadTheme.light,
///       ),
///     ],
///   ),
/// )
/// ```
class VirtualKeypad extends StatefulWidget {
  /// Creates a virtual keyboard.
  const VirtualKeypad({
    super.key,
    this.type = KeyboardType.text,
    this.height = 280,
    this.width,
    this.theme = VirtualKeypadTheme.light,
    this.onKeyPressed,
    this.customLayout,
    this.hideWhenUnfocused = false,
  });

  /// The type of keyboard layout.
  final KeyboardType type;

  /// Height of the keyboard.
  final double height;

  /// Width of the keyboard (defaults to screen width).
  final double? width;

  /// Theme for the keyboard appearance.
  final VirtualKeypadTheme theme;

  /// Called when a key is pressed.
  final void Function(VirtualKey key)? onKeyPressed;

  /// Custom keyboard layout (used when type is [KeyboardType.custom]).
  final KeyboardLayout? customLayout;

  /// When true, the keyboard is hidden when no text field is focused.
  /// When false (default), the keyboard is always visible.
  final bool hideWhenUnfocused;

  @override
  State<VirtualKeypad> createState() => _VirtualKeypadState();
}

class _VirtualKeypadState extends State<VirtualKeypad> {
  LayoutStage _layoutStage = LayoutStage.primary;
  bool _shift = false;
  bool _capsLock = false;
  VirtualKeypadScopeState? _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to scope changes for hideWhenUnfocused
    final newScope = VirtualKeypadScope.of(context);
    if (_scope != newScope) {
      _scope?.removeActiveControllerListener(_onActiveControllerChanged);
      _scope = newScope;
      if (widget.hideWhenUnfocused) {
        _scope?.addActiveControllerListener(_onActiveControllerChanged);
      }
    }
  }

  @override
  void didUpdateWidget(VirtualKeypad oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update listener if hideWhenUnfocused changed
    if (widget.hideWhenUnfocused != oldWidget.hideWhenUnfocused) {
      if (widget.hideWhenUnfocused) {
        _scope?.addActiveControllerListener(_onActiveControllerChanged);
      } else {
        _scope?.removeActiveControllerListener(_onActiveControllerChanged);
      }
    }
  }

  @override
  void dispose() {
    _scope?.removeActiveControllerListener(_onActiveControllerChanged);
    super.dispose();
  }

  void _onActiveControllerChanged() {
    if (mounted) setState(() {});
  }

  KeyboardLayout get _currentLayout {
    if (widget.type == KeyboardType.custom && widget.customLayout != null) {
      return widget.customLayout!;
    }

    switch (widget.type) {
      case KeyboardType.number:
        return _numberLayout;
      case KeyboardType.phone:
        return _phoneLayout;
      case KeyboardType.text:
      case KeyboardType.custom:
        switch (_layoutStage) {
          case LayoutStage.primary:
            return _textLayoutPrimary;
          case LayoutStage.secondary:
            return _textLayoutSecondary;
          case LayoutStage.tertiary:
            return _textLayoutTertiary;
        }
    }
  }

  void _onKeyPressed(VirtualKey key) {
    final scope = _scope;

    if (key.isCharacter) {
      final text = key.getInsertText(shift: _shift, capsLock: _capsLock);
      scope?.insertText(text);

      // Reset shift after character input (unless caps lock)
      if (_shift && !_capsLock) {
        setState(() => _shift = false);
      }
    } else if (key.isAction) {
      switch (key.action) {
        case KeyAction.backSpace:
          scope?.deleteBackward();
          break;

        case KeyAction.enter:
          scope?.insertText('\n');
          break;

        case KeyAction.space:
          scope?.insertText(' ');
          // Auto-capitalize after ". "
          final text = scope?.activeController?.text ?? '';
          if (text.endsWith('. ') ||
              text.endsWith('? ') ||
              text.endsWith('! ')) {
            if (!_shift && !_capsLock) {
              setState(() => _shift = true);
            }
          }
          break;

        case KeyAction.shift:
          setState(() {
            if (!_shift) {
              _shift = true;
            } else if (_shift && !_capsLock) {
              _capsLock = true;
            } else {
              _shift = false;
              _capsLock = false;
            }
          });
          break;

        case KeyAction.symbols:
          setState(() {
            if (_layoutStage == LayoutStage.primary) {
              _layoutStage = LayoutStage.secondary;
            } else {
              _layoutStage = LayoutStage.primary;
            }
          });
          break;

        case KeyAction.symbolsAlt:
          setState(() {
            if (_layoutStage == LayoutStage.secondary) {
              _layoutStage = LayoutStage.tertiary;
            } else {
              _layoutStage = LayoutStage.secondary;
            }
          });
          break;

        case KeyAction.switchLanguage:
          // TODO: Implement language switching
          break;

        default:
          break;
      }
    }

    widget.onKeyPressed?.call(key);
  }

  @override
  Widget build(BuildContext context) {
    // Hide keyboard if hideWhenUnfocused is true and no text field is focused
    if (widget.hideWhenUnfocused && !(_scope?.hasActiveController ?? false)) {
      return const SizedBox.shrink();
    }

    final width = widget.width ?? MediaQuery.of(context).size.width;
    final layout = _currentLayout;
    final rows = layout.length;
    final maxColumns = layout.map((row) => row.length).reduce(max);

    // Calculate key dimensions
    final usedHeight = (rows + 1) * widget.theme.verticalGap;
    final keyHeight = (widget.height - usedHeight) / rows;
    final usedWidth = (maxColumns + 1) * widget.theme.horizontalGap;
    final baseKeyWidth = (width - usedWidth) / maxColumns;

    return ExcludeFocus(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {}, // Consume taps to prevent unfocusing
        child: Container(
          width: width,
          height: widget.height,
          color: widget.theme.backgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: widget.theme.verticalGap / 2,
            horizontal: widget.theme.horizontalGap / 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: layout.map((row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((key) {
                  return _KeyWidget(
                    key: ValueKey('${key.text ?? key.action}'),
                    virtualKey: key,
                    height: keyHeight,
                    baseWidth: baseKeyWidth,
                    theme: widget.theme,
                    shift: _shift,
                    capsLock: _capsLock,
                    layoutStage: _layoutStage,
                    onPressed: _onKeyPressed,
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Widget for a single key.
class _KeyWidget extends StatefulWidget {
  const _KeyWidget({
    super.key,
    required this.virtualKey,
    required this.height,
    required this.baseWidth,
    required this.theme,
    required this.shift,
    required this.capsLock,
    required this.layoutStage,
    required this.onPressed,
  });

  final VirtualKey virtualKey;
  final double height;
  final double baseWidth;
  final VirtualKeypadTheme theme;
  final bool shift;
  final bool capsLock;
  final LayoutStage layoutStage;
  final void Function(VirtualKey) onPressed;

  @override
  State<_KeyWidget> createState() => _KeyWidgetState();
}

class _KeyWidgetState extends State<_KeyWidget> {
  Timer? _repeatTimer;
  bool _isLongPressing = false;

  @override
  void dispose() {
    _repeatTimer?.cancel();
    super.dispose();
  }

  void _startRepeat() {
    if (widget.virtualKey.action != KeyAction.backSpace) return;

    _isLongPressing = true;
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_isLongPressing) {
        widget.onPressed(widget.virtualKey);
      } else {
        _repeatTimer?.cancel();
      }
    });
  }

  void _stopRepeat() {
    _isLongPressing = false;
    _repeatTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final key = widget.virtualKey;
    final isAction = key.isAction;
    final decoration = isAction
        ? widget.theme.actionKeyDecoration
        : widget.theme.keyDecoration;

    // Calculate width based on flex
    final width = widget.baseWidth * key.flex +
        (key.flex - 1) * widget.theme.horizontalGap;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.theme.verticalGap / 2,
        horizontal: widget.theme.horizontalGap / 2,
      ),
      height: widget.height,
      width: width,
      decoration: _getDecoration(decoration),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onLongPressStart: (_) => _startRepeat(),
          onLongPressEnd: (_) => _stopRepeat(),
          onLongPressCancel: _stopRepeat,
          child: InkWell(
            splashColor: widget.theme.splashColor ?? VkpColors.splashColor,
            onTap: () => widget.onPressed(key),
            child: Center(
              child: _buildKeyContent(),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(BoxDecoration base) {
    final key = widget.virtualKey;

    // Highlight shift key when active
    if (key.action == KeyAction.shift && (widget.shift || widget.capsLock)) {
      return base.copyWith(
        color: widget.capsLock
            ? widget.theme.keyTextColor.withValues(alpha: 0.3)
            : widget.theme.keyColor,
      );
    }

    // Highlight symbols key when on symbols layout
    if (key.action == KeyAction.symbols &&
        widget.layoutStage != LayoutStage.primary) {
      return base.copyWith(color: widget.theme.keyColor);
    }

    return base;
  }

  Widget _buildKeyContent() {
    final key = widget.virtualKey;

    if (key.isCharacter) {
      return Text(
        key.getDisplayText(shift: widget.shift, capsLock: widget.capsLock),
        style: TextStyle(
          fontSize: widget.theme.keyTextSize,
          color: widget.theme.keyTextColor,
        ),
      );
    }

    // Action key icons/labels
    switch (key.action) {
      case KeyAction.backSpace:
        return Icon(
          Icons.backspace_outlined,
          size: widget.theme.keyTextSize,
          color: widget.theme.keyTextColor,
        );

      case KeyAction.enter:
        return Icon(
          Icons.keyboard_return,
          size: widget.theme.keyTextSize,
          color: widget.theme.keyTextColor,
        );

      case KeyAction.shift:
        return Icon(
          widget.capsLock
              ? Icons.keyboard_capslock
              : (widget.shift
                  ? Icons.arrow_upward
                  : Icons.arrow_upward_outlined),
          size: widget.theme.keyTextSize,
          color: widget.theme.keyTextColor,
        );

      case KeyAction.space:
        return Text(
          'space',
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.7,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.symbols:
        return Text(
          widget.layoutStage == LayoutStage.primary ? '123' : 'ABC',
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.8,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.symbolsAlt:
        return Text(
          widget.layoutStage == LayoutStage.secondary ? '#+=' : '123',
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.8,
            color: widget.theme.keyTextColor,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

// =============================================================================
// KEYBOARD LAYOUTS
// =============================================================================

/// Number pad layout
final KeyboardLayout _numberLayout = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
  ],
  [
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
  ],
  [
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '0'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
];

/// Phone pad layout
final KeyboardLayout _phoneLayout = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
  ],
  [
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
  ],
  [
    VirtualKey.character(text: '+'),
    VirtualKey.character(text: '0'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
];

/// QWERTY text layout - primary (letters)
final KeyboardLayout _textLayoutPrimary = [
  [
    VirtualKey.character(text: 'q'),
    VirtualKey.character(text: 'w'),
    VirtualKey.character(text: 'e'),
    VirtualKey.character(text: 'r'),
    VirtualKey.character(text: 't'),
    VirtualKey.character(text: 'y'),
    VirtualKey.character(text: 'u'),
    VirtualKey.character(text: 'i'),
    VirtualKey.character(text: 'o'),
    VirtualKey.character(text: 'p'),
  ],
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 's'),
    VirtualKey.character(text: 'd'),
    VirtualKey.character(text: 'f'),
    VirtualKey.character(text: 'g'),
    VirtualKey.character(text: 'h'),
    VirtualKey.character(text: 'j'),
    VirtualKey.character(text: 'k'),
    VirtualKey.character(text: 'l'),
  ],
  [
    VirtualKey.action(action: KeyAction.shift, flex: 1),
    VirtualKey.character(text: 'z'),
    VirtualKey.character(text: 'x'),
    VirtualKey.character(text: 'c'),
    VirtualKey.character(text: 'v'),
    VirtualKey.character(text: 'b'),
    VirtualKey.character(text: 'n'),
    VirtualKey.character(text: 'm'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];

/// QWERTY text layout - secondary (numbers & symbols)
final KeyboardLayout _textLayoutSecondary = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
    VirtualKey.character(text: '0'),
  ],
  [
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: ':'),
    VirtualKey.character(text: ';'),
    VirtualKey.character(text: '('),
    VirtualKey.character(text: ')'),
    VirtualKey.character(text: '\$'),
    VirtualKey.character(text: '&'),
    VirtualKey.character(text: '@'),
    VirtualKey.character(text: '"'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 1),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: ','),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '#'),
    VirtualKey.character(text: '%'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];

/// QWERTY text layout - tertiary (more symbols)
final KeyboardLayout _textLayoutTertiary = [
  [
    VirtualKey.character(text: '['),
    VirtualKey.character(text: ']'),
    VirtualKey.character(text: '{'),
    VirtualKey.character(text: '}'),
    VirtualKey.character(text: '#'),
    VirtualKey.character(text: '%'),
    VirtualKey.character(text: '^'),
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: '+'),
    VirtualKey.character(text: '='),
  ],
  [
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '\\'),
    VirtualKey.character(text: '|'),
    VirtualKey.character(text: '~'),
    VirtualKey.character(text: '<'),
    VirtualKey.character(text: '>'),
    VirtualKey.character(text: '€'),
    VirtualKey.character(text: '£'),
    VirtualKey.character(text: '¥'),
    VirtualKey.character(text: '•'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 1),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: ','),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '`'),
    VirtualKey.character(text: '°'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];
