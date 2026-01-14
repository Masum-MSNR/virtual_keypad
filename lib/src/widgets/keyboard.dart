import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../enums.dart';
import '../layouts/keyboard_language.dart';
import '../layouts/keyboard_layout_provider.dart';
import '../models.dart';
import '../scope.dart';
import '../theme.dart';

/// A customizable virtual on-screen keyboard widget.
///
/// Automatically integrates with [VirtualKeypadScope] to send input to
/// the focused [VirtualKeypadTextField]. The keyboard automatically adapts
/// its layout based on the focused text field's [KeyboardType].
///
/// ```dart
/// VirtualKeypadScope(
///   child: Column(
///     children: [
///       VirtualKeypadTextField(
///         controller: controller,
///         keyboardType: KeyboardType.emailAddress,
///       ),
///       VirtualKeypad(), // Automatically shows email layout
///     ],
///   ),
/// )
/// ```
class VirtualKeypad extends StatefulWidget {
  /// Creates a virtual keyboard.
  const VirtualKeypad({
    super.key,
    this.type,
    this.height = 280,
    this.width,
    this.theme = VirtualKeypadTheme.light,
    this.onKeyPressed,
    this.customLayout,
    this.hideWhenUnfocused = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  });

  /// Override keyboard type. If null, uses the type from the focused text field.
  final KeyboardType? type;

  /// Height of the keyboard in logical pixels.
  final double height;

  /// Width of the keyboard. Defaults to screen width if null.
  final double? width;

  /// Visual theme for the keyboard.
  final VirtualKeypadTheme theme;

  /// Optional callback invoked when any key is pressed.
  final void Function(VirtualKey key)? onKeyPressed;

  /// Custom layout when [type] is [KeyboardType.custom].
  final KeyboardLayout? customLayout;

  /// When true, hides the keyboard with animation when no text field is focused.
  final bool hideWhenUnfocused;

  /// Duration for show/hide animation when [hideWhenUnfocused] is true.
  final Duration animationDuration;

  /// Animation curve for show/hide transitions.
  final Curve animationCurve;

  @override
  State<VirtualKeypad> createState() => _VirtualKeypadState();
}

