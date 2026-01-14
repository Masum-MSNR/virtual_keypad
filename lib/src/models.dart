import 'enums.dart';

/// Represents a single key on the virtual keyboard.
///
/// Use [VirtualKey.character] for keys that insert text, or [VirtualKey.action]
/// for special function keys like backspace, enter, and shift.
class VirtualKey {
  /// Creates a character key that inserts text.
  ///
  /// - [text]: The character to insert (and display in lowercase mode).
  /// - [capsText]: Optional uppercase variant. Defaults to [text.toUpperCase()].
  /// - [flex]: Relative width of the key. Default is 1.
  VirtualKey.character({
    required this.text,
    String? capsText,
    this.flex = 1,
  })  : capsText = capsText ?? text?.toUpperCase(),
        keyType = KeyType.character,
        action = null;

  /// Creates an action key that performs a keyboard function.
  ///
  /// - [action]: The action this key performs.
  /// - [text]: Optional display text for the key.
  /// - [flex]: Relative width of the key. Default is 1.
  VirtualKey.action({
    required KeyAction this.action,
    this.text,
    this.flex = 1,
  })  : capsText = null,
        keyType = KeyType.action;

  /// The primary text character for this key.
  final String? text;

  /// The uppercase/shifted text for this key.
  final String? capsText;

  /// Whether this is a character or action key.
  final KeyType keyType;

  /// The action for action keys, null for character keys.
  final KeyAction? action;

  /// Relative width multiplier for the key. A flex of 2 means twice the width.
  final int flex;

  /// Returns true if this is a character key.
  bool get isCharacter => keyType == KeyType.character;

  /// Returns true if this is an action key.
  bool get isAction => keyType == KeyType.action;

  /// Gets the text to display on the key.
  String getDisplayText({bool shift = false, bool capsLock = false}) {
    if (keyType == KeyType.action) return '';
    if (shift || capsLock) return capsText ?? text?.toUpperCase() ?? '';
    return text ?? '';
  }

  /// Gets the text to insert when this key is pressed.
  String getInsertText({bool shift = false, bool capsLock = false}) {
    if (keyType == KeyType.action) {
      switch (action) {
        case KeyAction.space:
          return ' ';
        case KeyAction.enter:
          return '\n';
        default:
          return '';
      }
    }
    if (shift || capsLock) return capsText ?? text?.toUpperCase() ?? '';
    return text ?? '';
  }

  @override
  String toString() =>
      'VirtualKey(type: $keyType, text: $text, action: $action)';
}

/// A row of keys in a keyboard layout.
typedef KeyRow = List<VirtualKey>;

/// A complete keyboard layout consisting of multiple rows.
typedef KeyboardLayout = List<KeyRow>;
