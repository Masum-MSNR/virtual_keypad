# Adding Languages Guide

Learn how to add new languages to the Virtual Keypad package.

## Table of Contents

- [Overview](#overview)
- [File Structure](#file-structure)
- [Creating a Language](#creating-a-language)
- [Layout Sets](#layout-sets)
- [Registration](#registration)
- [Complete Example](#complete-example)

---

## Overview

Each language in Virtual Keypad provides:

- **Text layouts** - Primary letters, numbers, and symbols
- **Email layouts** (optional) - With `@` easily accessible
- **URL layouts** (optional) - With `/` `:` `.` accessible
- **Number layouts** (optional) - Numeric keypad
- **Phone layouts** (optional) - Phone dialer

---

## File Structure

Create a new file in `lib/src/layouts/languages/`:

```
lib/src/layouts/languages/
├── english.dart
├── bengali.dart
├── your_language.dart  ← New file
└── languages.dart      ← Export file
```

---

## Creating a Language

### Step 1: Define Primary Layout

```dart
// lib/src/layouts/languages/spanish.dart

import '../../enums.dart';
import '../../models.dart';
import '../keyboard_language.dart';

final KeyboardLayout _textLayoutPrimary = [
  // Row 1
  [
    VirtualKey.character(text: 'q'),
    VirtualKey.character(text: 'w'),
    VirtualKey.character(text: 'e'),
    VirtualKey.character(text: 'r'),
    VirtualKey.character(text: 't'),
    VirtualKey.character(text: 'y'),
    VirtualKey.character(text: 'u'),
    VirtualKey.character(text: 'i'),
    VirtualKey.character(text: 'o'),
    VirtualKey.character(text: 'p'),
  ],
  // Row 2
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 's'),
    VirtualKey.character(text: 'd'),
    VirtualKey.character(text: 'f'),
    VirtualKey.character(text: 'g'),
    VirtualKey.character(text: 'h'),
    VirtualKey.character(text: 'j'),
    VirtualKey.character(text: 'k'),
    VirtualKey.character(text: 'l'),
    VirtualKey.character(text: 'ñ'),  // Spanish-specific
  ],
  // Row 3
  [
    VirtualKey.action(action: KeyAction.shift),
    VirtualKey.character(text: 'z'),
    VirtualKey.character(text: 'x'),
    VirtualKey.character(text: 'c'),
    VirtualKey.character(text: 'v'),
    VirtualKey.character(text: 'b'),
    VirtualKey.character(text: 'n'),
    VirtualKey.character(text: 'm'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
  // Row 4
  [
    VirtualKey.action(action: KeyAction.symbols, label: '123', altLabel: 'ABC', flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];
```

### Step 2: Define Secondary Layout (Numbers/Symbols)

```dart
final KeyboardLayout _textLayoutSecondary = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
    VirtualKey.character(text: '0'),
  ],
  [
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: ':'),
    VirtualKey.character(text: ';'),
    VirtualKey.character(text: '('),
    VirtualKey.character(text: ')'),
    VirtualKey.character(text: '€'),  // Euro symbol
    VirtualKey.character(text: '&'),
    VirtualKey.character(text: '@'),
    VirtualKey.character(text: '"'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, label: '#+=', altLabel: '123'),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: ','),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: '¿'),  // Spanish-specific
    VirtualKey.character(text: '¡'),  // Spanish-specific
    VirtualKey.character(text: '%'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, label: '123', altLabel: 'ABC', flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];
```

### Step 3: Define Tertiary Layout (More Symbols)

```dart
final KeyboardLayout _textLayoutTertiary = [
  [
    VirtualKey.character(text: '['),
    VirtualKey.character(text: ']'),
    VirtualKey.character(text: '{'),
    VirtualKey.character(text: '}'),
    VirtualKey.character(text: '#'),
    VirtualKey.character(text: '%'),
    VirtualKey.character(text: '^'),
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: '+'),
    VirtualKey.character(text: '='),
  ],
  [
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '\\'),
    VirtualKey.character(text: '|'),
    VirtualKey.character(text: '~'),
    VirtualKey.character(text: '<'),
    VirtualKey.character(text: '>'),
    VirtualKey.character(text: '€'),
    VirtualKey.character(text: '£'),
    VirtualKey.character(text: '¥'),
    VirtualKey.character(text: '•'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, label: '#+=', altLabel: '123'),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: ','),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '`'),
    VirtualKey.character(text: '°'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, label: '123', altLabel: 'ABC', flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];
```

---

## Layout Sets

Group layouts into `KeyboardLayoutSet`:

```dart
final _textLayoutSet = KeyboardLayoutSet(
  primary: _textLayoutPrimary,
  secondary: _textLayoutSecondary,
  tertiary: _textLayoutTertiary,
);
```

For simple layouts (like number pads):

```dart
final _numberLayoutSet = KeyboardLayoutSet.single(_numberLayout);
```

---

## Registration

### Step 4: Create Language Definition

```dart
final KeyboardLanguage spanishLanguage = KeyboardLanguage(
  code: 'es',                    // ISO 639-1 code
  name: 'Spanish',               // English name
  nativeName: 'Español',         // Native name
  isRTL: false,                  // Right-to-left?
  textLayouts: _textLayoutSet,
  emailLayouts: _emailLayoutSet, // Optional
  urlLayouts: _urlLayoutSet,     // Optional
  numberLayouts: _numberLayoutSet,
  phoneLayouts: _phoneLayoutSet,
);
```

### Step 5: Export from languages.dart

```dart
// lib/src/layouts/languages/languages.dart

export 'english.dart';
export 'bengali.dart';
export 'spanish.dart';  // Add export
```

### Step 6: Register at Runtime

```dart
// In your app
import 'package:virtual_keypad/virtual_keypad.dart';
import 'path/to/spanish.dart';

void main() {
  initializeKeyboardLayouts();
  KeyboardLayoutProvider.instance.registerLanguage(spanishLanguage);
  runApp(MyApp());
}

// Switch to Spanish
KeyboardLayoutProvider.instance.setLanguage('es');
```

---

## Complete Example

Here's a complete Spanish language file:

```dart
// lib/src/layouts/languages/spanish.dart

import '../../enums.dart';
import '../../models.dart';
import '../keyboard_language.dart';

// Primary text layout (letters)
final KeyboardLayout _textLayoutPrimary = [
  [
    VirtualKey.character(text: 'q'),
    VirtualKey.character(text: 'w'),
    VirtualKey.character(text: 'e'),
    VirtualKey.character(text: 'r'),
    VirtualKey.character(text: 't'),
    VirtualKey.character(text: 'y'),
    VirtualKey.character(text: 'u'),
    VirtualKey.character(text: 'i'),
    VirtualKey.character(text: 'o'),
    VirtualKey.character(text: 'p'),
  ],
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 's'),
    VirtualKey.character(text: 'd'),
    VirtualKey.character(text: 'f'),
    VirtualKey.character(text: 'g'),
    VirtualKey.character(text: 'h'),
    VirtualKey.character(text: 'j'),
    VirtualKey.character(text: 'k'),
    VirtualKey.character(text: 'l'),
    VirtualKey.character(text: 'ñ'),
  ],
  [
    VirtualKey.action(action: KeyAction.shift),
    VirtualKey.character(text: 'z'),
    VirtualKey.character(text: 'x'),
    VirtualKey.character(text: 'c'),
    VirtualKey.character(text: 'v'),
    VirtualKey.character(text: 'b'),
    VirtualKey.character(text: 'n'),
    VirtualKey.character(text: 'm'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, label: '123', altLabel: 'ABC', flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];

// Secondary layout (numbers & symbols)
final KeyboardLayout _textLayoutSecondary = [
  // ... (as shown above)
];

// Tertiary layout (more symbols)
final KeyboardLayout _textLayoutTertiary = [
  // ... (as shown above)
];

// Language definition
final KeyboardLanguage spanishLanguage = KeyboardLanguage(
  code: 'es',
  name: 'Spanish',
  nativeName: 'Español',
  textLayouts: KeyboardLayoutSet(
    primary: _textLayoutPrimary,
    secondary: _textLayoutSecondary,
    tertiary: _textLayoutTertiary,
  ),
);
```

---

## Tips

1. **Use ISO 639-1 codes** - Standard 2-letter language codes
2. **Reuse common layouts** - Numbers and symbols can be shared
3. **Test thoroughly** - Verify all keys work correctly
4. **Consider RTL** - Set `isRTL: true` for Arabic, Hebrew, etc.
5. **Email/URL layouts** - Add `@` and `/` to primary row for convenience
