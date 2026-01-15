# Theming Guide

Customize the appearance of Virtual Keypad to match your app's design.

## Table of Contents

- [Built-in Themes](#built-in-themes)
- [Custom Themes](#custom-themes)
- [Theme Properties](#theme-properties)
- [Dynamic Theming](#dynamic-theming)
- [Theme Examples](#theme-examples)

---

## Built-in Themes

Virtual Keypad includes two pre-built themes:

### Light Theme (Default)

```dart
VirtualKeypad(theme: VirtualKeypadTheme.light)
```

<table>
<tr><td>Background</td><td><code>#D1D3D9</code></td></tr>
<tr><td>Key Color</td><td><code>#FFFFFF</code></td></tr>
<tr><td>Action Key</td><td><code>#ADB3BC</code></td></tr>
<tr><td>Text Color</td><td><code>#1C1C1E</code></td></tr>
</table>

### Dark Theme

```dart
VirtualKeypad(theme: VirtualKeypadTheme.dark)
```

<table>
<tr><td>Background</td><td><code>#2C2C2E</code></td></tr>
<tr><td>Key Color</td><td><code>#636366</code></td></tr>
<tr><td>Action Key</td><td><code>#48484A</code></td></tr>
<tr><td>Text Color</td><td><code>#FFFFFF</code></td></tr>
</table>

---

## Custom Themes

Create a custom theme by instantiating `VirtualKeypadTheme`:

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
  ),
)
```

---

## Theme Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backgroundColor` | `Color` | `#D1D3D9` | Keyboard background |
| `keyColor` | `Color` | `#FFFFFF` | Character key background |
| `actionKeyColor` | `Color` | `#ADB3BC` | Action key background |
| `keyTextColor` | `Color` | `#1C1C1E` | Text and icon color |
| `keyTextSize` | `double` | `22.0` | Font size in pixels |
| `keyBorderRadius` | `double` | `6.0` | Corner radius |
| `keyShadow` | `bool` | `true` | Show drop shadows |
| `splashColor` | `Color?` | `null` | Tap ripple color |
| `horizontalGap` | `double` | `6.0` | Space between keys |
| `verticalGap` | `double` | `8.0` | Space between rows |

---

## Dynamic Theming

### Match System Theme

```dart
VirtualKeypad(
  theme: Theme.of(context).brightness == Brightness.dark
      ? VirtualKeypadTheme.dark
      : VirtualKeypadTheme.light,
)
```

### Match App ColorScheme

```dart
VirtualKeypad(
  theme: VirtualKeypadTheme(
    backgroundColor: Theme.of(context).colorScheme.surface,
    keyColor: Theme.of(context).colorScheme.primaryContainer,
    actionKeyColor: Theme.of(context).colorScheme.secondaryContainer,
    keyTextColor: Theme.of(context).colorScheme.onSurface,
    splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
  ),
)
```

### Using copyWith

Modify existing themes:

```dart
VirtualKeypad(
  theme: VirtualKeypadTheme.dark.copyWith(
    keyBorderRadius: 12,
    keyTextSize: 24,
  ),
)
```

---

## Theme Examples

### iOS Style

```dart
final iosTheme = VirtualKeypadTheme(
  backgroundColor: Color(0xFFD1D3D9),
  keyColor: Colors.white,
  actionKeyColor: Color(0xFFADB3BC),
  keyTextColor: Colors.black,
  keyTextSize: 22,
  keyBorderRadius: 5,
  keyShadow: true,
  horizontalGap: 6,
  verticalGap: 12,
);
```

### Material You

```dart
VirtualKeypadTheme materialYouTheme(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  return VirtualKeypadTheme(
    backgroundColor: scheme.surfaceVariant,
    keyColor: scheme.surface,
    actionKeyColor: scheme.secondaryContainer,
    keyTextColor: scheme.onSurface,
    keyBorderRadius: 12,
    keyShadow: false,
    splashColor: scheme.primary.withOpacity(0.12),
  );
}
```

### Flat/Minimal

```dart
final flatTheme = VirtualKeypadTheme(
  backgroundColor: Colors.grey[100]!,
  keyColor: Colors.grey[100]!,
  actionKeyColor: Colors.grey[300]!,
  keyTextColor: Colors.grey[800]!,
  keyBorderRadius: 0,
  keyShadow: false,
  horizontalGap: 2,
  verticalGap: 2,
);
```

### Neon/Gaming

```dart
final neonTheme = VirtualKeypadTheme(
  backgroundColor: Colors.black,
  keyColor: Colors.grey[900]!,
  actionKeyColor: Colors.purple[900]!,
  keyTextColor: Colors.cyanAccent,
  keyBorderRadius: 4,
  keyShadow: true,
  splashColor: Colors.cyanAccent.withOpacity(0.3),
);
```

### Rounded

```dart
final roundedTheme = VirtualKeypadTheme(
  backgroundColor: Colors.grey[200]!,
  keyColor: Colors.white,
  actionKeyColor: Colors.grey[400]!,
  keyTextColor: Colors.black87,
  keyBorderRadius: 20,
  keyShadow: true,
  horizontalGap: 8,
  verticalGap: 10,
);
```

### High Contrast (Accessibility)

```dart
final highContrastTheme = VirtualKeypadTheme(
  backgroundColor: Colors.black,
  keyColor: Colors.white,
  actionKeyColor: Colors.yellow,
  keyTextColor: Colors.black,
  keyTextSize: 26,
  keyBorderRadius: 4,
  keyShadow: false,
);
```

---

## Tips

1. **Test contrast** - Ensure text is readable on all key types
2. **Consider accessibility** - Large text and high contrast help users
3. **Match your brand** - Use your app's color palette
4. **Test on devices** - Colors may appear differently on various screens
5. **Shadows on dark themes** - May not be visible, consider disabling
