import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controller.dart';
import 'scope.dart';

/// A FocusNode that can be prevented from losing focus.
/// Used to keep the text field focused while interacting with the virtual keyboard.
class _ProtectedFocusNode extends FocusNode {
  bool _protectFocus = false;

  void setProtectFocus(bool value) {
    _protectFocus = value;
  }

  @override
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    // Only allow unfocus if not protected
    if (!_protectFocus) {
      super.unfocus(disposition: disposition);
    }
  }
}

/// A text field that integrates with [VirtualKeypad] through [VirtualKeypadScope].
///
/// This widget:
/// - Can prevent the system keyboard from appearing (when allowPhysicalKeyboard is false)
/// - Maintains focus/cursor visibility while using the virtual keyboard
/// - Integrates with VirtualKeypadScope for keyboard input
/// - Optionally allows physical keyboard input alongside virtual keyboard
///
/// Example:
/// ```dart
/// VirtualKeypadScope(
///   child: Column(
///     children: [
///       VirtualKeypadTextField(
///         controller: controller,
///         decoration: InputDecoration(labelText: 'Password'),
///         obscureText: true,
///       ),
///       VirtualKeypad(),
///     ],
///   ),
/// )
/// ```
class VirtualKeypadTextField extends StatefulWidget {
  /// Creates a text field for use with the virtual keypad.
  const VirtualKeypadTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.style,
    this.maxLength,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.enabled = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.allowPhysicalKeyboard = false,
    this.keyboardType,
  });

  /// Controller for the text field.
  final VirtualKeypadController controller;

  /// Decoration for the text field (border, label, etc.).
  final InputDecoration? decoration;

  /// Style for the text.
  final TextStyle? style;

  /// Maximum length of the text.
  final int? maxLength;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Character used when obscuring text.
  final String obscuringCharacter;

  /// Whether the text field is enabled.
  final bool enabled;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// How to align the text horizontally.
  final TextAlign textAlign;

  /// How to align the text vertically.
  final TextAlignVertical? textAlignVertical;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the text field is tapped.
  final VoidCallback? onTap;

  /// Called when the user submits (presses enter).
  final ValueChanged<String>? onSubmitted;

  /// Whether to allow physical/system keyboard input.
  /// When false (default), only the virtual keyboard can input text.
  /// When true, both physical keyboard and virtual keyboard work together.
  final bool allowPhysicalKeyboard;

  /// The type of keyboard to show when [allowPhysicalKeyboard] is true.
  /// Ignored when [allowPhysicalKeyboard] is false.
  final TextInputType? keyboardType;

  @override
  State<VirtualKeypadTextField> createState() => _VirtualKeypadTextFieldState();
}

