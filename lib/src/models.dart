import 'enums.dart';

/// Represents a key on the virtual keyboard.
class VirtualKey {
  /// Creates a character key.
  VirtualKey.character({
    required this.text,
    String? capsText,
    this.flex = 1,
  })  : capsText = capsText ?? text?.toUpperCase(),
        keyType = KeyType.character,
        action = null;

  /// Creates an action key.
  VirtualKey.action({
    required KeyAction this.action,
    this.text,
    this.flex = 1,
  })  : capsText = null,
        keyType = KeyType.action;

  /// The text displayed on the key and inserted when pressed.
  final String? text;

  /// The text displayed when caps lock or shift is active.
  final String? capsText;

  /// The type of key (character or action).
  final KeyType keyType;

  /// The action this key performs (for action keys).
  final KeyAction? action;

  /// The flex value for sizing in a Row (default: 1).
  final int flex;

  /// Whether this is a character key.
  bool get isCharacter => keyType == KeyType.character;

  /// Whether this is an action key.
  bool get isAction => keyType == KeyType.action;

  /// Gets the display text based on current shift/caps state.
  String getDisplayText({bool shift = false, bool capsLock = false}) {
    if (keyType == KeyType.action) {
      return '';
    }
    if (shift || capsLock) {
      return capsText ?? text?.toUpperCase() ?? '';
    }
    return text ?? '';
  }

  /// Gets the text to insert based on current shift/caps state.
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
    if (shift || capsLock) {
      return capsText ?? text?.toUpperCase() ?? '';
    }
    return text ?? '';
  }

  @override
  String toString() =>
      'VirtualKey(type: $keyType, text: $text, action: $action)';
}

/// A row of keys in a keyboard layout.
typedef KeyRow = List<VirtualKey>;

/// A complete keyboard layout (list of rows).
typedef KeyboardLayout = List<KeyRow>;
