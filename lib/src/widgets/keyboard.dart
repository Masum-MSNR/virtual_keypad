import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../enums.dart';
import '../layouts/keyboard_language.dart';
import '../layouts/keyboard_layout_provider.dart';
import '../models.dart';
import '../scope.dart';
import '../standalone_input_control.dart';
import '../standalone_scope.dart';
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
  ///
  /// When [standalone] is true, the keyboard works with any standard Flutter
  /// [TextField] or [TextFormField] without requiring [VirtualKeypadScope].
  /// It intercepts Flutter's text input system to route key presses to the
  /// currently focused text field.
  const VirtualKeypad({
    super.key,
    this.type,
    this.inputAction,
    this.height = 280,
    this.width,
    this.theme = VirtualKeypadTheme.light,
    this.onKeyPressed,
    this.onKeyPressedWithText,
    this.customLayout,
    this.hideWhenUnfocused = false,
    this.standalone = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  });

  /// Override keyboard type. If null, uses the type from the focused text field.
  final KeyboardType? type;

  /// Override input action displayed on the enter/done key.
  /// If null, uses the action from the focused text field.
  final TextInputAction? inputAction;

  /// Height of the keyboard in logical pixels.
  final double height;

  /// Width of the keyboard. Defaults to screen width if null.
  final double? width;

  /// Visual theme for the keyboard.
  final VirtualKeypadTheme theme;

  /// Optional callback invoked when any key is pressed.
  final void Function(VirtualKey key)? onKeyPressed;

  /// Optional callback invoked when any key is pressed, including the
  /// inserted text. [text] is the character inserted for character keys
  /// (respecting shift/caps), or null for action keys.
  final void Function(VirtualKey key, String? text)? onKeyPressedWithText;

  /// Custom layout when [type] is [KeyboardType.custom].
  final KeyboardLayout? customLayout;

  /// When true, hides the keyboard with animation when no text field is focused.
  final bool hideWhenUnfocused;

  /// When true, the keyboard works with any standard Flutter [TextField]
  /// without requiring [VirtualKeypadScope] or [VirtualKeypadTextField].
  ///
  /// In standalone mode, the keyboard intercepts Flutter's text input system
  /// and routes key presses to whichever [TextField] currently has focus.
  ///
  /// ```dart
  /// Column(
  ///   children: [
  ///     TextField(controller: myController),
  ///     VirtualKeypad(standalone: true),
  ///   ],
  /// )
  /// ```
  final bool standalone;

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

  // Cache the layout when keyboard is visible for smooth close animation
  KeyboardLayout? _cachedLayout;
  bool _wasVisible = false;

  // Standalone mode state
  StandaloneInputControl? _inputControl;
  bool _standaloneVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.standalone) {
      _initStandalone();
    }
  }

  void _initStandalone() {
    _inputControl = StandaloneInputControl(
      onShow: _onStandaloneShow,
      onHide: () {
        if (!mounted) return;
        setState(() => _standaloneVisible = false);
      },
    );
    TextInput.setInputControl(_inputControl!);
    FocusManager.instance.addListener(_onFocusChanged);
  }

  void _disposeStandalone() {
    FocusManager.instance.removeListener(_onFocusChanged);
    if (_inputControl != null) {
      TextInput.restorePlatformInputControl();
      _inputControl = null;
    }
  }

  void _onFocusChanged() {
    if (!widget.standalone || !mounted) return;
    // If primary focus is lost entirely, hide keyboard
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null || focus.context == null) {
      if (_standaloneVisible) {
        setState(() => _standaloneVisible = false);
      }
      return;
    }

    // If wrapped in a scope, hide when focus moves outside that scope
    final myScope = VirtualKeypadStandaloneScope.maybeOf(context);
    if (myScope != null && _standaloneVisible) {
      final focusedScope =
          VirtualKeypadStandaloneScope.maybeOf(focus.context!);
      if (focusedScope != myScope) {
        setState(() => _standaloneVisible = false);
      }
    }
  }

  /// Called when the [StandaloneInputControl] requests the keyboard to show.
  ///
  /// If the keyboard is wrapped in a [VirtualKeypadStandaloneScope], the
  /// focused text field must be within the same scope for the keyboard to
  /// appear. This prevents the keyboard from responding to text fields that
  /// belong to a different part of the widget tree.
  void _onStandaloneShow() {
    if (!mounted) return;

    // If this keyboard is inside a VirtualKeypadStandaloneScope, only show
    // when the focused widget is in the same scope.
    final myScope = VirtualKeypadStandaloneScope.maybeOf(context);
    if (myScope != null) {
      final focusedContext = FocusManager.instance.primaryFocus?.context;
      final focusedScope = focusedContext != null
          ? VirtualKeypadStandaloneScope.maybeOf(focusedContext)
          : null;
      if (focusedScope != myScope) {
        // The focused field is outside our scope – hide the keyboard.
        if (_standaloneVisible) setState(() => _standaloneVisible = false);
        return;
      }
    }

    setState(() => _standaloneVisible = true);
    _onStandaloneFieldChanged();
  }

  void _onStandaloneFieldChanged() {
    if (!mounted || _inputControl == null) return;
    final newType = _inputControl!.keyboardType;
    if (_lastKeyboardType != newType) {
      _layoutStage = LayoutStage.primary;
      _shift = false;
      _capsLock = false;
      _lastKeyboardType = newType;
    }
    _cachedLayout = _currentLayout;
    _wasVisible = true;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.standalone) {
      final newScope = VirtualKeypadScope.of(context);
      if (_scope != newScope) {
        _scope?.removeActiveControllerListener(_onActiveControllerChanged);
        _scope = newScope;
        _scope?.addActiveControllerListener(_onActiveControllerChanged);
      }
    }
  }

  @override
  void didUpdateWidget(VirtualKeypad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.standalone != oldWidget.standalone) {
      if (widget.standalone) {
        // Switching to standalone
        _scope?.removeActiveControllerListener(_onActiveControllerChanged);
        _scope = null;
        _initStandalone();
      } else {
        // Switching away from standalone
        _disposeStandalone();
        _standaloneVisible = false;
      }
    }
  }

  @override
  void dispose() {
    if (widget.standalone) {
      _disposeStandalone();
    } else {
      _scope?.removeActiveControllerListener(_onActiveControllerChanged);
    }
    super.dispose();
  }

  void _onActiveControllerChanged() {
    if (mounted) {
      final hasController = _scope?.hasActiveController ?? false;
      final allowPhysical = _scope?.allowPhysicalKeyboard ?? false;
      final isVisible = hasController && !allowPhysical;

      // Only reset layout when a new field gains focus (not when losing focus)
      if (isVisible) {
        final newType = _effectiveKeyboardType;
        if (_lastKeyboardType != newType) {
          _layoutStage = LayoutStage.primary;
          _shift = false;
          _capsLock = false;
          _lastKeyboardType = newType;
        }
        // Cache the current layout while visible
        _cachedLayout = _currentLayout;
        _wasVisible = true;
      }

      setState(() {});
    }
  }

  KeyboardType get _effectiveKeyboardType {
    if (widget.type != null) return widget.type!;
    if (widget.standalone && _inputControl != null) {
      return _inputControl!.keyboardType;
    }
    return _scope?.activeKeyboardType ?? KeyboardType.text;
  }

  TextInputAction get _effectiveInputAction {
    if (widget.inputAction != null) return widget.inputAction!;
    if (widget.standalone && _inputControl != null) {
      return _inputControl!.inputAction;
    }
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
    String? insertedText;

    if (key.isCharacter) {
      insertedText = key.getInsertText(shift: _shift, capsLock: _capsLock);

      if (widget.standalone) {
        _inputControl?.insertText(insertedText);
      } else {
        _scope?.insertText(insertedText);
      }

      if (_shift && !_capsLock) {
        setState(() => _shift = false);
      }
    } else if (key.isAction) {
      _handleAction(key.action!);
    }

    widget.onKeyPressed?.call(key);
    widget.onKeyPressedWithText?.call(key, insertedText);
  }

  void _handleAction(KeyAction action) {
    switch (action) {
      case KeyAction.backSpace:
        if (widget.standalone) {
          _inputControl?.deleteBackward();
        } else {
          _scope?.deleteBackward();
        }
        break;

      case KeyAction.enter:
        final inputAction = _effectiveInputAction;
        if (inputAction == TextInputAction.newline ||
            _effectiveKeyboardType == KeyboardType.multiline) {
          if (widget.standalone) {
            _inputControl?.insertText('\n');
          } else {
            _scope?.insertText('\n');
          }
        } else {
          if (widget.standalone) {
            _inputControl?.submit();
          } else {
            _scope?.submit();
          }
        }
        break;

      case KeyAction.space:
        if (widget.standalone) {
          _inputControl?.insertText(' ');
          final text = _inputControl?.currentValue.text ?? '';
          if (text.endsWith('. ') ||
              text.endsWith('? ') ||
              text.endsWith('! ')) {
            if (!_shift && !_capsLock) {
              setState(() => _shift = true);
            }
          }
        } else {
          _scope?.insertText(' ');
          final text = _scope?.activeController?.text ?? '';
          if (text.endsWith('. ') ||
              text.endsWith('? ') ||
              text.endsWith('! ')) {
            if (!_shift && !_capsLock) {
              setState(() => _shift = true);
            }
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
        if (widget.standalone) {
          _inputControl?.submit();
        } else {
          _scope?.submit();
        }
        break;

      case KeyAction.next:
      case KeyAction.previous:
      case KeyAction.switchLanguage:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldShowKeyboard;
    if (widget.standalone) {
      shouldShowKeyboard = _standaloneVisible && (_inputControl?.isAttached ?? false);
    } else {
      final hasController = _scope?.hasActiveController ?? false;
      final allowPhysical = _scope?.allowPhysicalKeyboard ?? false;
      shouldShowKeyboard = hasController && !allowPhysical;
    }

    final isVisible = !widget.hideWhenUnfocused || shouldShowKeyboard;

    if (_effectiveKeyboardType == KeyboardType.none) {
      return const SizedBox.shrink();
    }

    // Update cache when visible
    if (shouldShowKeyboard) {
      _cachedLayout = _currentLayout;
      _wasVisible = true;
    }

    // Use cached layout during close animation, or current layout when visible
    final layout = shouldShowKeyboard
        ? _currentLayout
        : (_wasVisible && _cachedLayout != null
            ? _cachedLayout!
            : _currentLayout);

    // Reset cache after animation would complete
    if (!shouldShowKeyboard && _wasVisible && !widget.hideWhenUnfocused) {
      _wasVisible = false;
      _cachedLayout = null;
    }

    final width = widget.width ?? MediaQuery.of(context).size.width;
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
                    type: _effectiveKeyboardType,
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
    required this.type,
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
  final KeyboardType type;
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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _popupEntry;
  Timer? _popupTimer;

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _removePopup();
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

  void _showKeyPreview() {
    if (!widget.virtualKey.isCharacter) return;

    _removePopup();

    final keyWidth = widget.baseWidth * widget.virtualKey.flex +
        (widget.virtualKey.flex - 1) * widget.theme.horizontalGap;
    final popupWidth = keyWidth + 14;
    final popupHeight = widget.height + 12;
    const gap = 6.0;

    _popupEntry = OverlayEntry(
      builder: (context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
            -(popupWidth - keyWidth) / 2,
            -popupHeight - gap,
          ),
          child: _KeyPreviewBubble(
            text: widget.virtualKey.getDisplayText(
              shift: widget.shift,
              capsLock: widget.capsLock,
            ),
            width: popupWidth,
            height: popupHeight,
            theme: widget.theme,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_popupEntry!);

    _popupTimer = Timer(const Duration(milliseconds: 120), _removePopup);
  }

  void _removePopup() {
    _popupTimer?.cancel();
    _popupTimer = null;
    _popupEntry?.remove();
    _popupEntry = null;
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

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
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
              onTap: () {
                _showKeyPreview();
                widget.onPressed(key);
              },
              child: Center(
                child: _buildKeyContent(),
              ),
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
        if (widget.type == KeyboardType.multiline) {
          return Icon(
            Icons.keyboard_return,
            size: widget.theme.keyTextSize,
            color: widget.theme.keyTextColor,
          );
        }
        return Text(
          _getActionLabel(),
          style: TextStyle(
            fontSize: widget.theme.keyTextSize * 0.7,
            color: widget.theme.keyTextColor,
          ),
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

class _KeyPreviewBubble extends StatelessWidget {
  const _KeyPreviewBubble({
    required this.text,
    required this.width,
    required this.height,
    required this.theme,
  });

  final String text;
  final double width;
  final double height;
  final VirtualKeypadTheme theme;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.keyColor,
          borderRadius: BorderRadius.circular(theme.keyBorderRadius + 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: theme.keyTextSize * 1.4,
            fontWeight: FontWeight.w500,
            color: theme.keyTextColor,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
