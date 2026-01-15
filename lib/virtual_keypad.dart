/// A Flutter package for creating customizable virtual on-screen keyboards.
///
/// This package provides a complete solution for custom keyboard input,
/// including text fields that integrate seamlessly with virtual keyboards,
/// theming support, and multiple keyboard layouts that adapt to input type.
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
/// ## Input-Aware Layouts
///
/// The keyboard automatically adapts based on the text field's [KeyboardType]:
///
/// ```dart
/// VirtualKeypadTextField(
///   controller: emailController,
///   keyboardType: KeyboardType.emailAddress, // Shows @ on primary layout
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
/// - [KeyboardType] - Input types that determine keyboard layout
library;

export 'src/controller.dart';
export 'src/enums.dart';
export 'src/models.dart';
export 'src/scope.dart';
export 'src/theme.dart';
export 'src/widgets/keyboard.dart';
export 'src/widgets/text_field.dart';
export 'src/layouts/layouts.dart';
