# Custom Layouts Guide

Learn how to create custom keyboard layouts for the Virtual Keypad package.

## Table of Contents

- [Basic Structure](#basic-structure)
- [Character Keys](#character-keys)
- [Action Keys](#action-keys)
- [Key Sizing with Flex](#key-sizing-with-flex)
- [Complete Examples](#complete-examples)

---

## Basic Structure

A keyboard layout is a 2D array of `VirtualKey` objects:

```dart
KeyboardLayout myLayout = [
  [ /* Row 1 keys */ ],
  [ /* Row 2 keys */ ],
  [ /* Row 3 keys */ ],
];
```

---

## Character Keys

Character keys insert text when pressed.

```dart
VirtualKey.character(
  text: 'a',        // Lowercase (required)
  capsText: 'A',    // Uppercase (optional, auto-generated)
  flex: 1,          // Relative width (default: 1)
)
```

### Examples

```dart
// Simple character
VirtualKey.character(text: 'a')

// With custom caps
VirtualKey.character(text: '1', capsText: '!')

// Special character
VirtualKey.character(text: '@')
```

---

## Action Keys

Action keys perform keyboard functions.

```dart
VirtualKey.action(
  action: KeyAction.backSpace,  // Required action type
  label: '⌫',                   // Primary label (optional)
  altLabel: 'DEL',              // Alt state label (optional)
  flex: 2,                      // Relative width
)
```

### Available Actions

| Action | Description | Default Icon/Label |
|--------|-------------|-------------------|
| `backSpace` | Delete before cursor | ⌫ icon |
| `enter` | Submit or newline | ↵ icon |
| `shift` | Toggle uppercase | ⇧ icon |
| `space` | Insert space | "space" |
| `symbols` | Switch to symbols | "123" |
| `symbolsAlt` | Switch alt symbols | "#+=" |
| `done` | Submit action | "Done" |
| `go` | Navigate action | "Go" |
| `search` | Search action | 🔍 icon |
| `send` | Send action | ➤ icon |

### Examples

```dart
// Backspace key
VirtualKey.action(action: KeyAction.backSpace)

// Enter with custom label
VirtualKey.action(action: KeyAction.enter, label: 'Submit')

// Done button
VirtualKey.action(action: KeyAction.done, label: 'OK', flex: 2)
```

---

## Key Sizing with Flex

The `flex` property controls relative key width. Default is 1.

```dart
// Row with flex values
[
  VirtualKey.character(text: 'A', flex: 1),  // 1 unit wide
  VirtualKey.action(action: KeyAction.space, flex: 4),  // 4 units wide
  VirtualKey.character(text: 'B', flex: 1),  // 1 unit wide
]
// Total: 6 units, space takes 4/6 = 66% of row width
```

---

## Complete Examples

### PIN Pad

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

// Usage
VirtualKeypad(
  type: KeyboardType.custom,
  customLayout: pinLayout,
)
```

### Calculator Pad

```dart
final calculatorLayout = [
  [
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
    VirtualKey.character(text: '÷'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
    VirtualKey.character(text: '×'),
  ],
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
    VirtualKey.character(text: '-'),
  ],
  [
    VirtualKey.character(text: '0'),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.backSpace),
    VirtualKey.character(text: '+'),
  ],
];
```

### Emoji Picker

```dart
final emojiLayout = [
  [
    VirtualKey.character(text: '😀'),
    VirtualKey.character(text: '😂'),
    VirtualKey.character(text: '😍'),
    VirtualKey.character(text: '🤔'),
    VirtualKey.character(text: '😎'),
  ],
  [
    VirtualKey.character(text: '👍'),
    VirtualKey.character(text: '👎'),
    VirtualKey.character(text: '❤️'),
    VirtualKey.character(text: '🔥'),
    VirtualKey.character(text: '✨'),
  ],
  [
    VirtualKey.action(action: KeyAction.backSpace, flex: 2),
    VirtualKey.action(action: KeyAction.done, label: 'Done', flex: 3),
  ],
];
```

### Hex Input

```dart
final hexLayout = [
  [
    VirtualKey.character(text: '0'),
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
    VirtualKey.character(text: '7'),
  ],
  [
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
    VirtualKey.character(text: 'A'),
    VirtualKey.character(text: 'B'),
  ],
  [
    VirtualKey.character(text: 'C'),
    VirtualKey.character(text: 'D'),
    VirtualKey.character(text: 'E'),
    VirtualKey.character(text: 'F'),
  ],
  [
    VirtualKey.action(action: KeyAction.backSpace, flex: 2),
    VirtualKey.action(action: KeyAction.done, label: 'OK', flex: 2),
  ],
];
```

---

## Tips

1. **Keep rows balanced** - Use flex values to ensure consistent layout
2. **Provide visual feedback** - Use action keys with clear labels
3. **Consider touch targets** - Don't make keys too small
4. **Test on target devices** - Verify layout works on all screen sizes
