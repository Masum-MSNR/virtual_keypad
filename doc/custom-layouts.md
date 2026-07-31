# Custom Layouts

Create custom keyboard layouts for specialized input needs.

## Structure

A layout is a 2D list of `VirtualKey` objects (rows × keys):

```dart
KeyboardLayout myLayout = [
  [/* Row 1 */],
  [/* Row 2 */],
  [/* Row 3 */],
];
```

## Key Types

```dart
// Character key: inserts text
VirtualKey.character(text: 'a', capsText: 'A', flex: 1)

// Action key: performs a function
VirtualKey.action(action: KeyAction.backSpace, label: '⌫', flex: 2)
```

### Available Actions

| Action | Description |
|--------|-------------|
| `backSpace` | Delete before cursor |
| `enter` | Submit / newline |
| `shift` | Toggle uppercase |
| `space` | Insert space |
| `symbols` | Switch to symbols |
| `done` | Submit action |

All `KeyAction` values are available in custom layouts, including `next`, `previous`, `search`, `send`, and `call`.

## Flex Sizing

The `flex` property sets relative key width:

```dart
[
  VirtualKey.character(text: 'A', flex: 1),          // 1/6 width
  VirtualKey.action(action: KeyAction.space, flex: 4), // 4/6 width
  VirtualKey.character(text: 'B', flex: 1),          // 1/6 width
]
```

## Examples

Use custom layouts with `type: KeyboardType.custom`:

```dart
VirtualKeypad(
  type: KeyboardType.custom,
  customLayout: pinLayout,
)
```

If `type` and `customLayout` do not match, the widget asserts in debug mode so configuration mistakes surface immediately.

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

VirtualKeypad(type: KeyboardType.custom, customLayout: pinLayout)
```

### Calculator

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
