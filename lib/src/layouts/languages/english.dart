import '../../enums.dart';
import '../../models.dart';
import '../keyboard_language.dart';

// =============================================================================
// ENGLISH QWERTY LAYOUTS
// =============================================================================

/// Standard QWERTY text layout - primary (letters).
final KeyboardLayout _textLayoutPrimary = [
  [
    VirtualKey.character(text: 'q'),
    VirtualKey.character(text: 'w'),
    VirtualKey.character(text: 'e'),
    VirtualKey.character(text: 'r'),
    VirtualKey.character(text: 't'),
    VirtualKey.character(text: 'y'),
    VirtualKey.character(text: 'u'),
    VirtualKey.character(text: 'i'),
    VirtualKey.character(text: 'o'),
    VirtualKey.character(text: 'p'),
  ],
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 's'),
    VirtualKey.character(text: 'd'),
    VirtualKey.character(text: 'f'),
    VirtualKey.character(text: 'g'),
    VirtualKey.character(text: 'h'),
    VirtualKey.character(text: 'j'),
    VirtualKey.character(text: 'k'),
    VirtualKey.character(text: 'l'),
  ],
  [
    VirtualKey.action(action: KeyAction.shift, flex: 1),
    VirtualKey.character(text: 'z'),
    VirtualKey.character(text: 'x'),
    VirtualKey.character(text: 'c'),
    VirtualKey.character(text: 'v'),
    VirtualKey.character(text: 'b'),
    VirtualKey.character(text: 'n'),
    VirtualKey.character(text: 'm'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];

/// Text layout - secondary (numbers & common symbols).
final KeyboardLayout _textLayoutSecondary = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
    VirtualKey.character(text: '0'),
  ],
  [
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: ':'),
    VirtualKey.character(text: ';'),
    VirtualKey.character(text: '('),
    VirtualKey.character(text: ')'),
    VirtualKey.character(text: '\$'),
    VirtualKey.character(text: '&'),
    VirtualKey.character(text: '@'),
    VirtualKey.character(text: '"'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 2),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: ','),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '#'),
    VirtualKey.character(text: '%'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];

/// Text layout - tertiary (more symbols).
final KeyboardLayout _textLayoutTertiary = [
  [
    VirtualKey.character(text: '['),
    VirtualKey.character(text: ']'),
    VirtualKey.character(text: '{'),
    VirtualKey.character(text: '}'),
    VirtualKey.character(text: '#'),
    VirtualKey.character(text: '%'),
    VirtualKey.character(text: '^'),
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: '+'),
    VirtualKey.character(text: '='),
  ],
  [
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '\\'),
    VirtualKey.character(text: '|'),
    VirtualKey.character(text: '~'),
    VirtualKey.character(text: '<'),
    VirtualKey.character(text: '>'),
    VirtualKey.character(text: '€'),
    VirtualKey.character(text: '£'),
    VirtualKey.character(text: '¥'),
    VirtualKey.character(text: '•'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 1),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: ','),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '`'),
    VirtualKey.character(text: '°'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];

// =============================================================================
// EMAIL LAYOUTS
// =============================================================================

/// Email keyboard - primary layout with @ readily accessible.
final KeyboardLayout _emailLayoutPrimary = [
  [
    VirtualKey.character(text: 'q'),
    VirtualKey.character(text: 'w'),
    VirtualKey.character(text: 'e'),
    VirtualKey.character(text: 'r'),
    VirtualKey.character(text: 't'),
    VirtualKey.character(text: 'y'),
    VirtualKey.character(text: 'u'),
    VirtualKey.character(text: 'i'),
    VirtualKey.character(text: 'o'),
    VirtualKey.character(text: 'p'),
  ],
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 's'),
    VirtualKey.character(text: 'd'),
    VirtualKey.character(text: 'f'),
    VirtualKey.character(text: 'g'),
    VirtualKey.character(text: 'h'),
    VirtualKey.character(text: 'j'),
    VirtualKey.character(text: 'k'),
    VirtualKey.character(text: 'l'),
  ],
  [
    VirtualKey.action(action: KeyAction.shift, flex: 1),
    VirtualKey.character(text: 'z'),
    VirtualKey.character(text: 'x'),
    VirtualKey.character(text: 'c'),
    VirtualKey.character(text: 'v'),
    VirtualKey.character(text: 'b'),
    VirtualKey.character(text: 'n'),
    VirtualKey.character(text: 'm'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 1),
    VirtualKey.character(text: '@'),
    VirtualKey.action(action: KeyAction.space, flex: 3),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '-'),
    VirtualKey.action(action: KeyAction.done, flex: 1),
  ],
];

