/// A Flutter package for creating customizable virtual on-screen keyboards.
///
/// This package provides a complete solution for custom keyboard input,
/// including text fields that integrate seamlessly with virtual keyboards,
/// theming support, and multiple keyboard layouts.
///
/// ## Getting Started
///
/// Wrap your widget tree with [VirtualKeypadScope], then use
/// [VirtualKeypadTextField] and [VirtualKeypad] together:
///
/// ```dart
/// VirtualKeypadScope(
///   child: Column(
///     children: [
///       VirtualKeypadTextField(controller: controller),
///       VirtualKeypad(),
///     ],
///   ),
/// )
/// ```
///
/// ## Key Components
///
/// - [VirtualKeypadScope] - Manages keyboard-to-textfield connections
/// - [VirtualKeypadTextField] - Text field optimized for virtual keyboard input
/// - [VirtualKeypad] - Customizable on-screen keyboard widget
/// - [VirtualKeypadController] - Controller with text manipulation methods
/// - [VirtualKeypadTheme] - Theming for keyboard appearance
library;

export 'src/controller.dart';
export 'src/enums.dart';
export 'src/keyboard.dart';
export 'src/models.dart';
export 'src/scope.dart';
export 'src/text_field.dart';
export 'src/theme.dart';
