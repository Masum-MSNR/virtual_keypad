import 'keyboard_language.dart';
import 'languages/bengali.dart';
import 'languages/english.dart';
import 'languages/french.dart';
import 'languages/german.dart';
import 'languages/hindi.dart';
import 'languages/portuguese.dart';
import 'languages/russian.dart';
import 'languages/spanish.dart';
import 'languages/turkish.dart';

/// Manages keyboard languages and provides access to layouts.
///
/// This is the central registry for all available keyboard languages.
/// Use [KeyboardLayoutProvider.instance] to access the singleton.
///
/// Example:
/// ```dart
/// // Get the current language
/// final language = KeyboardLayoutProvider.instance.currentLanguage;
///
/// // Change language
/// KeyboardLayoutProvider.instance.setLanguage('bn');
///
/// // Get layouts for email input in current language
/// final layouts = KeyboardLayoutProvider.instance.getLayouts(KeyboardInputType.email);
/// ```
class KeyboardLayoutProvider {
  KeyboardLayoutProvider._();

  static final KeyboardLayoutProvider instance = KeyboardLayoutProvider._();

  final Map<String, KeyboardLanguage> _languages = {};
  String _currentLanguageCode = 'en';

  /// All registered languages.
  Iterable<KeyboardLanguage> get languages => _languages.values;

  /// Available language codes.
  Iterable<String> get languageCodes => _languages.keys;

  /// The currently selected language.
  KeyboardLanguage get currentLanguage {
    return _languages[_currentLanguageCode] ?? englishLanguage;
  }

  /// The current language code.
  String get currentLanguageCode => _currentLanguageCode;

  /// Registers a new keyboard language.
  ///
  /// If a language with the same code already exists, it will be replaced.
  void registerLanguage(KeyboardLanguage language) {
    _languages[language.code] = language;
  }

  /// Unregisters a keyboard language by code.
  ///
  /// Cannot unregister English ('en') as it's the fallback language.
  bool unregisterLanguage(String code) {
    if (code == 'en') return false;
    return _languages.remove(code) != null;
  }

  /// Sets the current language by code.
  ///
  /// Returns true if the language was found and set, false otherwise.
  bool setLanguage(String code) {
    if (_languages.containsKey(code)) {
      _currentLanguageCode = code;
      return true;
    }
    return false;
  }

  /// Gets a language by code, or null if not found.
  KeyboardLanguage? getLanguage(String code) => _languages[code];

  /// Gets the layout set for the given input type in the current language.
  KeyboardLayoutSet getLayouts(KeyboardInputType inputType) {
    return currentLanguage.getLayoutsForType(inputType);
  }

  /// Gets the layout set for the given input type in a specific language.
  KeyboardLayoutSet getLayoutsForLanguage(
    String languageCode,
    KeyboardInputType inputType,
  ) {
    final language = _languages[languageCode] ?? currentLanguage;
    return language.getLayoutsForType(inputType);
  }

  /// Checks if a language is registered.
  bool hasLanguage(String code) => _languages.containsKey(code);

  /// Resets to default state (English only).
  void reset() {
    _languages.clear();
    _languages['en'] = englishLanguage;
    _currentLanguageCode = 'en';
  }
}

/// Initialize the provider with default languages.
///
/// Call this at app startup to register built-in languages.
/// Registers English ('en'), Bengali ('bn'), French ('fr'), German ('de'),
/// Hindi ('hi'), Portuguese ('pt'), Russian ('ru'), Spanish ('es'),
/// and Turkish ('tr').
void initializeKeyboardLayouts() {
  final provider = KeyboardLayoutProvider.instance;
  provider.registerLanguage(englishLanguage);
  provider.registerLanguage(bengaliLanguage);
  provider.registerLanguage(frenchLanguage);
  provider.registerLanguage(germanLanguage);
  provider.registerLanguage(hindiLanguage);
  provider.registerLanguage(portugueseLanguage);
  provider.registerLanguage(russianLanguage);
  provider.registerLanguage(spanishLanguage);
  provider.registerLanguage(turkishLanguage);
}
