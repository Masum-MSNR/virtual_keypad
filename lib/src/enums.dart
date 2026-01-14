/// Actions that can be performed by special keys on the keyboard.
enum KeyAction {
  /// Delete the character before the cursor.
  backSpace,

  /// Insert a newline character.
  enter,

  /// Toggle shift mode for uppercase letters.
  shift,

  /// Insert a space character.
  space,

  /// Switch between letter and symbol layouts.
  symbols,

  /// Switch between primary and alternate symbol layouts.
  symbolsAlt,

  /// Switch keyboard language (reserved for future use).
  switchLanguage,
}

/// The type of a virtual keyboard key.
enum KeyType {
  /// A key that performs an action (backspace, enter, shift, etc.).
  action,

  /// A key that inserts a character.
  character,
}

/// Predefined keyboard layout types.
enum KeyboardType {
  /// Full QWERTY text keyboard with letters, numbers, and symbols.
  text,

  /// Numeric keypad (0-9 with decimal point).
  number,

  /// Phone dialer layout (0-9 with + symbol).
  phone,

  /// Custom layout provided via [VirtualKeypad.customLayout].
  custom,
}

/// Current layout stage for keyboards with multiple pages.
enum LayoutStage {
  /// Primary layout (letters for text, main symbols for others).
  primary,

  /// Secondary layout (numbers and common symbols).
  secondary,

  /// Tertiary layout (additional symbols and special characters).
  tertiary,
}
