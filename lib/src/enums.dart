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

  /// Switch between the active keyboard page and the emoji keyboard.
  emoji,

  /// Switch keyboard language (reserved for future use).
  switchLanguage,

  /// Done action (submit/close keyboard for single-line inputs).
  done,

  /// Go action (for URL inputs - navigate).
  go,

  /// Search action (for search inputs).
  search,

  /// Send action (for chat/messaging inputs).
  send,

  /// Next action (move to next field).
  next,

  /// Previous action (move to previous field).
  previous,

  /// Call action (for phone inputs).
  call,
}

/// The type of a virtual keyboard key.
enum KeyType {
  /// A key that performs an action (backspace, enter, shift, etc.).
  action,

  /// A key that inserts a character.
  character,
}

/// Keyboard input types that determine the layout shown.
///
/// These map closely to Flutter's [TextInputType] values.
enum KeyboardType {
  /// Standard text keyboard with QWERTY layout.
  text,

  /// Multiline text input (shows enter key for newlines).
  multiline,

  /// Numeric keypad / numpad (0-9 with decimal point).
  number,

  /// Signed number input (includes minus sign).
  numberSigned,

  /// Decimal number input.
  numberDecimal,

  /// Phone dialer layout.
  phone,

  /// Date/time input keyboard.
  datetime,

  /// Email address input (@ and . easily accessible).
  emailAddress,

  /// URL input (/, :, . easily accessible).
  url,

  /// Password and PIN entry input (same layout as text, but the action key
  /// may differ).
  visiblePassword,

  /// Person name input (similar to text).
  name,

  /// Street address input.
  streetAddress,

  /// No keyboard (hidden).
  none,

  /// Custom layout provided via [VirtualKeypad.customLayout], such as a PIN
  /// pad or OTP keypad.
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

  /// Emoji layout.
  emoji,
}
