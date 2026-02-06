import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class CustomThemeExample extends StatefulWidget {
  const CustomThemeExample({super.key});

  @override
  State<CustomThemeExample> createState() => _CustomThemeExampleState();
}

class _CustomThemeExampleState extends State<CustomThemeExample> {
  final _controller = VirtualKeypadController();
  int _selectedTheme = 0;

  static const _themes = [
    _ThemeOption(
      name: 'Midnight',
      emoji: '🌙',
      bg: Color(0xFF0F0F1A),
      appBarBg: Color(0xFF1A1A2E),
      textColor: Colors.white,
      accent: Color(0xFF6C63FF),
      theme: VirtualKeypadTheme(
        backgroundColor: Color(0xFF1A1A2E),
        keyColor: Color(0xFF16213E),
        keyTextColor: Colors.white,
        actionKeyColor: Color(0xFF0F3460),
        keyBorderRadius: 12,
      ),
    ),
    _ThemeOption(
      name: 'Ocean',
      emoji: '🌊',
      bg: Color(0xFF0D1B2A),
      appBarBg: Color(0xFF1B2838),
      textColor: Colors.white,
      accent: Color(0xFF89CFF0),
      theme: VirtualKeypadTheme(
        backgroundColor: Color(0xFF1B2838),
        keyColor: Color(0xFF213448),
        keyTextColor: Color(0xFF89CFF0),
        actionKeyColor: Color(0xFF1A5276),
        keyBorderRadius: 10,
        keyShadow: false,
      ),
    ),
    _ThemeOption(
      name: 'Sunset',
      emoji: '🌅',
      bg: Color(0xFFFFF5EE),
      appBarBg: Color(0xFFFFE8D6),
      textColor: Color(0xFF2D2D2D),
      accent: Color(0xFFFF7043),
      theme: VirtualKeypadTheme(
        backgroundColor: Color(0xFFFFE8D6),
        keyColor: Colors.white,
        keyTextColor: Color(0xFF2D2D2D),
        actionKeyColor: Color(0xFFFFB088),
        keyBorderRadius: 14,
        splashColor: Color(0x30FF7043),
      ),
    ),
    _ThemeOption(
      name: 'Neon',
      emoji: '⚡',
      bg: Color(0xFF0A0A0A),
      appBarBg: Color(0xFF1A1A1A),
      textColor: Color(0xFF00FFB2),
      accent: Color(0xFF00FFB2),
      theme: VirtualKeypadTheme(
        backgroundColor: Color(0xFF1A1A1A),
        keyColor: Color(0xFF2A2A2A),
        keyTextColor: Color(0xFF00FFB2),
        actionKeyColor: Color(0xFF003D2B),
        keyBorderRadius: 8,
        splashColor: Color(0x3000FFB2),
      ),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _themes[_selectedTheme];

    return VirtualKeypadScope(
      child: Theme(
        data: Theme.of(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          color: current.bg,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Custom Themes'),
              centerTitle: true,
              backgroundColor: current.appBarBg,
              foregroundColor: current.textColor,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Column(
                      children: [
                        // Theme selector
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _themes.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final theme = _themes[index];
                              final isSelected = index == _selectedTheme;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedTheme = index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.accent.withValues(alpha: 0.2)
                                        : current.appBarBg
                                            .withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.accent
                                              .withValues(alpha: 0.5)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        theme.emoji,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        theme.name,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: isSelected
                                              ? theme.accent
                                              : current.textColor
                                                  .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Spacer(),

                        // Theme name + color swatches
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            key: ValueKey(_selectedTheme),
                            children: [
                              Text(
                                '${current.emoji} ${current.name}',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: current.textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Theme Preview',
                                style: TextStyle(
                                  color: current.textColor
                                      .withValues(alpha: 0.35),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Color palette swatches
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ColorSwatch(
                                    color: current.theme.backgroundColor,
                                    label: 'BG',
                                    textColor: current.textColor,
                                  ),
                                  const SizedBox(width: 8),
                                  _ColorSwatch(
                                    color: current.theme.keyColor,
                                    label: 'Key',
                                    textColor: current.textColor,
                                  ),
                                  const SizedBox(width: 8),
                                  _ColorSwatch(
                                    color: current.theme.keyTextColor,
                                    label: 'Text',
                                    textColor: current.textColor,
                                  ),
                                  const SizedBox(width: 8),
                                  _ColorSwatch(
                                    color: current.theme.actionKeyColor,
                                    label: 'Action',
                                    textColor: current.textColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Text field
                        VirtualKeypadTextField(
                          controller: _controller,
                          style: TextStyle(color: current.textColor),
                          decoration: InputDecoration(
                            labelText: 'Type here',
                            labelStyle: TextStyle(
                              color:
                                  current.textColor.withValues(alpha: 0.5),
                            ),
                            hintText: 'Try the themed keyboard',
                            hintStyle: TextStyle(
                              color:
                                  current.textColor.withValues(alpha: 0.25),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: current.accent.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: current.accent,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: current.theme.keyColor,
                            prefixIcon: Icon(
                              Icons.palette_outlined,
                              color:
                                  current.textColor.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                VirtualKeypad(theme: current.theme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.label,
    required this.textColor,
  });

  final Color color;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: textColor.withValues(alpha: 0.2),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: textColor.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

class _ThemeOption {
  const _ThemeOption({
    required this.name,
    required this.emoji,
    required this.bg,
    required this.appBarBg,
    required this.textColor,
    required this.accent,
    required this.theme,
  });

  final String name;
  final String emoji;
  final Color bg;
  final Color appBarBg;
  final Color textColor;
  final Color accent;
  final VirtualKeypadTheme theme;
}
