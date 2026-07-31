# Floating Mode

Use `VirtualKeypadFloating` when you want the keyboard to behave like an overlay panel instead of an inline widget.

Floating mode changes presentation, not input routing. The keyboard still uses the same standalone or scoped integration rules as `VirtualKeypad`.

## When To Use It

Choose floating mode when you need:

- A draggable keyboard for kiosk, POS, or desktop layouts
- A keyboard that stays above split views, side panels, or dashboards
- The same keyboard behavior as inline mode, but without reserving layout space for it

Choose inline `VirtualKeypad` when the keyboard should live directly in the page layout.

## Standalone Floating Keyboard

Use this when you already have standard Flutter `TextField` or `TextFormField` widgets and want the keyboard to attach to them without refactoring to `VirtualKeypadTextField`.

```dart
import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  initializeKeyboardLayouts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VirtualKeypadFloating(
          standalone: true,
          width: 380,
          height: 280,
          enableEmojiKey: true,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const [
                TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                ),
                SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

In standalone floating mode, the keyboard reads the focused field's `TextInputType` and `TextInputAction`, just like `VirtualKeypad(standalone: true)`.

If you want the floating keyboard to respond only inside part of the widget tree, wrap that subtree with `VirtualKeypadStandaloneScope`.

## Scoped Floating Keyboard

Use this when you want the stricter scoped workflow with `VirtualKeypadScope`, `VirtualKeypadTextField`, and `VirtualKeypadController`.

```dart
VirtualKeypadScope(
  child: VirtualKeypadFloating(
    width: 420,
    height: 280,
    theme: VirtualKeypadTheme.dark,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          VirtualKeypadTextField(
            controller: controller,
            keyboardType: KeyboardType.emailAddress,
            textInputAction: TextInputAction.search,
          ),
        ],
      ),
    ),
  ),
)
```

Keep `VirtualKeypadScope` outside `VirtualKeypadFloating`. The floating host renders the panel, while the scope continues to manage focus, active controller, and submit actions.

## Visibility Modes

`VirtualKeypadFloating` supports two visibility strategies.

| Mode | Behavior | Controller Required |
|------|----------|---------------------|
| `VirtualKeypadFloatingVisibilityMode.onDemand` | Default. The panel appears when a target field activates the keyboard and hides when input focus is gone. | No |
| `VirtualKeypadFloatingVisibilityMode.persistent` | The panel stays visible until you explicitly hide it or the user closes it from the toolbar. | Yes |

Persistent mode requires a `VirtualKeypadFloatingController`.

```dart
final floatingController = VirtualKeypadFloatingController();

VirtualKeypadFloating(
  controller: floatingController,
  visibilityMode: VirtualKeypadFloatingVisibilityMode.persistent,
  child: Column(
    children: [
      TextField(controller: searchController),
    ],
  ),
)
```

You can control the panel manually:

```dart
floatingController.show();
floatingController.hide();
floatingController.toggle();
floatingController.dockTop();
floatingController.dockBottom();
```

## Sizing And Placement

These properties control the panel surface and motion:

- `width`: fixed panel width
- `maxWidth`: responsive width cap when `width` is not set
- `height`: keyboard height inside the panel
- `borderRadius`: rounds the toolbar and keyboard as one clipped surface
- `initialAlignment`: initial panel position inside the host
- `margin`: keeps the panel away from the host edges and safe areas

The floating panel sits on top of `child`, so scrollable pages should usually add bottom padding large enough to keep focused fields visible above the keyboard.

## Toolbar And Docking

The optional toolbar gives users a predictable way to move or dismiss the panel.

- `showToolbar`: enables the drag handle and toolbar shell
- `showCloseButton`: adds a close button to hide the panel
- `showDockButtons`: adds dock-to-top and dock-to-bottom buttons

Docking snaps the panel back to a stable edge-aligned position, which is useful after dragging.

## Forwarded Keyboard Configuration

`VirtualKeypadFloating` forwards normal keyboard options to the internal `VirtualKeypad`, including:

- `type`
- `inputAction`
- `theme`
- `availableLanguages`
- `initialLanguage`
- `customLayout`
- `enableEmojiKey`
- `emojiTextStyle`
- `checkEmojiPlatformCompatibility`
- `enableDpadNavigation`
- `onKeyPressed`
- `onKeyPressedWithText`
- `onStandaloneInputAction`
- `onLanguageChanged`

This means you can use floating mode with the same theming, multi-language setup, custom layouts, and emoji support as inline mode.

## Notes

- Floating mode keeps an internal `VirtualKeypad` mounted so scoped and standalone routing continue to work while the panel animates in and out.
- In on-demand mode, visibility follows the active input target rather than a manual show/hide lifecycle.
- In persistent mode, hiding the panel does not change your field configuration; it only changes panel visibility.
- Long-press the space bar to switch languages when `availableLanguages` contains more than one valid language.