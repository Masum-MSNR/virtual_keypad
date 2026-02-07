<p align="center">
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/logo.png" alt="Virtual Keypad" width="120"/>
</p>

<h1 align="center">Virtual Keypad</h1>

<p align="center">
  <a href="https://pub.dev/packages/virtual_keypad"><img src="https://img.shields.io/pub/v/virtual_keypad.svg" alt="pub package"></a>
  <a href="https://github.com/Masum-MSNR/virtual_keypad/actions"><img src="https://img.shields.io/github/actions/workflow/status/Masum-MSNR/virtual_keypad/dart.yml?branch=main" alt="build status"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter" alt="Platform"></a>
</p>

<p align="center">
A fully customizable virtual on-screen keyboard for Flutter.<br/>
Perfect for kiosk apps, password UIs, and custom input interfaces.
</p>

---

- **Multiple Layouts** — Text, numeric, phone, email, URL, or fully custom
- **Multi-Language** — Built-in English & Bengali, easily extensible
- **Smart TextField** — Auto-adapts keyboard layout based on input type
- **Themeable** — Light, dark, or fully custom themes
- **Cross-Platform** — Mobile, web, and desktop
- **Full Editing** — Selection, copy/paste, cursor control
- **Auto-Hide** — Animated show/hide on focus change

## Preview

<p align="center">
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/gif1.gif" width="270" alt="Demo 1"/>
  &nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/gif2.gif" width="270" alt="Demo 2"/>
  &nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/gif3.gif" width="270" alt="Demo 3"/>
</p>

## Installation

```yaml
dependencies:
  virtual_keypad: ^latest
```

## Quick Start

```dart
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  initializeKeyboardLayouts(); // Required: registers built-in languages
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = VirtualKeypadController();

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

> Three components work together: `VirtualKeypadScope` → `VirtualKeypadTextField` → `VirtualKeypad`

## Keyboard Types

```dart
VirtualKeypadTextField(
  controller: controller,
  keyboardType: KeyboardType.emailAddress, // Auto-shows @ and .
)
```

| Type | Use Case |
|------|----------|
| `text` | General text input (QWERTY) |
| `emailAddress` | Email fields (QWERTY + `@` `.`) |
| `url` | URL fields (QWERTY + `/` `:` `.`) |
| `number` | Numeric input (0-9) |
| `phone` | Phone dialer |
| `multiline` | Text areas with newline |
| `custom` | User-defined layouts |

## Custom Layout

```dart
final pinLayout = [
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
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
  ],
  [
    VirtualKey.action(action: KeyAction.backSpace),
    VirtualKey.character(text: '0'),
    VirtualKey.action(action: KeyAction.done, label: '✓'),
  ],
];

VirtualKeypad(
  type: KeyboardType.custom,
  customLayout: pinLayout,
)
```

## Theming

```dart
// Built-in themes
VirtualKeypad(theme: VirtualKeypadTheme.light)
VirtualKeypad(theme: VirtualKeypadTheme.dark)

// Custom theme
VirtualKeypad(
  theme: VirtualKeypadTheme(
    backgroundColor: Colors.grey[900]!,
    keyColor: Colors.grey[800]!,
    actionKeyColor: Colors.grey[700]!,
    keyTextColor: Colors.white,
    keyBorderRadius: 12,
  ),
)

// Modify existing theme
VirtualKeypad(
  theme: VirtualKeypadTheme.dark.copyWith(
    keyBorderRadius: 12,
    keyTextSize: 24,
  ),
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backgroundColor` | `Color` | `#D1D3D9` | Keyboard background |
| `keyColor` | `Color` | `#FFFFFF` | Character key background |
| `actionKeyColor` | `Color` | `#ADB3BC` | Action key background |
| `keyTextColor` | `Color` | `#1C1C1E` | Text/icon color |
| `keyTextSize` | `double` | `22.0` | Font size |
| `keyBorderRadius` | `double` | `6.0` | Corner radius |
| `keyShadow` | `bool` | `true` | Show key shadows |
| `splashColor` | `Color?` | `null` | Tap ripple color |

## Multi-Language

```dart
initializeKeyboardLayouts(); // Registers English & Bengali

// Switch language
KeyboardLayoutProvider.instance.setLanguage('bn'); // Bengali
KeyboardLayoutProvider.instance.setLanguage('en'); // English
```

| Code | Language | Layout |
|------|----------|--------|
| `en` | English | QWERTY |
| `bn` | Bengali | বাংলা |

### Adding a Custom Language

```dart
final spanishLanguage = KeyboardLanguage(
  code: 'es',
  name: 'Spanish',
  nativeName: 'Español',
  textLayouts: KeyboardLayoutSet(
    primary: textPrimaryLayout,
    secondary: symbolsLayout,
    tertiary: moreSymbolsLayout,
  ),
);

KeyboardLayoutProvider.instance.registerLanguage(spanishLanguage);
KeyboardLayoutProvider.instance.setLanguage('es');
```

## API Reference

### VirtualKeypadTextField

```dart
VirtualKeypadTextField(
  controller: controller,           // Required
  keyboardType: KeyboardType.text,   // Layout type
  obscureText: false,                // Password mode
  allowPhysicalKeyboard: false,      // Block system keyboard
  maxLength: null,                   // Character limit
  maxLines: 1,                       // Line count (null = unlimited)
  onChanged: (value) {},             // Text change callback
  onSubmitted: (value) {},           // Submit callback
)
```

### VirtualKeypad

```dart
VirtualKeypad(
  type: null,                        // Override layout (auto if null)
  height: 280,                       // Keyboard height
  theme: VirtualKeypadTheme.light,   // Visual theme
  hideWhenUnfocused: false,          // Auto-hide animation
  customLayout: null,                // Custom key arrangement
  onKeyPressed: (key) {},            // Key press callback
)
```

### VirtualKeypadController

```dart
final controller = VirtualKeypadController();

controller.insertText('Hello');    // Insert at cursor
controller.deleteBackward();       // Delete before cursor
controller.selectAll();            // Select all text
controller.clear();                // Clear all
controller.cursorPosition = 5;     // Set cursor position
controller.moveCursorLeft();       // Move cursor
controller.moveCursorRight();
```

## Examples

Check out the [example](example/) directory for a complete demo app with 9 screens showcasing all features.

## Documentation

| Guide | Description |
|-------|-------------|
| [API Reference](doc/api-reference.md) | Complete API documentation |
| [Custom Layouts](doc/custom-layouts.md) | Build custom keyboard layouts |
| [Adding Languages](doc/adding-languages.md) | Add new language support |
| [Theming](doc/theming.md) | Customize keyboard appearance |

## Contributing

Contributions welcome! See the [Contributing Guide](CONTRIBUTING.md).

## License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/Masum-MSNR">Masum</a>
</p>
