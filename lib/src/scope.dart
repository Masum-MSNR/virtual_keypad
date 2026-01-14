import 'package:flutter/material.dart';
import 'controller.dart';

class VirtualKeypadScope extends StatefulWidget {
  const VirtualKeypadScope({
    super.key,
    required this.child,
  });

  final Widget child;

  static VirtualKeypadScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<VirtualKeypadScopeState>();
  }

  @override
  State<VirtualKeypadScope> createState() => VirtualKeypadScopeState();
}

class VirtualKeypadScopeState extends State<VirtualKeypadScope> {
  VirtualKeypadController? _activeController;
  int? _activeMaxLength;
  final List<VoidCallback> _listeners = [];

  bool Function()? _deleteSelectionCallback;
  (int, int)? Function()? _getSelectionCallback;
  VoidCallback? _clearSelectionCallback;

  VirtualKeypadController? get activeController => _activeController;
  int? get activeMaxLength => _activeMaxLength;
  bool get hasActiveController => _activeController != null;

  void addActiveControllerListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeActiveControllerListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void setDeleteSelectionCallback(bool Function()? callback) {
    _deleteSelectionCallback = callback;
  }

  void setGetSelectionCallback((int, int)? Function()? callback) {
    _getSelectionCallback = callback;
  }

  void setClearSelectionCallback(VoidCallback? callback) {
    _clearSelectionCallback = callback;
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void setActiveController(
    VirtualKeypadController? controller, {
    int? maxLength,
  }) {
    if (_activeController != controller) {
      setState(() {
        _activeController = controller;
        _activeMaxLength = maxLength;
      });
      _notifyListeners();
    }
  }

  void clearActiveController() {
    if (_activeController != null) {
      setState(() {
        _activeController = null;
        _activeMaxLength = null;
      });
      _notifyListeners();
    }
  }

  void insertText(String text) {
    if (_activeController != null) {
      final maxLen = _activeMaxLength;

      final selection = _getSelectionCallback?.call();
      if (selection != null) {
        final (start, end) = selection;
        final newLength = _activeController!.text.length - (end - start) + text.length;
        if (maxLen != null && newLength > maxLen) return;
        _activeController!.replaceRange(start, end, text);
        _clearSelectionCallback?.call();
        return;
      }

      if (maxLen != null && _activeController!.text.length >= maxLen) return;
      _activeController!.insertText(text);
    }
  }

  void deleteBackward() {
    if (_deleteSelectionCallback != null && _deleteSelectionCallback!()) return;
    _activeController?.deleteBackward();
  }

  void clear() {
    _activeController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _VirtualKeypadScopeInherited(
      state: this,
      child: widget.child,
    );
  }
}

class _VirtualKeypadScopeInherited extends InheritedWidget {
  const _VirtualKeypadScopeInherited({
    required this.state,
    required super.child,
  });

  final VirtualKeypadScopeState state;

  @override
  bool updateShouldNotify(_VirtualKeypadScopeInherited oldWidget) {
    return state.activeController != oldWidget.state.activeController;
  }
}

