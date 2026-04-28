import 'package:flutter/material.dart';
import 'package:virtual_keypad_example/example_page_layout.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class LanguageSwitchingExample extends StatefulWidget {
  const LanguageSwitchingExample({super.key});

  @override
  State<LanguageSwitchingExample> createState() =>
      _LanguageSwitchingExampleState();
}

class _LanguageSwitchingExampleState extends State<LanguageSwitchingExample> {
  final _controller = VirtualKeypadController();
  String _currentLanguage = 'en';

  final _languages = [
    ('en', 'English', '🇺🇸'),
    ('bn', 'বাংলা', '🇧🇩'),
    ('hi', 'हिन्दी', '🇮🇳'),
    ('ar', 'العربية', '🇸🇦'),
    ('de', 'Deutsch', '🇩🇪'),
    ('es', 'Español', '🇪🇸'),
    ('fr', 'Français', '🇫🇷'),
    ('ko', '한국어', '🇰🇷'),
    ('pt', 'Português', '🇧🇷'),
    ('ru', 'Русский', '🇷🇺'),
    ('th', 'ไทย', '🇹🇭'),
    ('tr', 'Türkçe', '🇹🇷'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    KeyboardLayoutProvider.instance.setLanguage('en');
    super.dispose();
  }

  void _switchLanguage(String code) {
    KeyboardLayoutProvider.instance.setLanguage(code);
    setState(() => _currentLanguage = code);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    String hintText;
    switch (_currentLanguage) {
      case 'bn':
        hintText = 'বাংলায় লিখুন...';
      case 'hi':
        hintText = 'हिन्दी में लिखें...';
      case 'fr':
        hintText = 'Écrivez en français...';
      case 'de':
        hintText = 'Auf Deutsch schreiben...';
      case 'es':
        hintText = 'Escribe en español...';
      case 'pt':
        hintText = 'Escreva em português...';
      case 'ru':
        hintText = 'Пишите по-русски...';
      case 'th':
        hintText = 'พิมพ์ภาษาไทย...';
      case 'tr':
        hintText = 'Türkçe yazın...';
      case 'ar':
        hintText = 'اكتب بالعربية...';
      case 'ko':
        hintText = '한국어로 입력하세요...';
      default:
        hintText = 'Type in English...';
    }

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Language Switching'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF89f7fe), Color(0xFF66a6ff)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ExampleConstrainedContent(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.translate,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _currentLanguage,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              isDense: true,
                            ),
                            items: _languages.map((lang) {
                              return DropdownMenuItem(
                                value: lang.$1,
                                child: Text(
                                  '${lang.$3} ${lang.$2}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (code) {
                              if (code != null) _switchLanguage(code);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Text area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: VirtualKeypadTextField(
                          controller: _controller,
                          maxLines: null,
                          minLines: 3,
                          onChanged: (_) => setState(() {}),
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(fontSize: 15, height: 1.6),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.2,
                              ),
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFF66a6ff),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerLowest,
                            contentPadding: const EdgeInsets.all(18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Bottom stats bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.text_snippet_outlined,
                            size: 14,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.35,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_controller.text.length} characters',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                _controller.clear();
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.clear_rounded,
                                      size: 14,
                                      color: colorScheme.error.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Clear',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.error.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              availableLanguages: _languages.map((lang) => lang.$1).toList(),
              initialLanguage: 'en',
              onLanguageChanged: _switchLanguage,
            ),
          ],
        ),
      ),
    );
  }
}
