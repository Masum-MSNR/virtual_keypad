# API Reference

Complete API documentation for the Virtual Keypad package.

## VirtualKeypadStandaloneScope

Optional wrapper that restricts a standalone-mode keyboard to only respond to text fields within its subtree.

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

| Static Method | Return Type | Description |
|---------------|-------------|-------------|
| `maybeOf(BuildContext)` | `VirtualKeypadStandaloneScopeState?` | Nearest ancestor scope, or null |

## VirtualKeypadScope

Required wrapper that connects text fields to the keyboard.

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

| State Property | Type | Description |
|----------------|------|-------------|
| `activeController` | `VirtualKeypadController?` | Currently focused controller |
| `activeKeyboardType` | `KeyboardType` | Active keyboard type |
| `hasActiveController` | `bool` | Whether any field is focused |

## VirtualKeypadTextField

Drop-in `TextField` replacement with virtual keyboard integration.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `controller` | `VirtualKeypadController` | *required* | Text controller |
| `keyboardType` | `KeyboardType` | `text` | Layout type |
| `obscureText` | `bool` | `false` | Password mode |
| `allowPhysicalKeyboard` | `bool` | `false` | Allow system keyboard |
| `maxLength` | `int?` | `null` | Character limit |
| `maxLines` | `int?` | `1` | Line count (`null` = unlimited) |
| `decoration` | `InputDecoration?` | `null` | Input decoration |
| `onChanged` | `ValueChanged<String>?` | `null` | Text change callback |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Submit callback |
| `onTap` | `VoidCallback?` | `null` | Tap callback |
| `autofocus` | `bool` | `false` | Auto-focus on build |
| `enabled` | `bool` | `true` | Accept input |
| `readOnly` | `bool` | `false` | Display only |

## VirtualKeypad

The on-screen keyboard widget.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `type` | `KeyboardType?` | `null` | Override layout (auto if null) |
| `height` | `double` | `280` | Keyboard height |
| `theme` | `VirtualKeypadTheme` | `light` | Visual theme |
| `hideWhenUnfocused` | `bool` | `false` | Auto-hide animation |
| `customLayout` | `KeyboardLayout?` | `null` | Custom key arrangement |
| `onKeyPressed` | `void Function(VirtualKey)?` | `null` | Key press callback |
| `animationDuration` | `Duration` | `200ms` | Show/hide duration |

## VirtualKeypadController

Extended `TextEditingController` with cursor and selection methods.

| Method | Description |
|--------|-------------|
| `insertText(String)` | Insert at cursor / replace selection |
| `deleteBackward()` | Delete before cursor |
| `deleteForward()` | Delete after cursor |
| `clear()` | Clear all text |
| `selectAll()` | Select all |
| `moveCursorLeft()` | Move cursor left |
| `moveCursorRight()` | Move cursor right |
| `moveCursorToStart()` | Jump to start |
| `moveCursorToEnd()` | Jump to end |
| `cursorPosition` | Get/set cursor offset |

## VirtualKeypadTheme

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backgroundColor` | `Color` | `#D1D3D9` | Keyboard background |
| `keyColor` | `Color` | `#FFFFFF` | Character key color |
| `actionKeyColor` | `Color` | `#ADB3BC` | Action key color |
| `keyTextColor` | `Color` | `#1C1C1E` | Text/icon color |
| `keyTextSize` | `double` | `22.0` | Font size |
| `keyBorderRadius` | `double` | `6.0` | Corner radius |
| `keyShadow` | `bool` | `true` | Show shadows |
| `splashColor` | `Color?` | `null` | Tap ripple color |

**Presets:** `VirtualKeypadTheme.light`, `VirtualKeypadTheme.dark`
**Methods:** `copyWith(...)` — create modified copy

## KeyboardLayoutProvider

Singleton for managing languages. Access via `KeyboardLayoutProvider.instance`.

| Method | Description |
|--------|-------------|
| `registerLanguage(KeyboardLanguage)` | Register a language |
| `setLanguage(String code)` | Switch active language |
| `getLanguage(String code)` | Get language by code |
| `hasLanguage(String code)` | Check if registered |

**Initialize:** Call `initializeKeyboardLayouts()` at app startup.

## VirtualKey

```dart
VirtualKey.character(text: 'a', capsText: 'A', flex: 1)
VirtualKey.action(action: KeyAction.backSpace, label: '⌫', flex: 2)
```

## Enums

### KeyboardType

`text` · `multiline` · `number` · `numberSigned` · `phone` · `emailAddress` · `url` · `custom`

### KeyAction

`backSpace` · `enter` · `shift` · `space` · `symbols` · `symbolsAlt` · `done` · `go` · `search` · `send` · `next` · `previous`
