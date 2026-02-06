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
    final isEnglish = _currentLanguage == 'en';

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Language Switching'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Language toggle
                    Row(
                      children: [
                        Expanded(
                          child: _LanguageChip(
                            label: 'English',
                            flag: '🇺🇸',
                            subtitle: 'QWERTY',
                            isSelected: isEnglish,
                            onTap: () => _switchLanguage('en'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LanguageChip(
                            label: 'বাংলা',
                            flag: '🇧🇩',
                            subtitle: 'Bengali',
                            isSelected: !isEnglish,
                            onTap: () => _switchLanguage('bn'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Active language indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isEnglish
                            ? const Color(0xFF4facfe).withValues(alpha: 0.08)
                            : const Color(0xFF43e97b).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isEnglish
                              ? const Color(0xFF4facfe).withValues(alpha: 0.2)
                              : const Color(0xFF43e97b).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.translate_rounded,
                            size: 16,
                            color: isEnglish
                                ? const Color(0xFF4facfe)
                                : const Color(0xFF43e97b),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                isEnglish
                                    ? 'Keyboard is in English (QWERTY)'
                                    : 'কিবোর্ড বাংলায় আছে',
                                key: ValueKey(_currentLanguage),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Sample characters preview
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Characters: ',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                isEnglish
                                    ? 'A B C D E F G H I J K L M'
                                    : 'অ আ ই ঈ উ ঊ ক খ গ ঘ চ ছ জ',
                                key: ValueKey('chars_$_currentLanguage'),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 2,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Text area
                    Expanded(
                      child: VirtualKeypadTextField(
                        controller: _controller,
                        maxLines: null,
                        minLines: 3,
                        onChanged: (_) => setState(() {}),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: isEnglish
                              ? 'Type in English...'
                              : 'বাংলায় লিখুন...',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface
                                .withValues(alpha: 0.25),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLowest,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Bottom bar
                    Row(
                      children: [
                        Text(
                          '${_controller.text.length} characters',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurface
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _controller.clear(),
                          icon:
                              const Icon(Icons.clear_rounded, size: 14),
                          label: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
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

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.flag,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String flag;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.4)
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer.withValues(alpha: 0.6)
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
