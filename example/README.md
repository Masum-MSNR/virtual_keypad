# Virtual Keypad Example

This example app shows how to integrate `virtual_keypad` in real UI flows instead of isolated toy widgets.

## Run It

```bash
flutter pub get
flutter run
```

## What It Covers

- Keyboard Preview: compare layouts, actions, and languages quickly
- Numeric Input: amount entry with a number-focused keypad
- PIN Pad: fully custom layout with fixed-position keys
- Password Entry: hidden text flow with submit behavior
- Email & URL: input-aware action keys and layout changes
- Multi-Field Form: scoped mode with focus-driven behavior
- Multiline Text: newline-aware keyboard behavior
- Standalone Mode: use the keyboard with standard Flutter `TextField`s
- Floating Keyboard: draggable overlay mode with desk search, phone pad, multilingual notes, payment, and approval PIN flows
- Auto-Hide Keyboard: focus-aware show and hide transitions
- Custom Themes: theme presets and custom styling
- Language Switching: built-in multi-language support

## Which Screen To Open First

- Start with `Standalone Mode` if you want the fastest integration path.
- Start with `Floating Keyboard` if you want overlay-style placement and want to compare several real workflows in one screen.
- Start with `Multi-Field Form` if you need structured form flows and keyboard-managed submit behavior.
- Start with `PIN Pad` if you need a custom layout.

## Architecture Guide

- Standalone mode: use standard `TextField` widgets with `VirtualKeypad(standalone: true)`.
- Floating mode: wrap your content with `VirtualKeypadFloating(...)` when you want the keyboard in a draggable panel.
- Scoped mode: use `VirtualKeypadScope`, `VirtualKeypadTextField`, and `VirtualKeypad()` together when you need tighter control.

The example app is intentionally broad: it is both a demo and a decision guide for choosing the right integration mode.
