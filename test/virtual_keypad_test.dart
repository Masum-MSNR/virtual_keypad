import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      controller.selection =
          const TextSelection(baseOffset: 6, extentOffset: 11);
      controller.insertText('Flutter');
      expect(controller.text, 'Hello Flutter');
      expect(controller.cursorPosition, 13);
    });

    test('deleteBackward removes selection', () {
      final controller = VirtualKeypadController(text: 'Hello World');
      // Select "World"
      controller.selection =
          const TextSelection(baseOffset: 6, extentOffset: 11);
      controller.deleteBackward();
      expect(controller.text, 'Hello ');
      expect(controller.cursorPosition, 6);
    });
  });

  group('StandaloneInputControl', () {
    test('insertText modifies current value', () {
      final control = StandaloneInputControl();
      // Simulate attach with initial empty value
      control.setEditingState(TextEditingValue.empty.copyWith(
        selection: const TextSelection.collapsed(offset: 0),
      ));
      control.insertText('Hi');
      expect(control.currentValue.text, 'Hi');
      expect(control.currentValue.selection.baseOffset, 2);
    });

    test('deleteBackward removes character', () {
      final control = StandaloneInputControl();
      control.setEditingState(const TextEditingValue(
        text: 'Hello',
        selection: TextSelection.collapsed(offset: 5),
      ));
      control.deleteBackward();
      expect(control.currentValue.text, 'Hell');
      expect(control.currentValue.selection.baseOffset, 4);
    });

    test('deleteBackward removes selection', () {
      final control = StandaloneInputControl();
      control.setEditingState(const TextEditingValue(
        text: 'Hello World',
        selection: TextSelection(baseOffset: 5, extentOffset: 11),
      ));
      control.deleteBackward();
      expect(control.currentValue.text, 'Hello');
      expect(control.currentValue.selection.baseOffset, 5);
    });

    test('insertText replaces selection', () {
      final control = StandaloneInputControl();
      control.setEditingState(const TextEditingValue(
        text: 'Hello World',
        selection: TextSelection(baseOffset: 6, extentOffset: 11),
      ));
      control.insertText('Flutter');
      expect(control.currentValue.text, 'Hello Flutter');
      expect(control.currentValue.selection.baseOffset, 13);
    });

    test('keyboardType defaults to text', () {
      final control = StandaloneInputControl();
      expect(control.keyboardType, KeyboardType.text);
    });

    test('isAttached tracks attach/detach', () {
      final control = StandaloneInputControl();
      expect(control.isAttached, false);
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

  group('VirtualKeypadStandaloneScope', () {
    testWidgets('maybeOf returns null when no scope in tree', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              capturedContext = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(
        VirtualKeypadStandaloneScope.maybeOf(capturedContext),
        isNull,
      );
    });

    testWidgets('maybeOf returns state when scope is ancestor', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: VirtualKeypadStandaloneScope(
            child: Builder(
              builder: (ctx) {
                capturedContext = ctx;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(
        VirtualKeypadStandaloneScope.maybeOf(capturedContext),
        isA<VirtualKeypadStandaloneScopeState>(),
      );
    });

    testWidgets('two sibling scopes return different state instances',
        (tester) async {
      late BuildContext contextA;
      late BuildContext contextB;
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              VirtualKeypadStandaloneScope(
                child: Builder(builder: (ctx) {
                  contextA = ctx;
                  return const SizedBox.shrink();
                }),
              ),
              VirtualKeypadStandaloneScope(
                child: Builder(builder: (ctx) {
                  contextB = ctx;
                  return const SizedBox.shrink();
                }),
              ),
            ],
          ),
        ),
      );
      final scopeA = VirtualKeypadStandaloneScope.maybeOf(contextA);
      final scopeB = VirtualKeypadStandaloneScope.maybeOf(contextB);
      expect(scopeA, isNotNull);
      expect(scopeB, isNotNull);
      expect(scopeA, isNot(same(scopeB)));
    });
  });
}