class _VirtualKeypadState extends State<VirtualKeypad> {
  LayoutStage _layoutStage = LayoutStage.primary;
  bool _shift = false;
  bool _capsLock = false;
  VirtualKeypadScopeState? _scope;
  KeyboardType? _lastKeyboardType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newScope = VirtualKeypadScope.of(context);
    if (_scope != newScope) {
      _scope?.removeActiveControllerListener(_onActiveControllerChanged);
      _scope = newScope;
      _scope?.addActiveControllerListener(_onActiveControllerChanged);
    }
  }

  @override
  void dispose() {
    _scope?.removeActiveControllerListener(_onActiveControllerChanged);
    super.dispose();
  }

  void _onActiveControllerChanged() {
    if (mounted) {
      final newType = _effectiveKeyboardType;
      if (_lastKeyboardType != newType) {
        _layoutStage = LayoutStage.primary;
        _shift = false;
        _capsLock = false;
        _lastKeyboardType = newType;
      }
      setState(() {});
    }
  }

  KeyboardType get _effectiveKeyboardType {
    return widget.type ?? _scope?.activeKeyboardType ?? KeyboardType.text;
  }

  TextInputAction get _effectiveInputAction {
    return _scope?.activeInputAction ?? TextInputAction.done;
  }

  KeyboardLayout get _currentLayout {
    final type = _effectiveKeyboardType;

    if (type == KeyboardType.custom && widget.customLayout != null) {
      return widget.customLayout!;
    }

    final inputType = _toInputType(type);
    final layoutSet = KeyboardLayoutProvider.instance.getLayouts(inputType);

    return _getLayoutForStage(layoutSet);
  }

  KeyboardInputType _toInputType(KeyboardType type) {
    switch (type) {
      case KeyboardType.emailAddress:
        return KeyboardInputType.email;
      case KeyboardType.url:
        return KeyboardInputType.url;
      case KeyboardType.number:
        return KeyboardInputType.number;
      case KeyboardType.numberSigned:
        return KeyboardInputType.numberSigned;
      case KeyboardType.numberDecimal:
      case KeyboardType.datetime:
        return KeyboardInputType.numberDecimal;
      case KeyboardType.phone:
        return KeyboardInputType.phone;
      case KeyboardType.text:
      case KeyboardType.multiline:
      case KeyboardType.visiblePassword:
      case KeyboardType.name:
      case KeyboardType.streetAddress:
      case KeyboardType.none:
      case KeyboardType.custom:
        return KeyboardInputType.text;
    }
  }

  KeyboardLayout _getLayoutForStage(KeyboardLayoutSet layoutSet) {
    switch (_layoutStage) {
      case LayoutStage.primary:
        return layoutSet.primary;
      case LayoutStage.secondary:
        return layoutSet.secondary ?? layoutSet.primary;
      case LayoutStage.tertiary:
        return layoutSet.tertiary ?? layoutSet.secondary ?? layoutSet.primary;
    }
  }

  void _onKeyPressed(VirtualKey key) {
    final scope = _scope;

    if (key.isCharacter) {
      final text = key.getInsertText(shift: _shift, capsLock: _capsLock);
      scope?.insertText(text);

      if (_shift && !_capsLock) {
        setState(() => _shift = false);
      }
    } else if (key.isAction) {
      _handleAction(key.action!, scope);
    }

    widget.onKeyPressed?.call(key);
  }

  void _handleAction(KeyAction action, VirtualKeypadScopeState? scope) {
    switch (action) {
      case KeyAction.backSpace:
        scope?.deleteBackward();
        break;

      case KeyAction.enter:
        final inputAction = _effectiveInputAction;
        if (inputAction == TextInputAction.newline ||
            _effectiveKeyboardType == KeyboardType.multiline) {
          scope?.insertText('\n');
        } else {
          scope?.submit();
        }
        break;

      case KeyAction.space:
        scope?.insertText(' ');
        final text = scope?.activeController?.text ?? '';
        if (text.endsWith('. ') || text.endsWith('? ') || text.endsWith('! ')) {
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

      case KeyAction.done:
      case KeyAction.go:
      case KeyAction.search:
      case KeyAction.send:
      case KeyAction.call:
        scope?.submit();
        break;

      case KeyAction.next:
      case KeyAction.previous:
      case KeyAction.switchLanguage:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVisible =
        !widget.hideWhenUnfocused || (_scope?.hasActiveController ?? false);

    if (_effectiveKeyboardType == KeyboardType.none) {
      return const SizedBox.shrink();
    }

    final width = widget.width ?? MediaQuery.of(context).size.width;
    final layout = _currentLayout;
    final rows = layout.length;
    final maxColumns = layout.map((row) => row.length).reduce(max);

    final totalFlex = layout
        .map((row) => row.fold(0, (sum, key) => sum + key.flex))
        .reduce(max);

    final usedHeight = (rows + 1) * widget.theme.verticalGap;
    final keyHeight = (widget.height - usedHeight) / rows;
    final usedWidth = (maxColumns + 1) * widget.theme.horizontalGap;
    final baseKeyWidth = (width - usedWidth) / totalFlex;

    final keyboardContent = TextFieldTapRegion(
      child: ExcludeFocus(
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
                    inputAction: _effectiveInputAction,
                    languageCode:
                        KeyboardLayoutProvider.instance.currentLanguageCode,
                    onPressed: _onKeyPressed,
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );

    if (!widget.hideWhenUnfocused) {
      return keyboardContent;
    }

    return ClipRect(
      child: AnimatedAlign(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        alignment: Alignment.topCenter,
        heightFactor: isVisible ? 1.0 : 0.0,
        child: keyboardContent,
      ),
    );
  }
}

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
    required this.inputAction,
    required this.languageCode,
    required this.onPressed,
  });

  final VirtualKey virtualKey;
  final double height;
  final double baseWidth;
  final VirtualKeypadTheme theme;
  final bool shift;
  final bool capsLock;
  final LayoutStage layoutStage;
  final TextInputAction inputAction;
  final String languageCode;
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

    if (key.action == KeyAction.shift && (widget.shift || widget.capsLock)) {
      return base.copyWith(
        color: widget.capsLock
            ? widget.theme.keyTextColor.withValues(alpha: 0.3)
            : widget.theme.keyColor,
      );
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
          widget.virtualKey.label ?? 'space',
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.7,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.symbols:
        return Text(
          widget.layoutStage == LayoutStage.primary
              ? (widget.virtualKey.label ?? '123')
              : (widget.virtualKey.altLabel ?? _getLettersLabel()),
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.8,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.symbolsAlt:
        return Text(
          widget.layoutStage == LayoutStage.secondary
              ? (widget.virtualKey.label ?? '#+=')
              : (widget.virtualKey.altLabel ?? '123'),
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.8,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.done:
        return Text(
          _getActionLabel(),
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.7,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.go:
        return Text(
          'Go',
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.8,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.search:
        return Icon(
          Icons.search,
          size: widget.theme.keyTextSize,
          color: widget.theme.keyTextColor,
        );

      case KeyAction.send:
        return Icon(
          Icons.send,
          size: widget.theme.keyTextSize,
          color: widget.theme.keyTextColor,
        );

      case KeyAction.call:
        return Icon(
          Icons.call,
          size: widget.theme.keyTextSize,
          color: widget.theme.keyTextColor,
        );

      case KeyAction.next:
        return Text(
          'Next',
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.8,
            color: widget.theme.keyTextColor,
          ),
        );

      case KeyAction.previous:
        return Text(
          'Prev',
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.8,
            color: widget.theme.keyTextColor,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  String _getActionLabel() {
    switch (widget.inputAction) {
      case TextInputAction.done:
        return 'Done';
      case TextInputAction.go:
        return 'Go';
      case TextInputAction.search:
        return 'Search';
      case TextInputAction.send:
        return 'Send';
      case TextInputAction.next:
        return 'Next';
      case TextInputAction.previous:
        return 'Prev';
      default:
        return 'Done';
    }
  }

  String _getLettersLabel() {
    switch (widget.languageCode) {
      case 'bn':
        return 'কখ';
      case 'hi':
        return 'अआ';
      case 'ar':
        return 'أب';
      case 'ru':
        return 'АБВ';
      case 'ja':
        return 'あ';
      case 'ko':
        return '가나';
      case 'zh':
        return '中';
      case 'th':
        return 'กข';
      default:
        return 'ABC';
    }
  }
}
