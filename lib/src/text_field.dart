import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controller.dart';
import 'scope.dart';

class VirtualKeypadTextField extends StatefulWidget {
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

  final VirtualKeypadController controller;
  final InputDecoration? decoration;
  final TextStyle? style;
  final int? maxLength;
  final bool obscureText;
  final String obscuringCharacter;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final bool allowPhysicalKeyboard;
  final TextInputType? keyboardType;

  @override
  State<VirtualKeypadTextField> createState() => _VirtualKeypadTextFieldState();
}

class _VirtualKeypadTextFieldState extends State<VirtualKeypadTextField> {
  late FocusNode _focusNode;
  final GlobalKey _textFieldKey = GlobalKey();
  bool _isActiveInScope = false;
  VirtualKeypadScopeState? _scope;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onControllerChanged);
    _previousText = widget.controller.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    final isActive = _scope?.activeController == widget.controller;

    if (isActive != _isActiveInScope) {
      _isActiveInScope = isActive;

      if (isActive && !_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }

      if (mounted) setState(() {});
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _registerWithScope();
    } else {
      _clearScopeCallbacks();
      _scope?.clearActiveController();
      _isActiveInScope = false;
    }
    setState(() {});
  }

  void _onControllerChanged() {
    final currentText = widget.controller.text;
    final textChanged = currentText != _previousText;
    _previousText = currentText;

    widget.onChanged?.call(currentText);

    if (textChanged) {
      _ensureCursorVisible();
    }
  }

  void _ensureCursorVisible() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final selection = widget.controller.selection;
      if (!selection.isValid || !selection.isCollapsed) return;

      final textFieldContext = _textFieldKey.currentContext;
      if (textFieldContext == null) return;

      void visitChildren(Element element) {
        if (element.widget is EditableText) {
          final editableTextState =
              (element as StatefulElement).state as EditableTextState;
          editableTextState
              .bringIntoView(TextPosition(offset: selection.baseOffset));
          return;
        }
        element.visitChildren(visitChildren);
      }

      (textFieldContext as Element).visitChildren(visitChildren);
    });
  }

  void _registerWithScope() {
    if (_scope != null && widget.enabled && !widget.readOnly) {
      _scope!
          .setActiveController(widget.controller, maxLength: widget.maxLength);
      _scope!.setDeleteSelectionCallback(_deleteSelection);
      _scope!.setGetSelectionCallback(_getSelection);
      _scope!.setClearSelectionCallback(_clearSelection);

      _isActiveInScope = true;
    }
  }

  void _clearScopeCallbacks() {
    _scope?.setDeleteSelectionCallback(null);
    _scope?.setGetSelectionCallback(null);
    _scope?.setClearSelectionCallback(null);
  }

  void unfocus() {
    _isActiveInScope = false;
    _focusNode.unfocus();
    _clearScopeCallbacks();
    setState(() {});
  }

  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      final selection = widget.controller.selection;
      if (selection.isValid) {
        widget.controller.replaceRange(
          selection.start,
          selection.end,
          data.text!,
        );
      }
    }
  }

  Widget _buildContextMenu(
      BuildContext context, EditableTextState editableTextState) {
    final List<ContextMenuButtonItem> buttonItems = [];

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

    if (!editableTextState.textEditingValue.selection.isCollapsed) {
      buttonItems.add(ContextMenuButtonItem(
        label: 'Copy',
        onPressed: () {
          editableTextState.copySelection(SelectionChangedCause.toolbar);
        },
      ));
    }

    buttonItems.add(ContextMenuButtonItem(
      label: 'Paste',
      onPressed: () {
        _handlePaste();
        editableTextState.hideToolbar();
      },
    ));

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
      readOnly: widget.readOnly || !widget.allowPhysicalKeyboard,
      showCursor: !widget.readOnly,
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
