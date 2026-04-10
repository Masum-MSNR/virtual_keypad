## 0.5.1

### Fixed
* Shorten package description to comply with pub.dev 180-character limit

---

## 0.5.0

### Added
* **9 new keyboard languages** — Arabic (`ar`), German (`de`), Hindi (`hi`), Korean (`ko`), Portuguese (`pt`), Russian (`ru`), Spanish (`es`), Thai (`th`), and Turkish (`tr`), bringing the total to **12 built-in languages**
* Arabic layout with full RTL support (`isRTL: true`), Arabic-Indic numerals, diacritics, and Arabic punctuation (،/؟/؛)
* Korean Dubeolsik (두벌식) layout with shift for double consonants (ㅃㅉㄸㄲㅆ) and compound vowels (ㅒㅖ)
* Thai Kedmanee layout with Thai numerals (๑–๐), tone marks, and ฿ currency symbol
* Non-Latin scripts (Arabic, Bengali, Hindi, Korean, Russian, Thai) use Latin QWERTY for email/URL input types
* Native numeral support for Arabic (١–٠), Bengali (১–০), Hindi (१–०), and Thai (๑–๐) number pads with Western digit fallback via capsText
* Language dropdown selectors in Keyboard Preview and Language Switching example screens
* Localized hint text for all 12 languages in the Language Switching example

### Fixed
* Normalized key flex values across all layouts for consistent key sizing
* Visual alignment of action keys (shift, backspace, symbols) now uniform across languages

### Improved
* Keyboard Preview example now shows all layouts for the selected language

---

## 0.4.3

### Fixed
* Fix encoding corruption (mojibake) in French keyboard tertiary layout — all special characters (`€`, `•`, `√`, `π`, `÷`, `×`, `¶`, `∆`, `£`, `¥`, `¢`, `°`, `©`, `®`, `™`, `✓`) now display correctly
* Fix dartdoc warnings from unescaped doc references in `VirtualKeypadController`, `VirtualKey`, and `VirtualKeypad`
* `nativeName` for French language corrected from garbled text to `Français`

---

## 0.4.2

### Fixed
* Fix standalone keyboard breaking when navigating between pages that both use standalone mode — the previous page's `dispose` was restoring platform input control after the new page's `initState` had already set it (thanks @EArminjon, PR #7)
* Defer `setState` in standalone `onHide` callback via `addPostFrameCallback` to avoid calling it during build

---

## 0.4.1

### Fixed
* Skip opening virtual keyboard on read-only text fields (thanks @EArminjon, PR #6)

### Added
* CI workflow for auto-deploying example app to Firebase Hosting ([masum-vk.web.app](https://masum-vk.web.app))
* Live demo badge in README

---

## 0.4.0

### Added
* **`VirtualKeypadStandaloneScope`** — New widget that restricts a standalone-mode keyboard to only respond to text fields within its subtree. Useful for apps like Widgetbook where multiple widget previews are shown simultaneously.
* `VirtualKeypadStandaloneScope.maybeOf(context)` static method to look up the nearest scope.
* Scope-aware focus handling in `VirtualKeypad` — the keyboard now hides when focus moves to a text field outside its scope.
* Tests for `VirtualKeypadStandaloneScope` (`maybeOf` null case, ancestor lookup, sibling scope isolation).

### Fixed
* Dart formatting applied consistently across all example files to satisfy CI checks.

---

## 0.3.1

* Re-release of 0.3.0 (publish fix)

---

## 0.3.0

### Added
* **Standalone mode** — `VirtualKeypad(standalone: true)` works with any standard Flutter `TextField` or `TextFormField` without requiring `VirtualKeypadScope` or `VirtualKeypadTextField`. The keyboard intercepts Flutter's text input system and routes key presses to whichever field has focus.
* `StandaloneInputControl` — exported `TextInputControl` implementation that powers standalone mode.
* Auto-detects `TextInputType` from the focused field and adapts keyboard layout accordingly.
* **French (AZERTY) keyboard** — full text, email, URL, number, and phone layouts (`'fr'`).
* **`inputAction` parameter** on `VirtualKeypad` — override the enter/done key action label directly.
* **Smart enter key** — shows action label (Done, Go, Search, Send, Next) for non-multiline keyboards; shows return icon for multiline.
* `onKeyPressedWithText` callback — fires with `(VirtualKey key, String? text)`, where `text` is the actual inserted character (respecting shift/caps), or `null` for action keys.
* Standalone mode example screen in the example app.
* French language added to the language switching example.

---

## 0.2.1

### Improved
* Optimized package topics for better pub.dev discoverability
* Added preview GIFs to README

---

## 0.2.0

### Added
* **Key press preview popup** - Native-style key preview bubble appears above typed key
* Premium example app with 9 fully designed demo screens
* Preview GIFs in README

### Improved
* Redesigned example app UI for all screens with gradient themes and animations
* Simplified and restructured documentation for clarity
* Reorganized project assets

---

## 0.1.1

### Fixed
* **Physical keyboard handling** - Virtual keyboard now correctly hides when `allowPhysicalKeyboard: true`
* **Layout persistence on close** - Keyboard maintains its layout during close animation instead of resetting to default
* **Selection handling** - `insertText()` and `deleteBackward()` now properly handle text selections

### Added
* `selectAll()` method to `VirtualKeypadController` for selecting all text
* Stricter lint rules for better code quality
* Comprehensive documentation in `doc/` folder
  - API Reference
  - Custom Layouts Guide
  - Adding Languages Guide
  - Theming Guide

### Improved
* Enhanced `VirtualKeypadController` selection awareness
* Better scope state management for physical keyboard mode
* Professional README with cleaner structure

---

## 0.1.0

### Initial Release
* **VirtualKeypadScope** - Manages keyboard-to-textfield connections
* **VirtualKeypadTextField** - Text field with virtual keyboard integration
* **VirtualKeypad** - Customizable on-screen keyboard widget
* **VirtualKeypadController** - Controller with text manipulation methods
* **VirtualKeypadTheme** - Light, dark, and custom themes
* Multiple keyboard types: text, email, URL, number, phone
* Multi-language support: English (QWERTY) and Bengali (বাংলা)
* Input-type-aware layouts that adapt automatically
* Cross-platform support (mobile, web, desktop)
