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
      controller.selection = const TextSelection(
        baseOffset: 6,
        extentOffset: 11,
      );
      controller.insertText('Flutter');
      expect(controller.text, 'Hello Flutter');
      expect(controller.cursorPosition, 13);
    });

    test('deleteBackward removes selection', () {
      final controller = VirtualKeypadController(text: 'Hello World');
      // Select "World"
      controller.selection = const TextSelection(
        baseOffset: 6,
        extentOffset: 11,
      );
      controller.deleteBackward();
      expect(controller.text, 'Hello ');
      expect(controller.cursorPosition, 6);
    });
  });

  group('StandaloneInputControl', () {
    test('insertText modifies current value', () {
      final control = StandaloneInputControl();
      // Simulate attach with initial empty value
      control.setEditingState(
        TextEditingValue.empty.copyWith(
          selection: const TextSelection.collapsed(offset: 0),
        ),
      );
      control.insertText('Hi');
      expect(control.currentValue.text, 'Hi');
      expect(control.currentValue.selection.baseOffset, 2);
    });

    test('deleteBackward removes character', () {
      final control = StandaloneInputControl();
      control.setEditingState(
        const TextEditingValue(
          text: 'Hello',
          selection: TextSelection.collapsed(offset: 5),
        ),
      );
      control.deleteBackward();
      expect(control.currentValue.text, 'Hell');
      expect(control.currentValue.selection.baseOffset, 4);
    });

    test('deleteBackward removes selection', () {
      final control = StandaloneInputControl();
      control.setEditingState(
        const TextEditingValue(
          text: 'Hello World',
          selection: TextSelection(baseOffset: 5, extentOffset: 11),
        ),
      );
      control.deleteBackward();
      expect(control.currentValue.text, 'Hello');
      expect(control.currentValue.selection.baseOffset, 5);
    });

    test('insertText replaces selection', () {
      final control = StandaloneInputControl();
      control.setEditingState(
        const TextEditingValue(
          text: 'Hello World',
          selection: TextSelection(baseOffset: 6, extentOffset: 11),
        ),
      );
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
      expect(VirtualKeypadStandaloneScope.maybeOf(capturedContext), isNull);
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

    testWidgets('two sibling scopes return different state instances', (
      tester,
    ) async {
      late BuildContext contextA;
      late BuildContext contextB;
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              VirtualKeypadStandaloneScope(
                child: Builder(
                  builder: (ctx) {
                    contextA = ctx;
                    return const SizedBox.shrink();
                  },
                ),
              ),
              VirtualKeypadStandaloneScope(
                child: Builder(
                  builder: (ctx) {
                    contextB = ctx;
                    return const SizedBox.shrink();
                  },
                ),
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

  group('VirtualKeypad form navigation', () {
    testWidgets('next action moves focus to the next scoped field', (
      tester,
    ) async {
      final firstController = VirtualKeypadController();
      final secondController = VirtualKeypadController();
      var firstSubmitted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: firstController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => firstSubmitted = true,
                  ),
                  VirtualKeypadTextField(
                    controller: secondController,
                    textInputAction: TextInputAction.done,
                  ),
                  const VirtualKeypad(),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField).at(0));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(0))
            .focusNode
            ?.hasFocus,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.keyboard_tab));
      await tester.pumpAndSettle();

      expect(firstSubmitted, isTrue);
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(0))
            .focusNode
            ?.hasFocus,
        isFalse,
      );
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(1))
            .focusNode
            ?.hasFocus,
        isTrue,
      );
    });

    testWidgets('previous action moves focus to the previous scoped field', (
      tester,
    ) async {
      final firstController = VirtualKeypadController();
      final secondController = VirtualKeypadController();
      var secondSubmitted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: firstController,
                    textInputAction: TextInputAction.done,
                  ),
                  VirtualKeypadTextField(
                    controller: secondController,
                    textInputAction: TextInputAction.previous,
                    onSubmitted: (_) => secondSubmitted = true,
                  ),
                  const VirtualKeypad(),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField).at(1));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(1))
            .focusNode
            ?.hasFocus,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.keyboard_tab));
      await tester.pumpAndSettle();

      expect(secondSubmitted, isTrue);
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(0))
            .focusNode
            ?.hasFocus,
        isTrue,
      );
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(1))
            .focusNode
            ?.hasFocus,
        isFalse,
      );
    });
  });

  group('VirtualKeypad action handling', () {
    testWidgets('custom search action reports the pressed action', (
      tester,
    ) async {
      final controller = VirtualKeypadController(text: 'query');
      KeyAction? action;
      String? submittedText;
      var submitted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: controller,
                    onInputAction: (pressedAction, text) {
                      action = pressedAction;
                      submittedText = text;
                    },
                    onSubmitted: (_) => submitted = true,
                  ),
                  VirtualKeypad(
                    type: KeyboardType.custom,
                    customLayout: [
                      [VirtualKey.action(action: KeyAction.search)],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(action, KeyAction.search);
      expect(submittedText, 'query');
      expect(submitted, isTrue);
    });

    testWidgets('custom call action reports the pressed action',
        (tester) async {
      final controller = VirtualKeypadController(text: '5551234');
      KeyAction? action;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: controller,
                    onInputAction: (pressedAction, _) {
                      action = pressedAction;
                    },
                  ),
                  VirtualKeypad(
                    type: KeyboardType.custom,
                    customLayout: [
                      [VirtualKey.action(action: KeyAction.call)],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.call));
      await tester.pumpAndSettle();

      expect(action, KeyAction.call);
    });
  });

  group('VirtualKeypad accessibility', () {
    testWidgets('action keys expose semantic labels and hints', (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      try {
        final firstController = VirtualKeypadController();
        final secondController = VirtualKeypadController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VirtualKeypadScope(
                child: Column(
                  children: [
                    VirtualKeypadTextField(
                      controller: firstController,
                      textInputAction: TextInputAction.next,
                    ),
                    VirtualKeypadTextField(controller: secondController),
                    const VirtualKeypad(),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextField).first);
        await tester.pumpAndSettle();

        expect(
          tester.getSemantics(find.bySemanticsLabel('Backspace')),
          matchesSemantics(
            label: 'Backspace',
            hint: 'Deletes the previous character. Long press to repeat.',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('Next field')),
          matchesSemantics(
            label: 'Next field',
            hint: 'Moves focus to the next field.',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
          ),
        );
      } finally {
        semanticsHandle.dispose();
      }
    });

    testWidgets('shift key announces its current state', (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      try {
        final controller = VirtualKeypadController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VirtualKeypadScope(
                child: Column(
                  children: [
                    VirtualKeypadTextField(controller: controller),
                    const VirtualKeypad(),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextField).first);
        await tester.pumpAndSettle();

        expect(
          tester.getSemantics(find.bySemanticsLabel('Shift')),
          matchesSemantics(
            label: 'Shift',
            value: 'Off',
            hint: 'Turns uppercase on for the next character.',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
          ),
        );

        await tester.tap(find.byIcon(Icons.arrow_upward_outlined));
        await tester.pumpAndSettle();

        expect(
          tester.getSemantics(find.bySemanticsLabel('Shift')),
          matchesSemantics(
            label: 'Shift',
            value: 'On',
            hint: 'Turns caps lock on.',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
          ),
        );
      } finally {
        semanticsHandle.dispose();
      }
    });
  });

  group('VirtualKeypad configuration', () {
    final customLayout = <KeyRow>[
      [VirtualKey.character(text: '1')],
    ];

    test('requires customLayout when type is custom', () {
      expect(
        () => VirtualKeypad(type: KeyboardType.custom),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects customLayout when type is not custom', () {
      expect(
        () => VirtualKeypad(customLayout: customLayout),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () =>
            VirtualKeypad(type: KeyboardType.text, customLayout: customLayout),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('KeyboardLayoutProvider validation', () {
    final provider = KeyboardLayoutProvider.instance;

    setUp(() {
      provider.reset();
    });

    tearDown(() {
      provider.reset();
    });

    test('rejects languages with an empty code', () {
      expect(
        () => provider.registerLanguage(
          KeyboardLanguage(
            code: '',
            name: 'Invalid',
            nativeName: 'Invalid',
            textLayouts: KeyboardLayoutSet.single([
              [VirtualKey.character(text: 'a')],
            ]),
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects languages with empty layout rows', () {
      expect(
        () => provider.registerLanguage(
          KeyboardLanguage(
            code: 'xx',
            name: 'Invalid',
            nativeName: 'Invalid',
            textLayouts: const KeyboardLayoutSet.single([
              [],
            ]),
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects languages with non-positive key flex', () {
      expect(
        () => provider.registerLanguage(
          KeyboardLanguage(
            code: 'yy',
            name: 'Invalid',
            nativeName: 'Invalid',
            textLayouts: KeyboardLayoutSet.single([
              [VirtualKey.character(text: 'a', flex: 0)],
            ]),
          ),
        ),
        throwsArgumentError,
      );
    });
  });

  group('VirtualKeypad language switching', () {
    final provider = KeyboardLayoutProvider.instance;

    setUp(() {
      provider.reset();
      initializeKeyboardLayouts();
    });

    tearDown(() {
      provider.reset();
    });

    testWidgets('initialLanguage seeds the runtime language', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: VirtualKeypadController(),
                  ),
                  const VirtualKeypad(
                    availableLanguages: ['en', 'bn'],
                    initialLanguage: 'bn',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(provider.currentLanguageCode, 'bn');
    });

    testWidgets('long-pressing space opens picker and changes language', (
      tester,
    ) async {
      String? changedLanguage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: VirtualKeypadController(),
                  ),
                  VirtualKeypad(
                    availableLanguages: const ['en', 'bn'],
                    onLanguageChanged: (code) {
                      changedLanguage = code;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      await tester.longPress(find.text('space'));
      await tester.pumpAndSettle();

      expect(find.text('বাংলা'), findsOneWidget);

      await tester.tap(find.text('বাংলা'));
      await tester.pumpAndSettle();

      expect(provider.currentLanguageCode, 'bn');
      expect(changedLanguage, 'bn');
    });

    testWidgets('explicit language selection persists across widget rebuilds', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: VirtualKeypadController(),
                  ),
                  const VirtualKeypad(
                    availableLanguages: ['en', 'bn'],
                    initialLanguage: 'en',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();
      await tester.longPress(find.text('space'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('বাংলা'));
      await tester.pumpAndSettle();

      expect(provider.currentLanguageCode, 'bn');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualKeypadScope(
              child: Column(
                children: [
                  VirtualKeypadTextField(
                    controller: VirtualKeypadController(),
                  ),
                  const VirtualKeypad(
                    availableLanguages: ['en', 'bn'],
                    initialLanguage: 'en',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(provider.currentLanguageCode, 'bn');
    });
  });
}
