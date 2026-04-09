import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class KeyboardPreviewExample extends StatefulWidget {
  const KeyboardPreviewExample({super.key});

  @override
  State<KeyboardPreviewExample> createState() => _KeyboardPreviewExampleState();
}

class _KeyboardPreviewExampleState extends State<KeyboardPreviewExample> {
  String _currentLanguage = 'en';

  final _languages = [
    ('en', 'English', '🇺🇸'),
    ('bn', 'বাংলা', '🇧🇩'),
    ('fr', 'Français', '🇫🇷'),
  ];

  final _keyboardTypes = [
    (KeyboardType.text, 'Text', 'Standard QWERTY / script layout', Icons.keyboard),
    (KeyboardType.emailAddress, 'Email', 'With @ and . accessible', Icons.alternate_email),
    (KeyboardType.url, 'URL', 'With / : . accessible', Icons.link),
    (KeyboardType.number, 'Number', 'Numeric keypad (0-9)', Icons.dialpad),
    (KeyboardType.numberSigned, 'Number Signed', 'With minus sign', Icons.exposure_neg_1),
    (KeyboardType.phone, 'Phone', 'Phone dialer layout', Icons.phone),
    (KeyboardType.multiline, 'Multiline', 'Text with return key', Icons.notes),
  ];

  @override
  void dispose() {
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
            ),
          ),
        ),
        title: const Text(
          'Keyboard Preview',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Language switcher
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.translate,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                ..._languages.map((lang) {
                  final isSelected = _currentLanguage == lang.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('${lang.$3} ${lang.$2}'),
                      selected: isSelected,
                      onSelected: (_) => _switchLanguage(lang.$1),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }),
              ],
            ),
          ),

          // Keyboard type list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: _keyboardTypes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final entry = _keyboardTypes[index];
                return _KeyboardTypePreview(
                  type: entry.$1,
                  label: entry.$2,
                  description: entry.$3,
                  icon: entry.$4,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyboardTypePreview extends StatelessWidget {
  const _KeyboardTypePreview({
    required this.type,
    required this.label,
    required this.description,
    required this.icon,
  });

  final KeyboardType type;
  final String label;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Keyboard preview
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: VirtualKeypad(
            type: type,
            height: _heightForType(type),
          ),
        ),
      ],
    );
  }

  double _heightForType(KeyboardType type) {
    switch (type) {
      case KeyboardType.number:
      case KeyboardType.numberDecimal:
        return 240;
      case KeyboardType.numberSigned:
      case KeyboardType.phone:
        return 280;
      default:
        return 260;
    }
  }
}
