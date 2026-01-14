import 'enums.dart';

class VirtualKey {
  VirtualKey.character({
    required this.text,
    String? capsText,
    this.flex = 1,
  })  : capsText = capsText ?? text?.toUpperCase(),
        keyType = KeyType.character,
        action = null;

  VirtualKey.action({
    required KeyAction this.action,
    this.text,
    this.flex = 1,
  })  : capsText = null,
        keyType = KeyType.action;

  final String? text;
  final String? capsText;
  final KeyType keyType;
  final KeyAction? action;
  final int flex;

  bool get isCharacter => keyType == KeyType.character;
  bool get isAction => keyType == KeyType.action;

  String getDisplayText({bool shift = false, bool capsLock = false}) {
    if (keyType == KeyType.action) return '';
    if (shift || capsLock) return capsText ?? text?.toUpperCase() ?? '';
    return text ?? '';
  }

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
  String toString() => 'VirtualKey(type: $keyType, text: $text, action: $action)';
}

typedef KeyRow = List<VirtualKey>;
typedef KeyboardLayout = List<KeyRow>;
