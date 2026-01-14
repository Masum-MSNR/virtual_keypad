import '../../enums.dart';
import '../../models.dart';
import '../keyboard_language.dart';

// =============================================================================
// BENGALI (বাংলা) KEYBOARD LAYOUTS
// =============================================================================
// Uses a phonetic-style layout optimized for touch typing.
// Primary layout contains common consonants and vowels.
// Secondary layout contains conjuncts, rare characters, and numbers.

/// Bengali text layout - primary (common letters).
/// Layout designed for natural Bengali typing with most used characters.
final KeyboardLayout _textLayoutPrimary = [
  // Row 1: Vowels and common consonants
  [
    VirtualKey.character(text: 'অ'),
    VirtualKey.character(text: 'আ', capsText: 'া'),
    VirtualKey.character(text: 'ই', capsText: 'ি'),
    VirtualKey.character(text: 'ঈ', capsText: 'ী'),
    VirtualKey.character(text: 'উ', capsText: 'ু'),
    VirtualKey.character(text: 'ঊ', capsText: 'ূ'),
    VirtualKey.character(text: 'এ', capsText: 'ে'),
    VirtualKey.character(text: 'ঐ', capsText: 'ৈ'),
    VirtualKey.character(text: 'ও', capsText: 'ো'),
    VirtualKey.character(text: 'ঔ', capsText: 'ৌ'),
  ],
  // Row 2: Common consonants
  [
    VirtualKey.character(text: 'ক'),
    VirtualKey.character(text: 'খ'),
    VirtualKey.character(text: 'গ'),
    VirtualKey.character(text: 'ঘ'),
    VirtualKey.character(text: 'চ'),
    VirtualKey.character(text: 'ছ'),
    VirtualKey.character(text: 'জ'),
    VirtualKey.character(text: 'ঝ'),
    VirtualKey.character(text: 'ট'),
    VirtualKey.character(text: 'ঠ'),
  ],
  // Row 3: More consonants
  [
    VirtualKey.character(text: 'ড'),
    VirtualKey.character(text: 'ঢ'),
    VirtualKey.character(text: 'ণ'),
    VirtualKey.character(text: 'ত'),
    VirtualKey.character(text: 'থ'),
    VirtualKey.character(text: 'দ'),
    VirtualKey.character(text: 'ধ'),
    VirtualKey.character(text: 'ন'),
    VirtualKey.character(text: 'প'),
    VirtualKey.character(text: 'ফ'),
  ],
  // Row 4: More consonants with shift and backspace
  [
    VirtualKey.action(action: KeyAction.shift, flex: 1),
    VirtualKey.character(text: 'ব'),
    VirtualKey.character(text: 'ভ'),
    VirtualKey.character(text: 'ম'),
    VirtualKey.character(text: 'য'),
    VirtualKey.character(text: 'র'),
    VirtualKey.character(text: 'ল'),
    VirtualKey.character(text: 'শ'),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  // Row 5: Special keys and modifiers
  [
    VirtualKey.action(
        action: KeyAction.symbols, label: '১২৩', altLabel: 'কখ', flex: 1),
    VirtualKey.character(text: 'স'),
    VirtualKey.character(text: 'হ'),
    VirtualKey.character(text: '্'), // Hasanta (virama)
    VirtualKey.action(action: KeyAction.space, flex: 3),
    VirtualKey.character(text: 'ং'), // Anusvara
    VirtualKey.character(text: '।'), // Bengali danda
    VirtualKey.action(action: KeyAction.enter, flex: 1),
  ],
];

/// Bengali text layout - secondary (more characters, numbers, conjuncts).
final KeyboardLayout _textLayoutSecondary = [
  // Row 1: Bengali numerals
  [
    VirtualKey.character(text: '১', capsText: '1'),
    VirtualKey.character(text: '২', capsText: '2'),
    VirtualKey.character(text: '৩', capsText: '3'),
    VirtualKey.character(text: '৪', capsText: '4'),
    VirtualKey.character(text: '৫', capsText: '5'),
    VirtualKey.character(text: '৬', capsText: '6'),
    VirtualKey.character(text: '৭', capsText: '7'),
    VirtualKey.character(text: '৮', capsText: '8'),
    VirtualKey.character(text: '৯', capsText: '9'),
    VirtualKey.character(text: '০', capsText: '0'),
  ],
  // Row 2: Additional consonants and special characters
  [
    VirtualKey.character(text: 'ঙ'),
    VirtualKey.character(text: 'ঞ'),
    VirtualKey.character(text: 'ড়'),
    VirtualKey.character(text: 'ঢ়'),
    VirtualKey.character(text: 'য়'),
    VirtualKey.character(text: 'ৎ'), // Khanda ta
    VirtualKey.character(text: 'ঃ'), // Visarga
    VirtualKey.character(text: 'ঁ'), // Chandrabindu
    VirtualKey.character(text: 'ৃ'), // Vowel sign vocalic r
    VirtualKey.character(text: 'ঋ'), // Vowel vocalic r
  ],
  // Row 3: Punctuation and symbols
  [
    VirtualKey.action(
        action: KeyAction.symbolsAlt, label: '#+=', altLabel: '১২৩', flex: 1),
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '/'),
    VirtualKey.character(text: ':'),
    VirtualKey.character(text: '?'),
    VirtualKey.character(text: '!'),
    VirtualKey.character(text: '"'),
    VirtualKey.character(text: "'"),
    VirtualKey.action(action: KeyAction.backSpace, flex: 1),
  ],
  // Row 4: Space and navigation
  [
    VirtualKey.action(
        action: KeyAction.symbols, label: '১২৩', altLabel: 'কখ', flex: 1),
    VirtualKey.character(text: ','),
    VirtualKey.character(text: '্'), // Hasanta
    VirtualKey.action(action: KeyAction.space, flex: 3),
    VirtualKey.character(text: '।'), // Danda
    VirtualKey.character(text: '॥'), // Double danda
    VirtualKey.action(action: KeyAction.enter, flex: 1),
  ],
];

