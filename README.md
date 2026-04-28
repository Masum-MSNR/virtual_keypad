<p align="center">
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/logo.png" alt="Virtual Keypad" width="120"/>
</p>

<p align="center">
  <a href="https://pub.dev/packages/virtual_keypad"><img src="https://img.shields.io/pub/v/virtual_keypad.svg" alt="pub package"></a>
  <a href="https://pub.dev/packages/virtual_keypad/score"><img src="https://img.shields.io/pub/points/virtual_keypad" alt="pub points"></a>
  <a href="https://pub.dev/packages/virtual_keypad/score"><img src="https://img.shields.io/pub/likes/virtual_keypad" alt="pub likes"></a>
  <a href="https://github.com/Masum-MSNR/virtual_keypad/actions/workflows/ci.yml"><img src="https://github.com/Masum-MSNR/virtual_keypad/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://pub.dev/documentation/virtual_keypad/latest/"><img src="https://img.shields.io/badge/docs-pub.dev-0175C2" alt="Documentation"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter" alt="Platform"></a>
  <a href="https://masum-vk.web.app"><img src="https://img.shields.io/badge/Live_Demo-masum--vk.web.app-FF6F00?logo=firebase" alt="Live Demo"></a>
</p>

<p align="center">
A customizable virtual keyboard, on-screen keyboard, and keypad for Flutter.<br/>
Built for kiosk apps, touchscreen and desktop input, PIN and password entry, numeric keypad and numpad flows, and custom TextField integration.
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/gif1.gif?v=2" width="30%" alt="Demo 1"/>
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/gif2.gif?v=2" width="30%" alt="Demo 2"/>
  <img src="https://raw.githubusercontent.com/Masum-MSNR/virtual_keypad/main/images/gif3.gif?v=2" width="30%" alt="Demo 3"/>
</p>

## Features

- 🎹 **Multiple Layouts** - Text, numeric, phone, email, URL, or fully custom
- 🌍 **Multi-Language** - 12 built-in languages, easily extensible
- 🔌 **Standalone Mode** - Works with any standard Flutter TextField or TextFormField
- 🎯 **Standalone Scope** - Restrict keyboard to a widget subtree
- 🔤 **Smart TextField** - Auto-adapts keyboard layout based on input type
- 😀 **Emoji Support** - Opt-in emoji browser for supported text layouts
- 🎨 **Fully Customizable** - Light, dark, or fully custom themes
- 📱 **Cross-Platform** - Works on iOS, Android, Web, macOS, Windows, Linux
- ✂️ **Full Editing** - Selection, copy/paste, cursor control
- 👆 **Key Preview** - Native-style key press popup feedback
- 🫥 **Auto-Hide** - Animated show/hide on focus change

## Common Use Cases

If you're looking for a Flutter virtual keyboard, on-screen keyboard, keypad, numeric keypad, numpad, PIN pad, custom keyboard, or multilingual keyboard, this package is designed for those flows.

- Use it as a kiosk keyboard, touchscreen keyboard, or desktop keyboard when the system keyboard is unavailable, unwanted, or too limited.
- Build a numeric keypad, numpad, PIN pad, or OTP keypad for authentication, amount entry, checkout, payment, ATM, POS, and self-service input screens.
- Create a custom keyboard for password fields, email and URL forms, search actions, send actions, call actions, and app-specific input flows.
- Add multilingual keyboard behavior with built-in language switching, custom language registration, and direct TextField or TextFormField integration for kiosk, embedded, and enterprise Flutter apps.

## Supported Languages

All 12 languages are registered automatically when you call `initializeKeyboardLayouts()`.

| Code | Language | Native Name | Layout | Script | RTL |
|------|----------|-------------|--------|--------|-----|
| `ar` | Arabic | العربية | Arabic IBM PC | Arabic | ✅ |
| `bn` | Bengali | বাংলা | Bengali | Bengali | |
| `de` | German | Deutsch | QWERTZ | Latin | |
| `en` | English | English | QWERTY | Latin | |
| `es` | Spanish | Español | QWERTY (ES) | Latin | |
| `fr` | French | Français | AZERTY | Latin | |
| `hi` | Hindi | हिन्दी | Devanagari | Devanagari | |
| `ko` | Korean | 한국어 | Dubeolsik (두벌식) | Hangul | |
| `pt` | Portuguese | Português | QWERTY (PT) | Latin | |
| `ru` | Russian | Русский | ЙЦУКЕН (JCUKEN) | Cyrillic | |
| `th` | Thai | ไทย | Kedmanee | Thai | |
| `tr` | Turkish | Türkçe | QWERTY (TR) | Latin | |

