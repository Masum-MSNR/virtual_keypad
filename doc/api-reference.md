# API Reference

Complete API documentation for Virtual Keypad package.

## Table of Contents

- [VirtualKeypadScope](#virtualkeypadscope)
- [VirtualKeypadTextField](#virtualkeypadtextfield)
- [VirtualKeypad](#virtualkeypad)
- [VirtualKeypadController](#virtualkeypadcontroller)
- [VirtualKeypadTheme](#virtualkeypadtheme)
- [KeyboardLayoutProvider](#keyboardlayoutprovider)
- [VirtualKey](#virtualkey)
- [Enums](#enums)

---

## VirtualKeypadScope

Required wrapper widget that manages the connection between text fields and the keyboard.

### Usage

```dart
VirtualKeypadScope(
  child: Column(
    children: [
      VirtualKeypadTextField(controller: controller),
      VirtualKeypad(),
    ],
  ),
)
```

### Static Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `of(BuildContext context)` | `VirtualKeypadScopeState?` | Gets the scope state from context |

### State Properties

| Property | Type | Description |
|----------|------|-------------|
| `activeController` | `VirtualKeypadController?` | Currently focused text field's controller |
| `activeKeyboardType` | `KeyboardType` | Keyboard type of active field |
| `activeInputAction` | `TextInputAction` | Input action of active field |
| `hasActiveController` | `bool` | Whether any field is focused |
| `allowPhysicalKeyboard` | `bool` | Whether physical keyboard is allowed |

---

## VirtualKeypadTextField

A TextField replacement that integrates with the virtual keyboard.

### Constructor

```dart
VirtualKeypadTextField({
  required VirtualKeypadController controller,
  InputDecoration? decoration,
  TextStyle? style,
  int? maxLength,
  bool obscureText = false,
  String obscuringCharacter = '•',
  bool enabled = true,
  bool readOnly = false,
  bool autofocus = false,
  TextAlign textAlign = TextAlign.start,
  TextAlignVertical? textAlignVertical,
  int? maxLines = 1,
  int? minLines,
  ValueChanged<String>? onChanged,
  VoidCallback? onTap,
  ValueChanged<String>? onSubmitted,
  bool allowPhysicalKeyboard = false,
  KeyboardType keyboardType = KeyboardType.text,
  TextInputAction? textInputAction,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `controller` | `VirtualKeypadController` | *required* | Text editing controller |
| `decoration` | `InputDecoration?` | `null` | Input decoration |
| `style` | `TextStyle?` | `null` | Text style |
| `maxLength` | `int?` | `null` | Maximum character count |
| `obscureText` | `bool` | `false` | Hide text (password mode) |
| `obscuringCharacter` | `String` | `'•'` | Character for obscured text |
| `enabled` | `bool` | `true` | Whether field accepts input |
| `readOnly` | `bool` | `false` | Display only, no input |
| `autofocus` | `bool` | `false` | Auto-focus on build |
| `textAlign` | `TextAlign` | `start` | Text alignment |
| `maxLines` | `int?` | `1` | Maximum lines (null = unlimited) |
| `minLines` | `int?` | `null` | Minimum lines |
| `allowPhysicalKeyboard` | `bool` | `false` | Allow system keyboard |
| `keyboardType` | `KeyboardType` | `text` | Keyboard layout type |
| `textInputAction` | `TextInputAction?` | `null` | Action button type |

### Callbacks

| Callback | Type | Description |
|----------|------|-------------|
| `onChanged` | `ValueChanged<String>?` | Called when text changes |
| `onTap` | `VoidCallback?` | Called when field is tapped |
| `onSubmitted` | `ValueChanged<String>?` | Called on submit action |

---

## VirtualKeypad

The on-screen keyboard widget.

### Constructor

```dart
VirtualKeypad({
  KeyboardType? type,
  double height = 280,
  double? width,
  VirtualKeypadTheme theme = VirtualKeypadTheme.light,
  void Function(VirtualKey key)? onKeyPressed,
  KeyboardLayout? customLayout,
  bool hideWhenUnfocused = false,
  Duration animationDuration = const Duration(milliseconds: 200),
  Curve animationCurve = Curves.easeInOut,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `type` | `KeyboardType?` | `null` | Override keyboard type (auto if null) |
| `height` | `double` | `280` | Keyboard height in pixels |
| `width` | `double?` | `null` | Width (screen width if null) |
| `theme` | `VirtualKeypadTheme` | `light` | Visual theme |
| `customLayout` | `KeyboardLayout?` | `null` | Custom key layout |
| `hideWhenUnfocused` | `bool` | `false` | Hide when no field focused |
| `animationDuration` | `Duration` | `200ms` | Show/hide animation duration |
| `animationCurve` | `Curve` | `easeInOut` | Animation curve |

### Callbacks

| Callback | Type | Description |
|----------|------|-------------|
| `onKeyPressed` | `void Function(VirtualKey)?` | Called when any key is pressed |

---

## VirtualKeypadController

Extended `TextEditingController` with additional text manipulation methods.

### Constructor

```dart
VirtualKeypadController({String? text})
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `text` | `String` | Current text content |
| `selection` | `TextSelection` | Current selection |
| `cursorPosition` | `int` | Cursor offset (get/set) |

### Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `insertText(String text)` | `void` | Insert text at cursor or replace selection |
| `deleteBackward()` | `void` | Delete character before cursor or selection |
| `deleteForward()` | `void` | Delete character after cursor |
| `clear()` | `void` | Clear all text |
| `selectAll()` | `void` | Select all text |
| `moveCursorLeft()` | `void` | Move cursor left one position |
| `moveCursorRight()` | `void` | Move cursor right one position |
| `moveCursorToStart()` | `void` | Move cursor to beginning |
| `moveCursorToEnd()` | `void` | Move cursor to end |
| `deleteRange(int start, int end)` | `void` | Delete text in range |
| `replaceRange(int start, int end, String text)` | `void` | Replace text in range |

---

## VirtualKeypadTheme

Theme configuration for keyboard appearance.

### Constructor

```dart
VirtualKeypadTheme({
  Color backgroundColor = VkpColors.backgroundColor,
  Color keyColor = VkpColors.keyColor,
  Color actionKeyColor = VkpColors.actionKeyColor,
  Color keyTextColor = VkpColors.keyTextColor,
  double keyTextSize = 22.0,
  double keyBorderRadius = 6.0,
  bool keyShadow = true,
  Color? splashColor,
  double horizontalGap = 6.0,
  double verticalGap = 8.0,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backgroundColor` | `Color` | `#D1D3D9` | Keyboard background |
| `keyColor` | `Color` | `#FFFFFF` | Character key color |
| `actionKeyColor` | `Color` | `#ADB3BC` | Action key color |
| `keyTextColor` | `Color` | `#1C1C1E` | Text/icon color |
| `keyTextSize` | `double` | `22.0` | Font size |
| `keyBorderRadius` | `double` | `6.0` | Key corner radius |
| `keyShadow` | `bool` | `true` | Show key shadows |
| `splashColor` | `Color?` | `null` | Tap ripple color |
| `horizontalGap` | `double` | `6.0` | Gap between keys |
| `verticalGap` | `double` | `8.0` | Gap between rows |

### Static Properties

| Property | Type | Description |
|----------|------|-------------|
| `light` | `VirtualKeypadTheme` | Light theme preset |
| `dark` | `VirtualKeypadTheme` | Dark theme preset |

### Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `copyWith(...)` | `VirtualKeypadTheme` | Create copy with overrides |

---

## KeyboardLayoutProvider

Singleton managing keyboard languages and layouts.

### Access

```dart
KeyboardLayoutProvider.instance
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `currentLanguage` | `KeyboardLanguage` | Current language |
| `currentLanguageCode` | `String` | Current language code |
| `languages` | `Iterable<KeyboardLanguage>` | All registered languages |
| `languageCodes` | `Iterable<String>` | All language codes |

### Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `registerLanguage(KeyboardLanguage)` | `void` | Register a language |
| `unregisterLanguage(String code)` | `bool` | Remove a language |
| `setLanguage(String code)` | `bool` | Switch language |
| `getLanguage(String code)` | `KeyboardLanguage?` | Get language by code |
| `hasLanguage(String code)` | `bool` | Check if registered |
| `getLayouts(KeyboardInputType)` | `KeyboardLayoutSet` | Get layouts for input type |
| `reset()` | `void` | Reset to defaults |

### Initialization

```dart
initializeKeyboardLayouts(); // Call at app startup
```

---

## VirtualKey

Represents a single key on the keyboard.

### Constructors

```dart
// Character key
VirtualKey.character({
  required String text,
  String? capsText,
  int flex = 1,
})

// Action key
VirtualKey.action({
  required KeyAction action,
  String? text,
  String? label,
  String? altLabel,
  int flex = 1,
})
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `text` | `String?` | Character to insert |
| `capsText` | `String?` | Uppercase character |
| `keyType` | `KeyType` | `character` or `action` |
| `action` | `KeyAction?` | Action type (for action keys) |
| `label` | `String?` | Primary label |
| `altLabel` | `String?` | Alternate label |
| `flex` | `int` | Relative width |
| `isCharacter` | `bool` | Is character key |
| `isAction` | `bool` | Is action key |

### Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `getDisplayText({shift, capsLock})` | `String` | Get display text |
| `getInsertText({shift, capsLock})` | `String` | Get text to insert |

---

## Enums

### KeyboardType

```dart
enum KeyboardType {
  text,           // Standard QWERTY
  multiline,      // QWERTY with newline
  number,         // Number pad
  numberSigned,   // Numbers with minus
  numberDecimal,  // Numbers with decimal
  phone,          // Phone dialer
  datetime,       // Date/time input
  emailAddress,   // Email layout
  url,            // URL layout
  visiblePassword,// Same as text
  name,           // Name input
  streetAddress,  // Address input
  none,           // Hidden
  custom,         // Custom layout
}
```

### KeyAction

```dart
enum KeyAction {
  backSpace,      // Delete backward
  enter,          // Newline/submit
  shift,          // Toggle shift
  space,          // Insert space
  symbols,        // Switch to symbols
  symbolsAlt,     // Switch to alt symbols
  switchLanguage, // Change language
  done,           // Submit
  go,             // Navigate
  search,         // Search
  send,           // Send
  next,           // Next field
  previous,       // Previous field
  call,           // Call action
}
```

### KeyType

```dart
enum KeyType {
  action,    // Action key
  character, // Character key
}
```

### KeyboardInputType

```dart
enum KeyboardInputType {
  text,          // General text
  email,         // Email input
  url,           // URL input
  number,        // Number input
  numberSigned,  // Signed number
  numberDecimal, // Decimal number
  phone,         // Phone input
}
```
