import 'package:flutter/material.dart';
import 'controller.dart';

/// A scope that manages the connection between [VirtualKeypadTextField] and [VirtualKeypad].
///
/// Wrap your widget tree with [VirtualKeypadScope] to enable automatic
/// keyboard-to-textfield connection. The keyboard will automatically detect
/// which text field is focused and send input to it.
///
/// Example:
/// ```dart
/// VirtualKeypadScope(
///   child: Column(
///     children: [
///       VirtualKeypadTextField(controller: controller1),
///       VirtualKeypadTextField(controller: controller2),
///       VirtualKeypad(), // Automatically connects to focused field
///     ],
///   ),
/// )
/// ```
class VirtualKeypadScope extends StatefulWidget {
  /// Creates a scope for managing keyboard-textfield connections.
  const VirtualKeypadScope({
    super.key,
    required this.child,
  });

  /// The child widget tree.
  final Widget child;

  /// Gets the [VirtualKeypadScopeState] from the given context.
  static VirtualKeypadScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<VirtualKeypadScopeState>();
  }

  @override
  State<VirtualKeypadScope> createState() => VirtualKeypadScopeState();
}

/// State for [VirtualKeypadScope].
class VirtualKeypadScopeState extends State<VirtualKeypadScope> {
  VirtualKeypadController? _activeController;
  int? _activeMaxLength;
  final List<VoidCallback> _listeners = [];

  /// Callback for deleting selection when backspace is pressed.
  /// Returns true if selection was deleted, false if regular backspace should happen.
  bool Function()? _deleteSelectionCallback;

  /// Callback to get current selection range. Returns (start, end) or null if no selection.
  (int, int)? Function()? _getSelectionCallback;

  /// Callback to clear selection after replacement.
  VoidCallback? _clearSelectionCallback;

  /// The currently active (focused) controller.
  VirtualKeypadController? get activeController => _activeController;

  /// The max length of the currently active field.
  int? get activeMaxLength => _activeMaxLength;

  /// Whether there is an active controller.
  bool get hasActiveController => _activeController != null;

  /// Add a listener for active controller changes.
  void addActiveControllerListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Remove a listener for active controller changes.
  void removeActiveControllerListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Sets the delete selection callback for the current active field.
  void setDeleteSelectionCallback(bool Function()? callback) {
    _deleteSelectionCallback = callback;
  }

  /// Sets the get selection callback for the current active field.
  void setGetSelectionCallback((int, int)? Function()? callback) {
    _getSelectionCallback = callback;
  }

  /// Sets the clear selection callback for the current active field.
  void setClearSelectionCallback(VoidCallback? callback) {
    _clearSelectionCallback = callback;
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Sets the active controller (called when a text field gains focus).
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

  /// Clears the active controller.
  void clearActiveController() {
    if (_activeController != null) {
      setState(() {
        _activeController = null;
        _activeMaxLength = null;
      });
      _notifyListeners();
    }
  }

  /// Inserts text into the active controller.
  /// If there's a selection, replaces the selected text.
  void insertText(String text) {
    if (_activeController != null) {
      final maxLen = _activeMaxLength;

      // Check if there's a selection to replace
      final selection = _getSelectionCallback?.call();
      if (selection != null) {
        final (start, end) = selection;
        final newLength =
            _activeController!.text.length - (end - start) + text.length;
        if (maxLen != null && newLength > maxLen) {
          return;
        }
        _activeController!.replaceRange(start, end, text);
        _clearSelectionCallback?.call();
        return;
      }

      if (maxLen != null && _activeController!.text.length >= maxLen) {
        return;
      }
      _activeController!.insertText(text);
    }
  }

  /// Deletes the character before the cursor in the active controller.
  /// First checks if there's a selection to delete.
  void deleteBackward() {
    // First try to delete selection if any
    if (_deleteSelectionCallback != null && _deleteSelectionCallback!()) {
      return; // Selection was deleted
    }
    // Otherwise, delete single character
    _activeController?.deleteBackward();
  }

  /// Clears the active controller's text.
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
