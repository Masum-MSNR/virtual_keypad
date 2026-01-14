# Virtual Keypad

A customizable virtual on-screen keyboard for Flutter. Create password entry UIs, custom input interfaces, and applications that need to disable the system keyboard.

## Features

- 🎹 **Multiple keyboard layouts** - QWERTY, numeric, phone pad, or custom
- 📝 **Custom TextField** - Integrates seamlessly with the virtual keyboard
- ⌨️ **Optional physical keyboard support** - Use both virtual and physical keyboards
- 🎨 **Themeable** - Light, dark, or custom themes
- 📱 **Cross-platform** - Works on mobile, web, and desktop
- ⚡ **Selection support** - Full text selection with copy/paste
- 🔒 **Password mode** - Obscure text for secure input

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  virtual_keypad: ^0.1.0
```

## Quick Start

```dart
import 'package:virtual_keypad/virtual_keypad.dart';

class MyApp extends StatelessWidget {
  final controller = VirtualKeypadController();

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Column(
        children: [
          VirtualKeypadTextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          VirtualKeypad(),
        ],
      ),
    );
  }
}
```

## Usage

### Basic Text Input

```dart
VirtualKeypadScope(
  child: Column(
    children: [
      VirtualKeypadTextField(controller: controller),
      VirtualKeypad(type: KeyboardType.text),
    ],
  ),
)
```

### Numeric Keypad

```dart
VirtualKeypad(type: KeyboardType.number)
```

### Phone Pad

```dart
VirtualKeypad(type: KeyboardType.phone)
```

### Custom Theme

```dart
VirtualKeypad(
  theme: VirtualKeypadTheme(
    backgroundColor: Colors.grey[900]!,
    keyColor: Colors.grey[800]!,
    actionKeyColor: Colors.grey[700]!,
    keyTextColor: Colors.white,
    keyTextSize: 20,
    keyBorderRadius: 8,
  ),
)
```

### Allow Physical Keyboard

```dart
VirtualKeypadTextField(
  controller: controller,
  allowPhysicalKeyboard: true, // Both virtual and physical keyboards work
)
```

## Components

### VirtualKeypadScope

Wrap your widget tree with this to enable keyboard-to-textfield connection.

### VirtualKeypadTextField

A TextField that integrates with the virtual keyboard. It maintains focus while interacting with the keyboard and optionally blocks the system keyboard.

### VirtualKeypad

The on-screen keyboard widget with configurable layouts and themes.

### VirtualKeypadController

A TextEditingController with additional methods for text manipulation:

```dart
controller.insertText('Hello');  // Insert at cursor
controller.deleteBackward();     // Backspace
controller.clear();              // Clear all
controller.cursorPosition = 5;   // Move cursor
```

## Keyboard Types

| Type | Description |
|------|-------------|
| `KeyboardType.text` | Full QWERTY with letters, numbers, symbols |
| `KeyboardType.number` | Numeric keypad (0-9, decimal) |
| `KeyboardType.phone` | Phone-style pad with + symbol |
| `KeyboardType.custom` | User-defined layout |

## License

MIT License - see [LICENSE](LICENSE) for details.
