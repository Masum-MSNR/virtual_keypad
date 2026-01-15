# Virtual Keypad

A fully customizable virtual on-screen keyboard for Flutter with multi-language support. Perfect for kiosk applications, password entry UIs, custom input interfaces, and any application that needs to disable the system keyboard.

[![pub package](https://img.shields.io/pub/v/virtual_keypad.svg)](https://pub.dev/packages/virtual_keypad)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Features

- 🎹 **Multiple keyboard layouts** - Text, numeric, phone, email, URL, or custom layouts
- 🌍 **Multi-language support** - Built-in English and Bengali, easily extensible
- 📝 **Smart TextField** - Auto-adapts keyboard based on input type
- ⌨️ **Physical keyboard support** - Optional dual input (virtual + physical)
- 🎨 **Fully themeable** - Light, dark, or custom themes
- 📱 **Cross-platform** - Works on mobile, web, and desktop
- ⚡ **Full text editing** - Selection, copy/paste, cursor positioning
- 🔒 **Password mode** - Secure text obscuring
- 🔄 **Auto-hide** - Animated show/hide when focus changes
- ✨ **Input-aware layouts** - Email shows @, URL shows /, etc.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  virtual_keypad: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:virtual_keypad/virtual_keypad.dart';

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final controller = VirtualKeypadController();

  @override
  void initState() {
    super.initState();
    initializeKeyboardLayouts(); // Initialize language layouts
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Column(
        children: [
          VirtualKeypadTextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Enter text'),
          ),
          VirtualKeypad(),
        ],
      ),
    );
  }
}
```

## Components

### VirtualKeypadScope

**Required wrapper** that connects text fields to the keyboard. Place it above all `VirtualKeypadTextField` and `VirtualKeypad` widgets.

```dart
VirtualKeypadScope(
  child: Column(
    children: [
      VirtualKeypadTextField(controller: controller1),
      VirtualKeypadTextField(controller: controller2),
      VirtualKeypad(), // Automatically connects to focused field
    ],
  ),
)
```

### VirtualKeypadTextField

A TextField replacement that integrates with the virtual keyboard.

```dart
VirtualKeypadTextField(
  controller: controller,
  decoration: InputDecoration(labelText: 'Email'),
  keyboardType: KeyboardType.emailAddress, // Shows @ on keyboard
  textInputAction: TextInputAction.next,
  obscureText: false,
  maxLength: 50,
  maxLines: 1,
  allowPhysicalKeyboard: false, // Block system keyboard
  onSubmitted: (value) => print('Submitted: $value'),
)
```

**Key Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `VirtualKeypadController` | Required text controller |
| `keyboardType` | `KeyboardType` | Determines keyboard layout |
| `textInputAction` | `TextInputAction` | Action button behavior |
| `obscureText` | `bool` | Password mode |
| `allowPhysicalKeyboard` | `bool` | Allow system keyboard |
| `maxLength` | `int?` | Character limit |
| `maxLines` | `int` | Single or multi-line |

### VirtualKeypad

The on-screen keyboard widget.

```dart
VirtualKeypad(
  type: KeyboardType.text,        // Override keyboard type
  height: 280,                     // Keyboard height
  theme: VirtualKeypadTheme.dark,  // Visual theme
  hideWhenUnfocused: true,         // Auto-hide animation
  animationDuration: Duration(milliseconds: 200),
  onKeyPressed: (key) => print('Key: $key'),
)
```

**Key Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `type` | `KeyboardType?` | Override layout (null = auto from text field) |
| `height` | `double` | Keyboard height (default: 280) |
| `theme` | `VirtualKeypadTheme` | Visual styling |
| `hideWhenUnfocused` | `bool` | Animate hide when no focus |
| `customLayout` | `KeyboardLayout?` | Custom key arrangement |

### VirtualKeypadController

Extended `TextEditingController` with additional methods:

```dart
final controller = VirtualKeypadController();

// Text manipulation
controller.insertText('Hello');
controller.deleteBackward();
controller.clear();

// Cursor control
controller.cursorPosition = 5;
int pos = controller.cursorPosition;

// Selection
controller.selectAll();
TextSelection sel = controller.selection;
```

## Keyboard Types

The keyboard automatically adapts based on `keyboardType`:

| KeyboardType | Layout | Special Keys |
|--------------|--------|--------------|
| `text` | Full QWERTY | Letters, numbers, symbols |
| `emailAddress` | QWERTY + email | @ . _ - on primary row |
| `url` | QWERTY + URL | / : . on primary row |
| `number` | Number pad | 0-9, decimal |
| `numberSigned` | Signed number pad | 0-9, decimal, minus |
| `phone` | Phone dialer | 0-9, *, #, + |
| `multiline` | Full QWERTY | Enter inserts newline |
| `custom` | User-defined | Via `customLayout` |

## Theming

### Built-in Themes

```dart
VirtualKeypad(theme: VirtualKeypadTheme.light) // Light theme
VirtualKeypad(theme: VirtualKeypadTheme.dark)  // Dark theme
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
    horizontalGap: 6,
    verticalGap: 8,
    keyDecoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(blurRadius: 2, offset: Offset(0, 1))],
    ),
  ),
)
```

## Multi-Language Support

### Built-in Languages

- **English** (`en`) - QWERTY layout
- **Bengali** (`bn`) - বাংলা layout with Bengali numerals

### Switching Languages

```dart
// Initialize at app startup
initializeKeyboardLayouts();

