/// A customizable virtual on-screen keyboard for Flutter.
///
/// This package provides a virtual keyboard that works with custom text fields,
/// allowing you to create password entry UIs, custom input interfaces, and
/// applications that need to disable the system keyboard.
///
/// ## Features
/// - Custom on-screen keyboard with multiple layouts (QWERTY, numbers, symbols)
/// - TextField that integrates seamlessly with the virtual keyboard
/// - Optional physical keyboard support
/// - Customizable themes and colors
/// - Works on all platforms (mobile, web, desktop)
///
/// ## Basic Usage
/// ```dart
/// import 'package:virtual_keypad/virtual_keypad.dart';
///
/// VirtualKeypadScope(
///   child: Column(
///     children: [
///       VirtualKeypadTextField(controller: controller),
///       VirtualKeypad(),
///     ],
///   ),
/// )
/// ```
library;

export 'src/controller.dart';
export 'src/scope.dart';
export 'src/text_field.dart';
export 'src/keyboard.dart';
export 'src/theme.dart';
export 'src/enums.dart';
export 'src/models.dart';