class _VirtualKeypadTextFieldState extends State<VirtualKeypadTextField> {
  late _ProtectedFocusNode _focusNode;
  late ScrollController _scrollController;
  bool _isActiveInScope = false;
  VirtualKeypadScopeState? _scope;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _focusNode = _ProtectedFocusNode();
    _scrollController = ScrollController();
    _focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onControllerChanged);
    _previousText = widget.controller.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to scope changes and cache the scope reference
    final newScope = VirtualKeypadScope.of(context);
    if (_scope != newScope) {
      _scope?.removeActiveControllerListener(_onScopeChanged);
      _scope = newScope;
      _scope?.addActiveControllerListener(_onScopeChanged);
    }
    _updateActiveState();
  }

  @override
  void didUpdateWidget(VirtualKeypadTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    // Clear callbacks first using cached _scope (safe in dispose)
    _clearScopeCallbacks();
    _scope?.removeActiveControllerListener(_onScopeChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _scrollController.dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onScopeChanged() {
    _updateActiveState();
  }

  void _updateActiveState() {
    // Use cached _scope reference - don't look up ancestors
    final isActive = _scope?.activeController == widget.controller;

    if (isActive != _isActiveInScope) {
      _isActiveInScope = isActive;

      // Protect focus while this field is active in the scope
      _focusNode.setProtectFocus(isActive);

      if (isActive && !_focusNode.hasFocus) {
        // Ensure we have Flutter focus when we're active in scope
        _focusNode.requestFocus();
      } else if (!isActive && _focusNode.hasFocus) {
        // Unfocus when we're no longer active in scope
        _focusNode.unfocus();
      }

      if (mounted) setState(() {});
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _registerWithScope();
    }
    setState(() {});
  }

  void _onControllerChanged() {
    final currentText = widget.controller.text;
    final textChanged = currentText != _previousText;
    _previousText = currentText;
    
    widget.onChanged?.call(currentText);
    
    // Only scroll to cursor if text content actually changed (typing/deleting)
    // Not when selection changes (user dragging to select)
    if (textChanged) {
      _scrollToCursor();
    }
  }

  void _scrollToCursor() {
    // Schedule scroll after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      final selection = widget.controller.selection;
      if (!selection.isValid) return;
      
      // For TextField, we need to ensure the cursor position is visible
      // The TextField's internal EditableText handles this when focused,
      // but we need to help when using virtual keyboard
      
      if (widget.maxLines == 1) {
        // For single line, scroll to show cursor
        // We'll scroll to max if cursor is at end, otherwise let Flutter handle it
        final cursorPos = selection.baseOffset;
        final textLength = widget.controller.text.length;
        
        if (cursorPos >= textLength) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeOut,
          );
        }
      } else {
        // For multiline, scroll to show the cursor line
        final cursorPos = selection.baseOffset;
        final textLength = widget.controller.text.length;
        
        // If cursor is at or near the end, scroll to bottom
        if (cursorPos >= textLength * 0.9 || cursorPos >= textLength) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _registerWithScope() {
    if (_scope != null && widget.enabled) {
      _scope!
          .setActiveController(widget.controller, maxLength: widget.maxLength);
      _scope!.setDeleteSelectionCallback(_deleteSelection);
      _scope!.setGetSelectionCallback(_getSelection);
      _scope!.setClearSelectionCallback(_clearSelection);

      // Protect focus while we're active
      _focusNode.setProtectFocus(true);
      _isActiveInScope = true;
    }
  }

  void _clearScopeCallbacks() {
    // Use cached _scope reference - don't look up ancestors (unsafe in dispose)
    _scope?.setDeleteSelectionCallback(null);
    _scope?.setGetSelectionCallback(null);
    _scope?.setClearSelectionCallback(null);
  }

  /// Called when this field should be unfocused (e.g., tapping outside)
  void unfocus() {
    _focusNode.setProtectFocus(false);
    _isActiveInScope = false;
    _focusNode.unfocus();
    _clearScopeCallbacks();
    setState(() {});
  }

  bool _deleteSelection() {
    final selection = widget.controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      widget.controller.deleteRange(selection.start, selection.end);
      return true;
    }
    return false;
  }

  (int, int)? _getSelection() {
    final selection = widget.controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      return (selection.start, selection.end);
    }
    return null;
  }

  void _clearSelection() {
    final pos = widget.controller.selection.start;
    widget.controller.selection = TextSelection.collapsed(offset: pos);
  }

  void _handleTap() {
    if (!widget.enabled) return;
    _registerWithScope();
    _focusNode.requestFocus();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      scrollController: _scrollController,
      decoration: widget.decoration,
      style: widget.style,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      enabled: widget.enabled,
      // When allowPhysicalKeyboard is false, use readOnly to prevent system keyboard
      // When true, allow normal editing
      readOnly: !widget.allowPhysicalKeyboard,
      showCursor: true,
      autofocus: widget.autofocus,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLength != null
          ? MaxLengthEnforcement.enforced
          : MaxLengthEnforcement.none,
      // When allowPhysicalKeyboard is false, use TextInputType.none to suppress keyboard
      // When true, use the specified keyboardType or default
      keyboardType: widget.allowPhysicalKeyboard
          ? widget.keyboardType
          : TextInputType.none,
      enableInteractiveSelection: true,
      onTap: _handleTap,
      onSubmitted: widget.onSubmitted,
      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar.editableText(
          editableTextState: editableTextState,
        );
      },
    );
  }
}
