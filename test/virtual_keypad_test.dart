import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  group('VirtualKeypadController', () {
    test('insertText adds text at cursor position', () {
      final controller = VirtualKeypadController();
      controller.insertText('Hello');
      expect(controller.text, 'Hello');
      expect(controller.cursorPosition, 5);
    });

    test('deleteBackward removes character before cursor', () {
      final controller = VirtualKeypadController(text: 'Hello');
      controller.cursorPosition = 5;
      controller.deleteBackward();
      expect(controller.text, 'Hell');
      expect(controller.cursorPosition, 4);
    });

    test('clear removes all text', () {
      final controller = VirtualKeypadController(text: 'Hello');
      controller.clear();
      expect(controller.text, '');
      expect(controller.cursorPosition, 0);
    });

    test('insertText at middle position', () {
      final controller = VirtualKeypadController(text: 'Helo');
      controller.cursorPosition = 3;
      controller.insertText('l');
      expect(controller.text, 'Hello');
      expect(controller.cursorPosition, 4);
    });

    test('selectAll selects entire text', () {
      final controller = VirtualKeypadController(text: 'Hello');
      controller.selectAll();
      expect(controller.selection.start, 0);
      expect(controller.selection.end, 5);
      expect(controller.selection.isCollapsed, false);
    });

    test('insertText replaces selection', () {
      final controller = VirtualKeypadController(text: 'Hello World');
      // Select "World"
      controller.selection = const TextSelection(baseOffset: 6, extentOffset: 11);
      controller.insertText('Flutter');
      expect(controller.text, 'Hello Flutter');
      expect(controller.cursorPosition, 13);
    });

    test('deleteBackward removes selection', () {
      final controller = VirtualKeypadController(text: 'Hello World');
      // Select "World"
      controller.selection = const TextSelection(baseOffset: 6, extentOffset: 11);
      controller.deleteBackward();
      expect(controller.text, 'Hello ');
      expect(controller.cursorPosition, 6);
    });
  });

  group('VirtualKey', () {
    test('character key returns correct display text', () {
      final key = VirtualKey.character(text: 'a');
      expect(key.getDisplayText(), 'a');
      expect(key.getDisplayText(shift: true), 'A');
      expect(key.getDisplayText(capsLock: true), 'A');
    });

    test('action key is identified correctly', () {
      final key = VirtualKey.action(action: KeyAction.backSpace);
      expect(key.isAction, true);
      expect(key.isCharacter, false);
    });
  });
}
