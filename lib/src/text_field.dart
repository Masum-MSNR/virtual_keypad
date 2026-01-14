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
    this.readOnly = false,
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

  /// Whether the text field is read-only (display only, no editing).
  /// This is different from blocking the system keyboard - this makes
  /// the field completely non-editable.
  final bool readOnly;

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
  final GlobalKey _textFieldKey = GlobalKey();
  bool _isActiveInScope = false;
  VirtualKeypadScopeState? _scope;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _focusNode = _ProtectedFocusNode();
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
    } else {
      // Clear the active controller when focus is lost
      _clearScopeCallbacks();
      _scope?.clearActiveController();
      _focusNode.setProtectFocus(false);
      _isActiveInScope = false;
    }
    setState(() {});
  }

  void _onControllerChanged() {
    final currentText = widget.controller.text;
    final textChanged = currentText != _previousText;
    _previousText = currentText;
    
    widget.onChanged?.call(currentText);
    
    // Scroll to cursor when text changes (typing/deleting)
    if (textChanged) {
      _ensureCursorVisible();
    }
  }

  void _ensureCursorVisible() {
    // Schedule after frame to ensure layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final selection = widget.controller.selection;
      if (!selection.isValid || !selection.isCollapsed) return;
      
      // Find the RenderEditable inside the TextField
      final textFieldContext = _textFieldKey.currentContext;
      if (textFieldContext == null) return;
      
      // Walk down the tree to find the EditableText
      void visitChildren(Element element) {
        if (element.widget is EditableText) {
          final editableTextState = (element as StatefulElement).state as EditableTextState;
          editableTextState.bringIntoView(TextPosition(offset: selection.baseOffset));
          return;
        }
        element.visitChildren(visitChildren);
      }
      
      (textFieldContext as Element).visitChildren(visitChildren);
    });
  }

  void _registerWithScope() {
    // Don't register if disabled or readOnly (no keyboard input allowed)
    if (_scope != null && widget.enabled && !widget.readOnly) {
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

  /// Handle paste from clipboard manually since readOnly blocks default paste
  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      final selection = widget.controller.selection;
      if (selection.isValid) {
        // Replace selection or insert at cursor
        widget.controller.replaceRange(
          selection.start,
          selection.end,
          data.text!,
        );
      }
    }
  }

  /// Build custom context menu with working paste option
  Widget _buildContextMenu(BuildContext context, EditableTextState editableTextState) {
    final List<ContextMenuButtonItem> buttonItems = [];
    
    // Cut - only if there's a selection and not readOnly for physical keyboard
    if (!editableTextState.textEditingValue.selection.isCollapsed) {
      buttonItems.add(ContextMenuButtonItem(
        label: 'Cut',
        onPressed: () {
          final selection = widget.controller.selection;
          if (selection.isValid && !selection.isCollapsed) {
            final selectedText = widget.controller.text.substring(
              selection.start,
              selection.end,
            );
            Clipboard.setData(ClipboardData(text: selectedText));
            widget.controller.deleteRange(selection.start, selection.end);
          }
          editableTextState.hideToolbar();
        },
      ));
    }
    
    // Copy - only if there's a selection
    if (!editableTextState.textEditingValue.selection.isCollapsed) {
      buttonItems.add(ContextMenuButtonItem(
        label: 'Copy',
        onPressed: () {
          editableTextState.copySelection(SelectionChangedCause.toolbar);
        },
      ));
    }
    
    // Paste - always available (we handle it manually)
    buttonItems.add(ContextMenuButtonItem(
      label: 'Paste',
      onPressed: () {
        _handlePaste();
        editableTextState.hideToolbar();
      },
    ));
    
    // Select All
    buttonItems.add(ContextMenuButtonItem(
      label: 'Select All',
      onPressed: () {
        editableTextState.selectAll(SelectionChangedCause.toolbar);
      },
    ));
    
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
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
      key: _textFieldKey,
      controller: widget.controller,
      focusNode: _focusNode,
      decoration: widget.decoration,
      style: widget.style,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      enabled: widget.enabled,
      // readOnly if user set it OR if blocking system keyboard
      readOnly: widget.readOnly || !widget.allowPhysicalKeyboard,
      showCursor: !widget.readOnly,  // Hide cursor if truly readOnly
      autofocus: widget.autofocus,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLength != null
          ? MaxLengthEnforcement.enforced
          : MaxLengthEnforcement.none,
      keyboardType: widget.allowPhysicalKeyboard
          ? widget.keyboardType
          : TextInputType.none,
      enableInteractiveSelection: true,
      onTap: _handleTap,
      onSubmitted: widget.onSubmitted,
      contextMenuBuilder: _buildContextMenu,
    );
  }
}