/// Email keyboard - secondary layout (numbers & symbols).
final KeyboardLayout _emailLayoutSecondary = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
    VirtualKey.character(text: '0'),
  ],
  [
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '+'),
    VirtualKey.character(text: '('),
    VirtualKey.character(text: ')'),
    VirtualKey.character(text: '&'),
    VirtualKey.character(text: '@'),
    VirtualKey.character(text: '#'),
    VirtualKey.character(text: '%'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 1),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '"'),
    VirtualKey.character(text: ':'),
    VirtualKey.character(text: ';'),
    VirtualKey.character(text: '/'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 1),
    VirtualKey.character(text: '@'),
    VirtualKey.action(action: KeyAction.space, flex: 3),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '-'),
    VirtualKey.action(action: KeyAction.done, flex: 1),
  ],
];

/// Email keyboard - tertiary layout (more symbols).
final KeyboardLayout _emailLayoutTertiary = [
  [
    VirtualKey.character(text: '['),
    VirtualKey.character(text: ']'),
    VirtualKey.character(text: '{'),
    VirtualKey.character(text: '}'),
    VirtualKey.character(text: '~'),
    VirtualKey.character(text: '^'),
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: '='),
    VirtualKey.character(text: '|'),
    VirtualKey.character(text: '\\'),
  ],
  [
    VirtualKey.character(text: '<'),
    VirtualKey.character(text: '>'),
    VirtualKey.character(text: '€'),
    VirtualKey.character(text: '£'),
    VirtualKey.character(text: '¥'),
    VirtualKey.character(text: '\$'),
    VirtualKey.character(text: '•'),
    VirtualKey.character(text: '`'),
    VirtualKey.character(text: '°'),
    VirtualKey.character(text: '©'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 1),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '"'),
    VirtualKey.character(text: ':'),
    VirtualKey.character(text: ';'),
    VirtualKey.character(text: '/'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 1),
    VirtualKey.character(text: '@'),
    VirtualKey.action(action: KeyAction.space, flex: 3),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '-'),
    VirtualKey.action(action: KeyAction.done, flex: 1),
  ],
];

// =============================================================================
// URL LAYOUTS
// =============================================================================

/// URL keyboard - primary layout with common URL characters accessible.
final KeyboardLayout _urlLayoutPrimary = [
  [
    VirtualKey.character(text: 'q'),
    VirtualKey.character(text: 'w'),
    VirtualKey.character(text: 'e'),
    VirtualKey.character(text: 'r'),
    VirtualKey.character(text: 't'),
    VirtualKey.character(text: 'y'),
    VirtualKey.character(text: 'u'),
    VirtualKey.character(text: 'i'),
    VirtualKey.character(text: 'o'),
    VirtualKey.character(text: 'p'),
  ],
  [
    VirtualKey.character(text: 'a'),
    VirtualKey.character(text: 's'),
    VirtualKey.character(text: 'd'),
    VirtualKey.character(text: 'f'),
    VirtualKey.character(text: 'g'),
    VirtualKey.character(text: 'h'),
    VirtualKey.character(text: 'j'),
    VirtualKey.character(text: 'k'),
    VirtualKey.character(text: 'l'),
  ],
  [
    VirtualKey.action(action: KeyAction.shift, flex: 1),
    VirtualKey.character(text: 'z'),
    VirtualKey.character(text: 'x'),
    VirtualKey.character(text: 'c'),
    VirtualKey.character(text: 'v'),
    VirtualKey.character(text: 'b'),
    VirtualKey.character(text: 'n'),
    VirtualKey.character(text: 'm'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 1),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.space, flex: 2),
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: ':'),
    VirtualKey.action(action: KeyAction.go, flex: 1),
  ],
];

/// URL keyboard - secondary layout (numbers & symbols).
final KeyboardLayout _urlLayoutSecondary = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
    VirtualKey.character(text: '0'),
  ],
  [
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '_'),
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: ':'),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '='),
    VirtualKey.character(text: '&'),
    VirtualKey.character(text: '#'),
    VirtualKey.character(text: '%'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 1),
    VirtualKey.character(text: '@'),
    VirtualKey.character(text: '+'),
    VirtualKey.character(text: '~'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '"'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 1),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.space, flex: 2),
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: ':'),
    VirtualKey.action(action: KeyAction.go, flex: 1),
  ],
];

