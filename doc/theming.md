# Theming Guide

Customize the keyboard appearance to match your app.

## Built-in Themes

```dart
VirtualKeypad(theme: VirtualKeypadTheme.light) // Default
VirtualKeypad(theme: VirtualKeypadTheme.dark)
```

| | Light | Dark |
|---|---|---|
| Background | `#D1D3D9` | `#2C2C2E` |
| Key | `#FFFFFF` | `#636366` |
| Action Key | `#ADB3BC` | `#48484A` |
| Text | `#1C1C1E` | `#FFFFFF` |

## Custom Theme

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

## Modify Existing Theme

```dart
VirtualKeypad(
  theme: VirtualKeypadTheme.dark.copyWith(
    keyBorderRadius: 12,
    keyTextSize: 24,
  ),
)
```

## Match System Theme

```dart
VirtualKeypad(
  theme: Theme.of(context).brightness == Brightness.dark
      ? VirtualKeypadTheme.dark
      : VirtualKeypadTheme.light,
)
```

## Match App Colors

```dart
VirtualKeypad(
  theme: VirtualKeypadTheme(
    backgroundColor: Theme.of(context).colorScheme.surface,
    keyColor: Theme.of(context).colorScheme.primaryContainer,
    actionKeyColor: Theme.of(context).colorScheme.secondaryContainer,
    keyTextColor: Theme.of(context).colorScheme.onSurface,
  ),
)
```

## Theme Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backgroundColor` | `Color` | `#D1D3D9` | Keyboard background |
| `keyColor` | `Color` | `#FFFFFF` | Character key color |
| `actionKeyColor` | `Color` | `#ADB3BC` | Action key color |
| `keyTextColor` | `Color` | `#1C1C1E` | Text/icon color |
| `keyTextSize` | `double` | `22.0` | Font size |
| `keyTextStyle` | `TextStyle?` | `null` | Key label style, merged over the color and size |
| `keyBorderRadius` | `double` | `6.0` | Corner radius |
| `keyShadow` | `bool` | `true` | Show shadows |
| `splashColor` | `Color?` | `null` | Tap ripple color |
| `horizontalGap` | `double` | `6.0` | Horizontal spacing |
| `verticalGap` | `double` | `8.0` | Vertical spacing |

## A brand font on the keys

`keyTextStyle` sits on top of `keyTextColor` and `keyTextSize`, so you only set
what you want to change:

```dart
VirtualKeypad(
  theme: VirtualKeypadTheme.light.copyWith(
    keyTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
    ),
  ),
)
```

Setting `fontSize` or `color` inside the style overrides `keyTextSize` and
`keyTextColor` for the labels. Icons on action keys keep following
`keyTextColor` and `keyTextSize`, since a font family does not apply to them.