// Switch to Bengali
KeyboardLayoutProvider.instance.setLanguage('bn');

// Switch to English
KeyboardLayoutProvider.instance.setLanguage('en');

// Get current language
String code = KeyboardLayoutProvider.instance.currentLanguageCode;
KeyboardLanguage lang = KeyboardLayoutProvider.instance.currentLanguage;
```

### Adding a New Language

1. Create a language file in `lib/src/layouts/languages/`:

```dart
// my_language.dart
import '../../enums.dart';
import '../../models.dart';
import '../keyboard_language.dart';

final KeyboardLayout _textLayoutPrimary = [
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 'b'),
    // ... more keys
  ],
  // ... more rows
];

final KeyboardLanguage myLanguage = KeyboardLanguage(
  code: 'xx',
  name: 'My Language',
  nativeName: 'Native Name',
  textLayouts: KeyboardLayoutSet(
    primary: _textLayoutPrimary,
    secondary: _textLayoutSecondary,
    tertiary: _textLayoutTertiary,
  ),
  emailLayouts: KeyboardLayoutSet(...),
  numberLayouts: KeyboardLayoutSet.single(_numberLayout),
  phoneLayouts: KeyboardLayoutSet.single(_phoneLayout),
);
```

2. Register the language:

```dart
KeyboardLayoutProvider.instance.registerLanguage(myLanguage);
KeyboardLayoutProvider.instance.setLanguage('xx');
```

## Custom Layouts

Create completely custom keyboard layouts:

```dart
final myLayout = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
  ],
  [
    VirtualKey.action(action: KeyAction.backSpace, flex: 2),
    VirtualKey.action(action: KeyAction.done, label: 'OK'),
  ],
];

VirtualKeypad(
  type: KeyboardType.custom,
  customLayout: myLayout,
)
```

### VirtualKey Options

```dart
// Character key
VirtualKey.character(
  text: 'a',           // Lowercase character
  capsText: 'A',       // Uppercase (optional, auto-generated)
  flex: 1,             // Relative width
)

// Action key
VirtualKey.action(
  action: KeyAction.shift,
  label: '⇧',          // Primary state label
  altLabel: '⇪',       // Secondary state label
  flex: 2,             // Relative width
)
```

### Available Actions

| KeyAction | Description |
|-----------|-------------|
| `backSpace` | Delete character before cursor |
| `enter` | Newline or submit |
| `shift` | Toggle uppercase |
| `space` | Insert space |
| `symbols` | Switch to symbols layout |
| `symbolsAlt` | Switch to alternate symbols |
| `done` | Submit and close |
| `go` | Navigate (for URLs) |
| `search` | Search action |
| `send` | Send action |

## Examples

### Password Entry

```dart
VirtualKeypadScope(
  child: Column(
    children: [
      VirtualKeypadTextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
        ),
      ),
      VirtualKeypad(hideWhenUnfocused: true),
    ],
  ),
)
```

### Multi-Field Form

```dart
VirtualKeypadScope(
  child: Column(
    children: [
      VirtualKeypadTextField(
        controller: emailController,
        keyboardType: KeyboardType.emailAddress,
        decoration: InputDecoration(labelText: 'Email'),
      ),
      VirtualKeypadTextField(
        controller: phoneController,
        keyboardType: KeyboardType.phone,
        decoration: InputDecoration(labelText: 'Phone'),
      ),
      VirtualKeypad(), // Auto-switches layout based on focus
    ],
  ),
)
```

### Kiosk Mode (No System Keyboard)

```dart
VirtualKeypadTextField(
  controller: controller,
  allowPhysicalKeyboard: false, // Blocks system keyboard
)
```

### Dual Input (Virtual + Physical)

```dart
VirtualKeypadTextField(
  controller: controller,
  allowPhysicalKeyboard: true, // Both keyboards work
)
```

## API Reference

### VirtualKeypadScope

| Method | Description |
|--------|-------------|
| `VirtualKeypadScope.of(context)` | Get scope state from context |

### VirtualKeypadController

| Property/Method | Description |
|----------------|-------------|
| `text` | Current text value |
| `selection` | Current selection |
| `cursorPosition` | Cursor position (get/set) |
| `insertText(String)` | Insert at cursor |
| `deleteBackward()` | Delete before cursor |
| `selectAll()` | Select all text |
| `clear()` | Clear all text |

### KeyboardLayoutProvider

| Property/Method | Description |
|----------------|-------------|
| `instance` | Singleton instance |
| `currentLanguage` | Current KeyboardLanguage |
| `currentLanguageCode` | Current language code |
| `languages` | All registered languages |
| `registerLanguage(lang)` | Add a language |
| `setLanguage(code)` | Switch language |
| `getLayouts(inputType)` | Get layouts for input type |

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please submit pull requests to the [repository](https://github.com/Masum-MSNR/virtual_keypad).

## Support

- 📖 [Documentation](https://pub.dev/packages/virtual_keypad)
- 🐛 [Issue Tracker](https://github.com/Masum-MSNR/virtual_keypad/issues)
- 💬 [Discussions](https://github.com/Masum-MSNR/virtual_keypad/discussions)
