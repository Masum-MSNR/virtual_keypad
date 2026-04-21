# Adding Languages

Add new keyboard languages to Virtual Keypad.

## Overview

Each language provides keyboard layouts for different input types (text, email, URL, etc.). At minimum, you need a text layout.

## Quick Start

### 1. Define Layouts

```dart
import 'package:virtual_keypad/virtual_keypad.dart';

final KeyboardLayout _primaryLayout = [
  [
    VirtualKey.character(text: 'q'),
    VirtualKey.character(text: 'w'),
    VirtualKey.character(text: 'e'),
    // ... more keys
  ],
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 's'),
    // ... more keys
  ],
  [
    VirtualKey.action(action: KeyAction.shift),
    VirtualKey.character(text: 'z'),
    // ... more keys
    VirtualKey.action(action: KeyAction.backSpace),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, label: '123', altLabel: 'ABC', flex: 2),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];
```

### 2. Create Language

```dart
final spanishLanguage = KeyboardLanguage(
  code: 'es',
  name: 'Spanish',
  nativeName: 'Español',
  textLayouts: KeyboardLayoutSet(
    primary: _primaryLayout,
    secondary: _symbolsLayout,
    tertiary: _moreSymbolsLayout,
  ),
  // Optional: emailLayouts, urlLayouts, numberLayouts, phoneLayouts
);
```

### 3. Register & Use

```dart
void main() {
  initializeKeyboardLayouts();
  KeyboardLayoutProvider.instance.registerLanguage(spanishLanguage);
  runApp(MyApp());
}

// Switch to your language
KeyboardLayoutProvider.instance.setLanguage('es');
```

## Layout Sets

Group layouts using `KeyboardLayoutSet`:

```dart
// Multiple layouts (primary + symbols + more symbols)
KeyboardLayoutSet(
  primary: lettersLayout,
  secondary: symbolsLayout,
  tertiary: moreSymbolsLayout,
)

// Single layout (e.g., number pad)
KeyboardLayoutSet.single(numberLayout)
```

## Validation Rules

When you register a language, the provider validates it immediately.

- `code`, `name`, and `nativeName` must be non-empty
- Every layout must contain at least one row
- Layout rows cannot be empty
- Every key must have `flex > 0`
- Character keys must provide non-empty `text`

These checks make broken language definitions fail fast during integration instead of producing a partially rendered keyboard later.

## Built-in Languages

| Code | Language | Layout |
|------|----------|--------|
| `en` | English | QWERTY |
| `bn` | Bengali | বাংলা |
| `fr` | French | AZERTY |

## File Structure

To contribute a language to the package:

```
lib/src/layouts/languages/
├── english.dart
├── bengali.dart
├── french.dart
├── your_language.dart  ← Add here
└── languages.dart      ← Export here
```
