<p align="center">
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/doc/assets/logo.png" alt="Virtual Keypad" width="120"/>
</p>

<h1 align="center">Virtual Keypad</h1>

<p align="center">
  <strong>A fully customizable virtual on-screen keyboard for Flutter</strong>
</p>

<p align="center">
  <a href="https://pub.dev/packages/virtual_keypad"><img src="https://img.shields.io/pub/v/virtual_keypad.svg" alt="pub package"></a>
  <a href="https://github.com/Masum-MSNR/virtual_keypad/actions"><img src="https://img.shields.io/github/actions/workflow/status/Masum-MSNR/virtual_keypad/dart.yml?branch=main" alt="build status"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter" alt="Platform"></a>
</p>

<p align="center">
  Perfect for kiosk applications, password entry UIs, custom input interfaces, and any application requiring system keyboard suppression.
</p>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎹 **Multiple Layouts** | Text, numeric, phone, email, URL, or fully custom layouts |
| 🌍 **Multi-Language** | Built-in English & Bengali, easily extensible |
| 📝 **Smart TextField** | Auto-adapts keyboard based on input type |
| ⌨️ **Physical Keyboard** | Optional dual input mode (virtual + physical) |
| 🎨 **Themeable** | Light, dark, or custom themes |
| 📱 **Cross-Platform** | Mobile, web, and desktop support |
| ⚡ **Full Editing** | Selection, copy/paste, cursor control |
| 🔒 **Password Mode** | Secure text obscuring |
| 🔄 **Auto-Hide** | Animated show/hide on focus change |

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  virtual_keypad: ^0.1.0
```

```bash
flutter pub get
```

---

## 🚀 Quick Start

```dart
import 'package:virtual_keypad/virtual_keypad.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = VirtualKeypadController();

  @override
  void initState() {
    super.initState();
    initializeKeyboardLayouts();
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

> 💡 **Three components work together:** `VirtualKeypadScope` → `VirtualKeypadTextField` → `VirtualKeypad`

---

## 📖 Core Components

### VirtualKeypadScope

**Required wrapper** connecting text fields to the keyboard.

```dart
VirtualKeypadScope(
  child: Column(
    children: [
      VirtualKeypadTextField(controller: controller1),
      VirtualKeypadTextField(controller: controller2),
      VirtualKeypad(), // Auto-connects to focused field
    ],
  ),
)
```

### VirtualKeypadTextField

Drop-in `TextField` replacement with virtual keyboard integration.

```dart
VirtualKeypadTextField(
  controller: controller,
  keyboardType: KeyboardType.emailAddress,
  obscureText: false,
  allowPhysicalKeyboard: false,  // Block system keyboard
  onSubmitted: (value) => print(value),
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `controller` | `VirtualKeypadController` | *required* | Text controller |
| `keyboardType` | `KeyboardType` | `text` | Keyboard layout type |
| `obscureText` | `bool` | `false` | Password mode |
| `allowPhysicalKeyboard` | `bool` | `false` | Enable system keyboard |
| `maxLength` | `int?` | `null` | Character limit |
| `maxLines` | `int` | `1` | Line count |

### VirtualKeypad

The on-screen keyboard widget.

```dart
VirtualKeypad(
  height: 280,
  theme: VirtualKeypadTheme.dark,
  hideWhenUnfocused: true,
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `type` | `KeyboardType?` | `null` | Override layout (auto if null) |
| `height` | `double` | `280` | Keyboard height |
| `theme` | `VirtualKeypadTheme` | `light` | Visual theme |
| `hideWhenUnfocused` | `bool` | `false` | Auto-hide animation |
| `customLayout` | `KeyboardLayout?` | `null` | Custom key arrangement |

### VirtualKeypadController

Extended `TextEditingController` with additional methods.

```dart
final controller = VirtualKeypadController();

controller.insertText('Hello');
controller.deleteBackward();
controller.selectAll();
controller.clear();
controller.cursorPosition = 5;
```

---

## ⌨️ Keyboard Types

| Type | Layout | Use Case |
|------|--------|----------|
| `text` | Full QWERTY | General text input |
| `emailAddress` | QWERTY + `@` `.` | Email fields |
| `url` | QWERTY + `/` `:` `.` | URL fields |
| `number` | 0-9, decimal | Numeric input |
| `numberSigned` | 0-9, `-`, decimal | Signed numbers |
| `phone` | Phone dialer | Phone numbers |
| `multiline` | QWERTY + newline | Text areas |
| `custom` | User-defined | Custom layouts |

---

## 🎨 Theming

### Built-in Themes

```dart
VirtualKeypad(theme: VirtualKeypadTheme.light)
VirtualKeypad(theme: VirtualKeypadTheme.dark)
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

---

## 🌍 Multi-Language Support

### Built-in Languages

| Code | Language | Layout |
|------|----------|--------|
| `en` | English | QWERTY |
| `bn` | Bengali | বাংলা |

### Switch Language

```dart
initializeKeyboardLayouts();

KeyboardLayoutProvider.instance.setLanguage('bn');  // Bengali
KeyboardLayoutProvider.instance.setLanguage('en');  // English
```

### Add Custom Language

See [Adding Languages Guide](doc/adding-languages.md) for detailed instructions.

---

## 🔧 Common Use Cases

<details>
<summary><b>Password Entry</b></summary>

```dart
VirtualKeypadTextField(
  controller: passwordController,
  obscureText: true,
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
  ),
)
```
</details>

<details>
<summary><b>Kiosk Mode (No System Keyboard)</b></summary>

```dart
VirtualKeypadTextField(
  controller: controller,
  allowPhysicalKeyboard: false,
)
```
</details>

<details>
<summary><b>Multi-Field Form</b></summary>

```dart
VirtualKeypadScope(
  child: Column(
    children: [
      VirtualKeypadTextField(
        controller: emailController,
        keyboardType: KeyboardType.emailAddress,
      ),
      VirtualKeypadTextField(
        controller: phoneController,
        keyboardType: KeyboardType.phone,
      ),
      VirtualKeypad(), // Auto-switches layout
    ],
  ),
)
```
</details>

<details>
<summary><b>Custom Layout</b></summary>

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
</details>

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [API Reference](doc/api-reference.md) | Complete API documentation |
| [Custom Layouts](doc/custom-layouts.md) | Creating custom keyboard layouts |
| [Adding Languages](doc/adding-languages.md) | Multi-language implementation guide |
| [Theming Guide](doc/theming.md) | Customizing keyboard appearance |
| [Examples](example/) | Full example applications |

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

Contributions welcome! Please read our [Contributing Guide](CONTRIBUTING.md) and submit PRs to the [repository](https://github.com/Masum-MSNR/virtual_keypad).

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/Masum-MSNR">Masum</a>
</p>
