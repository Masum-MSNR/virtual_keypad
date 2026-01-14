import 'package:flutter/material.dart';

class VirtualKeypadController extends TextEditingController {
  VirtualKeypadController({super.text});

  int get cursorPosition {
    if (selection.isValid && selection.isCollapsed) {
      return selection.baseOffset;
    }
    return text.length;
  }

  set cursorPosition(int position) {
    final clampedPos = position.clamp(0, text.length);
    selection = TextSelection.collapsed(offset: clampedPos);
  }

  void insertText(String newText) {
    final pos = cursorPosition;
    final before = text.substring(0, pos);
    final after = text.substring(pos);
    final newCursorPos = pos + newText.length;

    value = TextEditingValue(
      text: before + newText + after,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }

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

  void moveCursorLeft() {
    final pos = cursorPosition;
    if (pos > 0) {
      selection = TextSelection.collapsed(offset: pos - 1);
    }
  }

  void moveCursorRight() {
    final pos = cursorPosition;
    if (pos < text.length) {
      selection = TextSelection.collapsed(offset: pos + 1);
    }
  }

  void moveCursorToEnd() {
    selection = TextSelection.collapsed(offset: text.length);
  }

  void moveCursorToStart() {
    selection = TextSelection.collapsed(offset: 0);
  }

  void deleteRange(int start, int end) {
    if (start < 0 || end > text.length || start >= end) return;

    final before = text.substring(0, start);
    final after = text.substring(end);

    value = TextEditingValue(
      text: before + after,
      selection: TextSelection.collapsed(offset: start),
    );
  }

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
