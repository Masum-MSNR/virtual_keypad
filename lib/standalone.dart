/// Standalone-mode APIs for `virtual_keypad`.
///
/// Import this library when you want to attach [VirtualKeypad] to standard
/// Flutter [TextField] or [TextFormField] widgets without using
/// [VirtualKeypadScope] and [VirtualKeypadTextField].
///
/// ## Included Surface
///
/// - [VirtualKeypad] for the keyboard widget itself
/// - [VirtualKeypadStandaloneScope] to limit standalone behavior to a subtree
/// - [StandaloneInputControl] for advanced text-input interception use cases
/// - Layout and theming types needed for custom standalone keyboards

library;

export 'src/enums.dart';
export 'src/models.dart';
export 'src/theme.dart';
export 'src/standalone_input_control.dart';
export 'src/standalone_scope.dart';
export 'src/widgets/keyboard.dart';
export 'src/layouts/layouts.dart' show
    KeyboardLanguage,
    KeyboardLayoutProvider,
    KeyboardLayoutSet,
    initializeKeyboardLayouts;
