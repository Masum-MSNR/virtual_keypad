import 'package:flutter/material.dart';

/// A controller for [VirtualKeypadTextField] that extends [TextEditingController].
///
/// This controller uses Flutter's selection property for cursor position
/// and provides methods for text manipulation that work with virtual keyboards.
///
/// Example:
/// ```dart
/// final controller = VirtualKeypadController();
/// controller.insertText('Hello');
/// print(controller.text); // 'Hello'
/// print(controller.cursorPosition); // 5
/// ```
class VirtualKeypadController extends TextEditingController {
  /// Creates a new controller with optional initial text.
  VirtualKeypadController({super.text});

  /// The current cursor position in the text.
  /// Returns the selection's base offset, or the end of text if selection is invalid.
  int get cursorPosition {
    if (selection.isValid && selection.isCollapsed) {
      return selection.baseOffset;
    }
    return text.length;
  }

  /// Sets the cursor position, clamped to valid range.
  set cursorPosition(int position) {
    final clampedPos = position.clamp(0, text.length);
    selection = TextSelection.collapsed(offset: clampedPos);
  }

  /// Inserts text at the current cursor position.
  void insertText(String newText) {
    final pos = cursorPosition;
    final before = text.substring(0, pos);
    final after = text.substring(pos);
    final newCursorPos = pos + newText.length;

    // Use value setter to set both text and selection atomically
    value = TextEditingValue(
      text: before + newText + after,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }

  /// Deletes the character before the cursor (backspace).
  void deleteBackward() {
    final pos = cursorPosition;
    if (pos > 0 && text.isNotEmpty) {
      final before = text.substring(0, pos - 1);
      final after = text.substring(pos);
      final newCursorPos = pos - 1;

      value = TextEditingValue(
        text: before + after,
        selection: TextSelection.collapsed(offset: newCursorPos),
      );
    }
  }

  /// Deletes the character after the cursor (delete key).
  void deleteForward() {
    final pos = cursorPosition;
    if (pos < text.length && text.isNotEmpty) {
      final before = text.substring(0, pos);
      final after = text.substring(pos + 1);

      value = TextEditingValue(
        text: before + after,
        selection: TextSelection.collapsed(offset: pos),
      );
    }
  }

  @override
  void clear() {
    value = const TextEditingValue(
      text: '',
      selection: TextSelection.collapsed(offset: 0),
    );
  }

  /// Moves the cursor one position to the left.
  void moveCursorLeft() {
    final pos = cursorPosition;
    if (pos > 0) {
      selection = TextSelection.collapsed(offset: pos - 1);
    }
  }

  /// Moves the cursor one position to the right.
  void moveCursorRight() {
    final pos = cursorPosition;
    if (pos < text.length) {
      selection = TextSelection.collapsed(offset: pos + 1);
    }
  }

  /// Moves the cursor to the end of the text.
  void moveCursorToEnd() {
    selection = TextSelection.collapsed(offset: text.length);
  }

  /// Moves the cursor to the start of the text.
  void moveCursorToStart() {
    selection = TextSelection.collapsed(offset: 0);
  }

  /// Deletes text in the given range and moves cursor to start of range.
  void deleteRange(int start, int end) {
    if (start < 0 || end > text.length || start >= end) return;

    final before = text.substring(0, start);
    final after = text.substring(end);

    value = TextEditingValue(
      text: before + after,
      selection: TextSelection.collapsed(offset: start),
    );
  }

  /// Replaces text in the given range with new text.
  void replaceRange(int start, int end, String replacement) {
    if (start < 0 || end > text.length || start > end) return;

    final before = text.substring(0, start);
    final after = text.substring(end);
    final newCursorPos = start + replacement.length;

    value = TextEditingValue(
      text: before + replacement + after,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }
}