/// URL keyboard - tertiary layout (more symbols).
final KeyboardLayout _urlLayoutTertiary = [
  [
    VirtualKey.character(text: '['),
    VirtualKey.character(text: ']'),
    VirtualKey.character(text: '{'),
    VirtualKey.character(text: '}'),
    VirtualKey.character(text: '<'),
    VirtualKey.character(text: '>'),
    VirtualKey.character(text: '^'),
    VirtualKey.character(text: '|'),
    VirtualKey.character(text: '\\'),
    VirtualKey.character(text: '`'),
  ],
  [
    VirtualKey.character(text: '€'),
    VirtualKey.character(text: '£'),
    VirtualKey.character(text: '¥'),
    VirtualKey.character(text: '\$'),
    VirtualKey.character(text: '©'),
    VirtualKey.character(text: '®'),
    VirtualKey.character(text: '™'),
    VirtualKey.character(text: '°'),
    VirtualKey.character(text: '•'),
    VirtualKey.character(text: '…'),
  ],
  [
    VirtualKey.action(action: KeyAction.symbolsAlt, flex: 1),
    VirtualKey.character(text: '@'),
    VirtualKey.character(text: '+'),
    VirtualKey.character(text: '~'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: "'"),
    VirtualKey.character(text: '"'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  [
    VirtualKey.action(action: KeyAction.symbols, flex: 1),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: '.'),
    VirtualKey.action(action: KeyAction.space, flex: 2),
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: ':'),
    VirtualKey.action(action: KeyAction.go, flex: 1),
  ],
];

// =============================================================================
// NUMBER LAYOUTS
// =============================================================================

/// Standard number pad layout (0-9 with decimal).
final KeyboardLayout _numberLayout = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
  ],
  [
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
  ],
  [
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '0'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
];

/// Signed number pad layout (includes - for negative numbers).
final KeyboardLayout _signedNumberLayout = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
  ],
  [
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
  ],
  [
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '0'),
    VirtualKey.character(text: '.'),
  ],
  [
    VirtualKey.action(action: KeyAction.backSpace, flex: 2),
    VirtualKey.action(action: KeyAction.done),
  ],
];

// =============================================================================
// PHONE LAYOUTS
// =============================================================================

/// Phone dialer layout with standard phone pad characters.
final KeyboardLayout _phoneLayout = [
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
  ],
  [
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
  ],
  [
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: '0'),
    VirtualKey.character(text: '#'),
  ],
  [
    VirtualKey.character(text: '+'),
    VirtualKey.action(action: KeyAction.backSpace),
    VirtualKey.action(action: KeyAction.call),
  ],
];

// =============================================================================
// ENGLISH LANGUAGE DEFINITION
// =============================================================================

/// English (QWERTY) keyboard language.
///
/// This is the default language and provides layouts for:
/// - Text: Standard QWERTY with symbols
/// - Email: QWERTY with @ on primary row
/// - URL: QWERTY with /, :, . on primary row
/// - Number: Standard number pad
/// - Phone: Phone dialer
final KeyboardLanguage englishLanguage = KeyboardLanguage(
  code: 'en',
  name: 'English',
  nativeName: 'English',
  textLayouts: KeyboardLayoutSet(
    primary: _textLayoutPrimary,
    secondary: _textLayoutSecondary,
    tertiary: _textLayoutTertiary,
  ),
  emailLayouts: KeyboardLayoutSet(
    primary: _emailLayoutPrimary,
    secondary: _emailLayoutSecondary,
    tertiary: _emailLayoutTertiary,
  ),
  urlLayouts: KeyboardLayoutSet(
    primary: _urlLayoutPrimary,
    secondary: _urlLayoutSecondary,
    tertiary: _urlLayoutTertiary,
  ),
  numberLayouts: KeyboardLayoutSet.single(_numberLayout),
  phoneLayouts: KeyboardLayoutSet.single(_phoneLayout),
);

/// Signed number layout set for special use cases.
final KeyboardLayoutSet englishSignedNumberLayouts = KeyboardLayoutSet.single(
  _signedNumberLayout,
);
