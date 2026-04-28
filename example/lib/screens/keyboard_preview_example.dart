import 'dart:math';

import 'package:flutter/material.dart';
import 'package:virtual_keypad_example/example_page_layout.dart';
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

  final _inputTypes = [
    (KeyboardInputType.text, 'Text', Icons.keyboard),
    (KeyboardInputType.email, 'Email', Icons.alternate_email),
    (KeyboardInputType.url, 'URL', Icons.link),
    (KeyboardInputType.number, 'Number', Icons.dialpad),
    (KeyboardInputType.numberSigned, 'Number Signed', Icons.exposure_neg_1),
    (KeyboardInputType.numberDecimal, 'Number Decimal', Icons.pin),
    (KeyboardInputType.phone, 'Phone', Icons.phone),
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
    final provider = KeyboardLayoutProvider.instance;

    // Build flat list of all layout sections
    final sections = <_LayoutSection>[];
    for (final entry in _inputTypes) {
      final layoutSet = provider.getLayouts(entry.$1);
      sections.add(
        _LayoutSection(
          type: entry.$2,
          stage: 'Primary',
          icon: entry.$3,
          layout: layoutSet.primary,
        ),
      );
      if (layoutSet.secondary != null) {
        sections.add(
          _LayoutSection(
            type: entry.$2,
            stage: 'Secondary',
            icon: entry.$3,
            layout: layoutSet.secondary!,
          ),
        );
      }
      if (layoutSet.tertiary != null) {
        sections.add(
          _LayoutSection(
            type: entry.$2,
            stage: 'Tertiary',
            icon: entry.$3,
            layout: layoutSet.tertiary!,
          ),
        );
      }
    }

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
          ExampleConstrainedContent(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.translate, size: 18, color: colorScheme.primary),
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
            ),
          ),

          // All layouts list
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth < 600
                    ? 16.0
                    : 24.0;

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    24,
                  ),
                  itemCount: sections.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: _EmojiPreviewCard(
                            currentLanguage: _currentLanguage,
                          ),
                        ),
                      );
                    }

                    final section = sections[index - 1];
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: _LayoutPreview(section: section),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LayoutSection {
  const _LayoutSection({
    required this.type,
    required this.stage,
    required this.icon,
    required this.layout,
  });

  final String type;
  final String stage;
  final IconData icon;
  final KeyboardLayout layout;
}

class _LayoutPreview extends StatelessWidget {
  const _LayoutPreview({required this.section});

  final _LayoutSection section;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colorScheme = Theme.of(context).colorScheme;
        final layout = section.layout;
        final theme = VirtualKeypadTheme.light;
        final availableWidth = constraints.maxWidth;
        final totalFlex = layout
            .map((row) => row.fold(0.0, (sum, key) => sum + key.flex))
            .reduce(max);
        final maxCols = layout.map((row) => row.length).reduce(max);

        final usedWidth = (maxCols + 1) * theme.horizontalGap;
        final baseKeyWidth = (availableWidth - usedWidth) / totalFlex;
        const keyHeight = 42.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(section.icon, size: 16, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  section.type,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    section.stage,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Rendered layout
            Container(
              width: availableWidth,
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                vertical: theme.verticalGap / 2,
                horizontal: theme.horizontalGap / 2,
              ),
              child: Column(
                children: layout.map((row) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: theme.verticalGap / 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row.map((key) {
                        final isAction = key.isAction;
                        final w =
                            baseKeyWidth * key.flex +
                            (key.flex - 1) * theme.horizontalGap;

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: theme.horizontalGap / 2,
                          ),
                          height: keyHeight,
                          width: w,
                          decoration: isAction
                              ? theme.actionKeyDecoration
                              : theme.keyDecoration,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: _buildKeyLabel(key, theme),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKeyLabel(VirtualKey key, VirtualKeypadTheme theme) {
    final style = TextStyle(
      fontSize: theme.keyTextSize,
      color: theme.keyTextColor,
    );
    final smallStyle = style.copyWith(fontSize: theme.keyTextSize * 0.7);
    final iconSize = theme.keyTextSize;

    if (key.isCharacter) {
      return Text(key.text ?? '', style: style);
    }

    switch (key.action) {
      case KeyAction.backSpace:
        return Icon(
          Icons.backspace_outlined,
          size: iconSize,
          color: theme.keyTextColor,
        );
      case KeyAction.enter:
        return Icon(Icons.check, size: iconSize, color: theme.keyTextColor);
      case KeyAction.shift:
        return Icon(
          Icons.arrow_upward_outlined,
          size: iconSize,
          color: theme.keyTextColor,
        );
      case KeyAction.space:
        return Text(key.label ?? 'space', style: smallStyle);
      case KeyAction.symbols:
        return Text(key.label ?? '123', style: smallStyle);
      case KeyAction.symbolsAlt:
        return Text(key.label ?? '#+=', style: smallStyle);
      case KeyAction.emoji:
        return Icon(
          Icons.emoji_emotions_outlined,
          size: iconSize,
          color: theme.keyTextColor,
        );
      case KeyAction.done:
        return Icon(Icons.check, size: iconSize, color: theme.keyTextColor);
      case KeyAction.go:
        return Icon(
          Icons.arrow_forward,
          size: iconSize,
          color: theme.keyTextColor,
        );
      case KeyAction.search:
        return Icon(Icons.search, size: iconSize, color: theme.keyTextColor);
      case KeyAction.send:
        return Icon(Icons.send, size: iconSize, color: theme.keyTextColor);
      case KeyAction.call:
        return Icon(Icons.call, size: iconSize, color: theme.keyTextColor);
      case KeyAction.next:
        return Icon(
          Icons.keyboard_tab,
          size: iconSize,
          color: theme.keyTextColor,
        );
      case KeyAction.previous:
        return Transform.flip(
          flipX: true,
          child: Icon(
            Icons.keyboard_tab,
            size: iconSize,
            color: theme.keyTextColor,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _EmojiPreviewCard extends StatelessWidget {
  const _EmojiPreviewCard({
    required this.currentLanguage,
  });

  final String currentLanguage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const theme = VirtualKeypadTheme.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
            children: [
              Icon(
                Icons.emoji_emotions_outlined,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Emoji',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IgnorePointer(
                  child: VirtualKeypad(
                    hideWhenUnfocused: false,
                    enableEmojiKey: true,
                    showEmojiKeyboardInitially: true,
                    availableLanguages: [currentLanguage],
                    initialLanguage: currentLanguage,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