/// Bengali text layout - tertiary (symbols and punctuation).
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
    VirtualKey.character(text: '৳'), // Bengali Rupee
    VirtualKey.character(text: '₹'), // Indian Rupee
    VirtualKey.character(text: '\$'),
    VirtualKey.character(text: '•'),
  ],
  [
    VirtualKey.action(
        action: KeyAction.symbolsAlt, label: '#+=', altLabel: '১২৩', flex: 1),
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
    VirtualKey.action(
        action: KeyAction.symbols, label: '১২৩', altLabel: 'কখ', flex: 2),
    VirtualKey.character(text: ','),
    VirtualKey.action(action: KeyAction.space, flex: 4),
    VirtualKey.character(text: '।'),
    VirtualKey.action(action: KeyAction.enter, flex: 2),
  ],
];

// =============================================================================
// EMAIL LAYOUTS (Bengali with @ and common email characters)
// =============================================================================

/// Bengali email keyboard - primary layout.
final KeyboardLayout _emailLayoutPrimary = [
  [
    VirtualKey.character(text: 'অ'),
    VirtualKey.character(text: 'আ', capsText: 'া'),
    VirtualKey.character(text: 'ই', capsText: 'ি'),
    VirtualKey.character(text: 'ঈ', capsText: 'ী'),
    VirtualKey.character(text: 'উ', capsText: 'ু'),
    VirtualKey.character(text: 'ঊ', capsText: 'ূ'),
    VirtualKey.character(text: 'এ', capsText: 'ে'),
    VirtualKey.character(text: 'ঐ', capsText: 'ৈ'),
    VirtualKey.character(text: 'ও', capsText: 'ো'),
    VirtualKey.character(text: 'ঔ', capsText: 'ৌ'),
  ],
  [
    VirtualKey.character(text: 'ক'),
    VirtualKey.character(text: 'খ'),
    VirtualKey.character(text: 'গ'),
    VirtualKey.character(text: 'ঘ'),
    VirtualKey.character(text: 'চ'),
    VirtualKey.character(text: 'ছ'),
    VirtualKey.character(text: 'জ'),
    VirtualKey.character(text: 'ঝ'),
    VirtualKey.character(text: 'ট'),
    VirtualKey.character(text: 'ঠ'),
  ],
  [
    VirtualKey.action(action: KeyAction.shift, flex: 1),
    VirtualKey.character(text: 'ড'),
    VirtualKey.character(text: 'ত'),
    VirtualKey.character(text: 'দ'),
    VirtualKey.character(text: 'ন'),
    VirtualKey.character(text: 'প'),
    VirtualKey.character(text: 'ব'),
    VirtualKey.character(text: 'ম'),
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

/// Bengali email keyboard - secondary layout (numbers & symbols).
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

// =============================================================================
// NUMBER LAYOUTS (Bengali numerals)
// =============================================================================

/// Bengali number pad layout (Bengali numerals with option for Arabic).
final KeyboardLayout _numberLayout = [
  [
    VirtualKey.character(text: '১', capsText: '1'),
    VirtualKey.character(text: '২', capsText: '2'),
    VirtualKey.character(text: '৩', capsText: '3'),
  ],
  [
    VirtualKey.character(text: '৪', capsText: '4'),
    VirtualKey.character(text: '৫', capsText: '5'),
    VirtualKey.character(text: '৬', capsText: '6'),
  ],
  [
    VirtualKey.character(text: '৭', capsText: '7'),
    VirtualKey.character(text: '৮', capsText: '8'),
    VirtualKey.character(text: '৯', capsText: '9'),
  ],
  [
    VirtualKey.character(text: '.'),
    VirtualKey.character(text: '০', capsText: '0'),
    VirtualKey.action(action: KeyAction.backSpace),
  ],
];

/// Bengali signed number pad layout.
final KeyboardLayout _signedNumberLayout = [
  [
    VirtualKey.character(text: '১', capsText: '1'),
    VirtualKey.character(text: '২', capsText: '2'),
    VirtualKey.character(text: '৩', capsText: '3'),
  ],
  [
    VirtualKey.character(text: '৪', capsText: '4'),
    VirtualKey.character(text: '৫', capsText: '5'),
    VirtualKey.character(text: '৬', capsText: '6'),
  ],
  [
    VirtualKey.character(text: '৭', capsText: '7'),
    VirtualKey.character(text: '৮', capsText: '8'),
    VirtualKey.character(text: '৯', capsText: '9'),
  ],
  [
    VirtualKey.character(text: '-'),
    VirtualKey.character(text: '০', capsText: '0'),
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

/// Bengali phone dialer layout.
final KeyboardLayout _phoneLayout = [
  [
    VirtualKey.character(text: '১', capsText: '1'),
    VirtualKey.character(text: '২', capsText: '2'),
    VirtualKey.character(text: '৩', capsText: '3'),
  ],
  [
    VirtualKey.character(text: '৪', capsText: '4'),
    VirtualKey.character(text: '৫', capsText: '5'),
    VirtualKey.character(text: '৬', capsText: '6'),
  ],
  [
    VirtualKey.character(text: '৭', capsText: '7'),
    VirtualKey.character(text: '৮', capsText: '8'),
    VirtualKey.character(text: '৯', capsText: '9'),
  ],
  [
    VirtualKey.character(text: '*'),
    VirtualKey.character(text: '০', capsText: '0'),
    VirtualKey.character(text: '#'),
  ],
  [
    VirtualKey.character(text: '+'),
    VirtualKey.action(action: KeyAction.backSpace),
    VirtualKey.action(action: KeyAction.call),
  ],
];

// =============================================================================
// BENGALI LANGUAGE DEFINITION
// =============================================================================

/// Bengali (বাংলা) keyboard language.
///
/// This provides layouts for:
/// - Text: Bengali script with vowels and consonants
/// - Email: Bengali with @ on primary row
/// - Number: Bengali numerals (১২৩...) with shift for Arabic (123...)
/// - Phone: Bengali numeral dialer
final KeyboardLanguage bengaliLanguage = KeyboardLanguage(
  code: 'bn',
  name: 'Bengali',
  nativeName: 'বাংলা',
  textLayouts: KeyboardLayoutSet(
    primary: _textLayoutPrimary,
    secondary: _textLayoutSecondary,
    tertiary: _textLayoutTertiary,
  ),
  emailLayouts: KeyboardLayoutSet(
    primary: _emailLayoutPrimary,
    secondary: _emailLayoutSecondary,
  ),
  numberLayouts: KeyboardLayoutSet.single(_numberLayout),
  numberSignedLayouts: KeyboardLayoutSet.single(_signedNumberLayout),
  numberDecimalLayouts: KeyboardLayoutSet.single(_numberLayout),
  phoneLayouts: KeyboardLayoutSet.single(_phoneLayout),
);
