import 'package:flutter/material.dart';
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
    ('en', 'English', '🇺🇸', 'QWERTY', [const Color(0xFF89f7fe), const Color(0xFF66a6ff)]),
    ('bn', 'বাংলা', '🇧🇩', 'Bengali', [const Color(0xFF43e97b), const Color(0xFF38f9d7)]),
    ('fr', 'Français', '🇫🇷', 'AZERTY', [const Color(0xFFf093fb), const Color(0xFFf5576c)]),
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
      case 'fr':
        hintText = 'Écrivez en français...';
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: _languages.map((lang) {
                        final (code, label, flag, subtitle, colors) = lang;
                        final isFirst = code == _languages.first.$1;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: isFirst ? 0 : 8),
                            child: _LanguageCard(
                              label: label,
                              flag: flag,
                              subtitle: subtitle,
                              isSelected: _currentLanguage == code,
                              gradientColors: colors,
                              onTap: () => _switchLanguage(code),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Text area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow
                                  .withValues(alpha: 0.05),
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
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                          ),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.2),
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.15),
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
                        color: colorScheme.surfaceContainerHigh
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.text_snippet_outlined,
                            size: 14,
                            color: colorScheme.onSurface
                                .withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_controller.text.length} characters',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.45),
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
                                      color: colorScheme.error
                                          .withValues(alpha: 0.6),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Clear',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.error
                                            .withValues(alpha: 0.6),
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
            VirtualKeypad(),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.label,
    required this.flag,
    required this.subtitle,
    required this.isSelected,
    required this.gradientColors,
    required this.onTap,
  });

  final String label;
  final String flag;
  final String subtitle;
  final bool isSelected;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    gradientColors.first.withValues(alpha: 0.15),
                    gradientColors.last.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected
              ? null
              : colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
          border: Border.all(
            color: isSelected
                ? gradientColors.first.withValues(alpha: 0.5)
                : colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
                color: isSelected
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? gradientColors.first.withValues(alpha: 0.8)
                    : colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
