// Enumerations for the virtual keypad package.

/// The type of action a key performs.
enum KeyAction {
  /// Delete the character before cursor.
  backSpace,

  /// Insert a newline.
  enter,

  /// Toggle shift state.
  shift,

  /// Insert a space character.
  space,

  /// Switch between letter and symbol layouts.
  symbols,

  /// Switch between symbol sub-layouts.
  symbolsAlt,

  /// Switch to a different language layout.
  switchLanguage,
}

/// The type of key on the keyboard.
enum KeyType {
  /// A key that performs an action (shift, backspace, etc.).
  action,

  /// A key that inserts a character.
  character,
}

/// The type of keyboard layout.
enum KeyboardType {
  /// Full QWERTY keyboard with letters, numbers, and symbols.
  text,

  /// Numeric keypad (0-9, decimal, backspace).
  number,

  /// Phone-style numeric pad.
  phone,

  /// Custom user-defined layout.
  custom,
}

/// The current layout stage (for switching between letter/symbol views).
enum LayoutStage {
  /// Primary layout (letters for text, or first symbol page).
  primary,

  /// Secondary layout (symbols page 1).
  secondary,

  /// Tertiary layout (symbols page 2).
  tertiary,
}
