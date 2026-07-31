# Virtual Keypad Example

A single page that exercises the whole package. Every option is a switch or a
chip, so you change one thing and watch the same keyboard react.

## Run it

```bash
flutter pub get
flutter run
```

Or in a browser:

```bash
flutter run -d chrome
```

## What you can change

| Control | What it shows |
|---|---|
| Keyboard type chips | Text, multiline, number, phone, email, URL, and a custom PIN pad |
| Language chips | Live switching across English, Bengali, Arabic (RTL), French, Hindi, Russian |
| Emoji key | The opt-in emoji page |
| Dark keyboard theme | `VirtualKeypadTheme.dark` against the light default |
| Floating mode | `VirtualKeypadFloating` as a draggable panel instead of an inline keyboard |
| D-pad navigation | Arrow keys move a highlight, Enter presses the key, for TV and set-top boxes |

The field at the top is a plain Flutter `TextField`. That is the point of
standalone mode: no wrapper widgets, no controller swap.

## Emoji font status

The bottom of the page reports which emoji font is in use.

Web has no system emoji font, so the package bundles one and applies it there
only. Native platforms already render colour emoji from the OS and are left
alone. Run the page with `flutter run -d chrome` to confirm the web path
works, which is worth doing because `flutter test --platform chrome` is broken
on Windows ([flutter#162798](https://github.com/flutter/flutter/issues/162798)).

## Choosing an integration mode

- **Standalone**: standard `TextField` plus `VirtualKeypad(standalone: true)`. Fastest path, and what this example uses.
- **Floating**: wrap your content in `VirtualKeypadFloating(...)` for a draggable panel.
- **Scoped**: `VirtualKeypadScope`, `VirtualKeypadTextField`, and `VirtualKeypad()` together when you need focus routing, submit handling, or to block the system keyboard.
