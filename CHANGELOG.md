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