> **Note:** If you notice any incorrect characters, missing keys, or layout mismatches for a language you are fluent in, feel free to fix it and [create a pull request](https://github.com/Masum-MSNR/virtual_keypad/pulls). Community contributions are welcome!

## Installation

```yaml
dependencies:
  virtual_keypad: ^latest
```

## Quick Start

### Standalone Mode (works with any TextField or TextFormField)

```dart
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  initializeKeyboardLayouts();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: controller),
        VirtualKeypad(standalone: true),
      ],
    );
  }
}
```

> Just add `standalone: true` — no wrapper widgets needed. The keyboard auto-detects focused fields and adapts layout based on `keyboardType`, making it useful for existing Flutter forms, kiosk screens, login flows, and embedded touchscreen UIs.

For custom submit-style keys in standalone mode, use `onStandaloneInputAction` to distinguish actions like `call`, `search`, or `send` at the keyboard level:

```dart
VirtualKeypad(
  standalone: true,
  type: KeyboardType.custom,
  customLayout: [
    [VirtualKey.action(action: KeyAction.call)],
  ],
  onStandaloneInputAction: (action, text) {
    if (action == KeyAction.call) {
      placeCall(text);
    }
  },
)
```

### Scoped Standalone Mode

Wrap with `VirtualKeypadStandaloneScope` to restrict the keyboard to a specific subtree (useful in Widgetbook or multi-panel UIs):

```dart
VirtualKeypadStandaloneScope(
  child: Column(
    children: [
      TextField(controller: controller),
      VirtualKeypad(standalone: true),
    ],
  ),
)
```

> Fields outside the scope won't trigger this keyboard.

### Floating Mode (draggable and additive)

Use `VirtualKeypadFloating` when you want the same keyboard behavior in a movable floating panel instead of an inline widget:

```dart
VirtualKeypadFloating(
  standalone: true,
  enableEmojiKey: true,
  width: 360,
  height: 280,
  borderRadius: 20,
  theme: VirtualKeypadTheme.dark,
  child: Column(
    children: [
      TextField(controller: controller),
    ],
  ),
)
```

`VirtualKeypadFloating` supports the same keyboard theming as `VirtualKeypad`, plus floating-specific panel configuration such as `width`, `height`, `borderRadius`, and draggable toolbar controls.

For manual visibility, docking, or always-on kiosk-style flows, pair it with a controller:

```dart
final floatingController = VirtualKeypadFloatingController();

VirtualKeypadFloating(
  controller: floatingController,
  visibilityMode: VirtualKeypadFloatingVisibilityMode.persistent,
  width: 420,
  borderRadius: 20,
  child: Column(
    children: [
      TextField(controller: controller),
    ],
  ),
)
```

In persistent mode, you can keep the keyboard visible until you explicitly call `floatingController.hide()` or the user closes it from the toolbar.

For scoped usage, keep `VirtualKeypadScope` exactly as-is and place `VirtualKeypadFloating` inside the scope:

```dart
VirtualKeypadScope(
  child: VirtualKeypadFloating(
    width: 360,
    child: Column(
      children: [
        VirtualKeypadTextField(controller: controller),
      ],
    ),
  ),
)
```

> Floating mode is additive. Existing `VirtualKeypad()` and `VirtualKeypad(standalone: true)` usage stays unchanged.

### Emoji Support

Enable emoji on supported text layouts by passing `enableEmojiKey: true`:

```dart
VirtualKeypad(
  standalone: true,
  enableEmojiKey: true,
)
```

That adds an emoji toggle on built-in text, multiline, email, URL, password, name, and street-address layouts.

If you want an emoji-first surface, such as a preview card or always-visible dock, start directly on the emoji page:

```dart
VirtualKeypad(
  hideWhenUnfocused: false,
  enableEmojiKey: true,
  showEmojiKeyboardInitially: true,
)
```

`VirtualKeypadFloating` also supports emoji by passing `enableEmojiKey: true`.

### Which Mode Should You Use?

| Mode | Best For | Use These Widgets |
|------|----------|-------------------|
| Standalone | Fast integration with existing `TextField` / `TextFormField` UIs | `TextField` + `VirtualKeypad(standalone: true)` |
| Floating | Draggable overlay-style keyboards that should stay above the UI | `VirtualKeypadFloating(...)` |
| Scoped | Full control over submit handling, focus-driven layout changes, and system keyboard blocking | `VirtualKeypadScope` + `VirtualKeypadTextField` + `VirtualKeypad()` |

Choose standalone mode when you want a Flutter virtual keyboard or keypad to drop into an existing form with minimal refactoring.
Choose floating mode when you need that same keyboard behavior in a draggable panel for kiosk, desktop, POS, or multitasking layouts.
Choose scoped mode when you need predictable focus routing, custom submit handling, secure input behavior, or tighter control for complex form, kiosk, or authentication flows.

### Scope Mode (full control)

```dart
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  initializeKeyboardLayouts();
  runApp(MyApp());
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

> Three components work together: `VirtualKeypadScope` → `VirtualKeypadTextField` → `VirtualKeypad`. Use this mode for selection callbacks, submit handling, and physical keyboard blocking.

## Keyboard Types

Use these keyboard types to switch between general text input, email keyboard layouts, URL keyboard layouts, numeric keypad input, phone dialer input, and custom keypad flows.

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

Custom layouts are useful for building a PIN pad, OTP keypad, numeric keypad, checkout keypad, ATM keypad, POS keypad, or any branded on-screen keyboard flow.

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

> `customLayout` must be used together with `type: KeyboardType.custom`. Invalid combinations assert immediately in debug mode so setup mistakes fail fast for custom keyboard, custom keypad, PIN pad, and numpad setups.

## Theming

The theming API helps you match the keyboard to kiosk apps, enterprise dashboards, POS interfaces, embedded displays, and branded login or checkout screens.

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

Use multi-language support when you need a multilingual keyboard for international forms, regional kiosk deployments, localized checkout flows, or RTL input experiences.

```dart
initializeKeyboardLayouts(); // Registers all 12 languages

// Switch language
KeyboardLayoutProvider.instance.setLanguage('ar'); // Arabic
KeyboardLayoutProvider.instance.setLanguage('ko'); // Korean
KeyboardLayoutProvider.instance.setLanguage('en'); // English

VirtualKeypad(
  availableLanguages: ['en', 'bn', 'ar'],
  initialLanguage: 'en',
  onLanguageChanged: (code) {
    // Save the selected language if you want to restore it next launch.
  },
)
```

When `availableLanguages` contains more than one language, users can long-press
the space bar to open the language picker. The first language in the list is the
fallback language for that keyboard.

The selected language is remembered for the current app session through the
shared keyboard layout provider. If you want to restore the same language after
an app restart, save the code from `onLanguageChanged` and pass it back through
`initialLanguage`.

### Adding a Custom Language

```dart
final myLanguage = KeyboardLanguage(
  code: 'xx',
  name: 'MyLanguage',
  nativeName: 'MyLanguage',
  textLayouts: KeyboardLayoutSet(
    primary: textPrimaryLayout,
    secondary: symbolsLayout,
    tertiary: moreSymbolsLayout,
  ),
);

KeyboardLayoutProvider.instance.registerLanguage(myLanguage);
KeyboardLayoutProvider.instance.setLanguage('xx');
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
  standalone: false,                 // true = works with any TextField
  type: null,                        // Override layout (auto if null)
  height: 280,                       // Keyboard height
  theme: VirtualKeypadTheme.light,   // Visual theme
  availableLanguages: ['en', 'bn'],  // Optional in-keyboard language picker
  initialLanguage: 'en',             // Startup language for this session
  hideWhenUnfocused: false,          // Auto-hide animation
  customLayout: null,                // Custom key arrangement
  onKeyPressed: (key) {},            // Key press callback
  onStandaloneInputAction: (action, text) {}, // Standalone submit-style action callback
  onLanguageChanged: (code) {},      // Language switch callback
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

Check out the [example](example/) directory for a complete demo app with 9 screens showcasing virtual keyboard, keypad, PIN pad, password, numeric input, and multilingual keyboard flows.

## Common Setup Mistakes

- Forgetting `initializeKeyboardLayouts()` before `runApp()`. Built-in layouts are registered there.
- Mixing standalone mode and scoped mode in the same form without a clear reason. Pick one architecture per flow.
- Providing `customLayout` without `type: KeyboardType.custom`, or setting `type: KeyboardType.custom` without a layout.
- Expecting `VirtualKeypadTextField` to allow the system keyboard by default. It blocks physical/system keyboard input unless `allowPhysicalKeyboard: true`.

## Documentation

These guides cover virtual keyboard integration, keypad customization, multilingual layout setup, and Flutter TextField or TextFormField onboarding.

| Guide | Description |
|-------|-------------|
| [API Reference](doc/api-reference.md) | Complete API documentation |
| [Custom Layouts](doc/custom-layouts.md) | Build custom keyboard layouts |
| [Adding Languages](doc/adding-languages.md) | Add new language support |
| [Theming](doc/theming.md) | Customize keyboard appearance |

### Focused Imports

| Import | Best For |
|--------|----------|
| `package:virtual_keypad/virtual_keypad.dart` | Full package surface with widgets, layouts, themes, and helpers |
| `package:virtual_keypad/widgets.dart` | Scoped widget workflows with `VirtualKeypadScope` and `VirtualKeypadTextField` |
| `package:virtual_keypad/standalone.dart` | Standard `TextField` integration with `VirtualKeypad(standalone: true)` |
| `package:virtual_keypad/layouts.dart` | Language registration, layout access, and custom language setup |

## Contributing

Contributions welcome! See the [Contributing Guide](CONTRIBUTING.md).

## License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/Masum-MSNR">Masum</a>
</p>
