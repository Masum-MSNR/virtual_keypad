import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';
import 'screens/password_entry_example.dart';
import 'screens/numeric_input_example.dart';
import 'screens/multi_field_example.dart';
import 'screens/custom_theme_example.dart';
import 'screens/multiline_text_example.dart';
import 'screens/auto_hide_keyboard_example.dart';
import 'screens/language_switching_example.dart';
import 'screens/email_url_example.dart';
import 'screens/pin_pad_example.dart';
import 'screens/standalone_example.dart';

void main() {
  initializeKeyboardLayouts();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keypad Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Virtual Keypad',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Flutter on-screen keyboard',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const _SectionHeader(
            title: 'Input Types',
            icon: Icons.input_rounded,
          ),
          _ExampleCard(
            icon: Icons.dialpad_rounded,
            title: 'Numeric Input',
            subtitle: 'Amount entry with quick-fill chips',
            gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
            onTap: () => _navigate(context, const NumericInputExample()),
          ),
          _ExampleCard(
            icon: Icons.pin_outlined,
            title: 'PIN Pad',
            subtitle: 'Custom layout with animated dots',
            gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
            onTap: () => _navigate(context, const PinPadExample()),
          ),
          _ExampleCard(
            icon: Icons.lock_rounded,
            title: 'Password Entry',
            subtitle: 'Login form with strength indicator',
            gradient: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
            onTap: () => _navigate(context, const PasswordEntryExample()),
          ),
          _ExampleCard(
            icon: Icons.alternate_email_rounded,
            title: 'Email & URL',
            subtitle: 'Adaptive keyboard per input type',
            gradient: const [Color(0xFF43e97b), Color(0xFF38f9d7)],
            onTap: () => _navigate(context, const EmailUrlExample()),
          ),
          const SizedBox(height: 4),
          const _SectionHeader(
            title: 'Forms & Text',
            icon: Icons.edit_document,
          ),
          _ExampleCard(
            icon: Icons.assignment_outlined,
            title: 'Multi-Field Form',
            subtitle: 'Step-style registration with progress',
            gradient: const [Color(0xFFfa709a), Color(0xFFfee140)],
            onTap: () => _navigate(context, const MultiFieldExample()),
          ),
          _ExampleCard(
            icon: Icons.edit_note_rounded,
            title: 'Multiline Text',
            subtitle: 'Note editor with word & line count',
            gradient: const [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
            onTap: () => _navigate(context, const MultilineTextExample()),
          ),
          const SizedBox(height: 4),
          const _SectionHeader(
            title: 'Features',
            icon: Icons.stars_rounded,
          ),
          _ExampleCard(
            icon: Icons.bolt_rounded,
            title: 'Standalone Mode',
            subtitle: 'Works with any Flutter TextField',
            gradient: const [Color(0xFFFF6B6B), Color(0xFFee5a24)],
            onTap: () => _navigate(context, const StandaloneExample()),
          ),
          _ExampleCard(
            icon: Icons.keyboard_hide_rounded,
            title: 'Auto-Hide Keyboard',
            subtitle: 'Focus-aware animated transitions',
            gradient: const [Color(0xFF30cfd0), Color(0xFF330867)],
            onTap: () => _navigate(context, const AutoHideKeyboardExample()),
          ),
          _ExampleCard(
            icon: Icons.palette_rounded,
            title: 'Custom Themes',
            subtitle: '4 gorgeous keyboard themes',
            gradient: const [Color(0xFFf6d365), Color(0xFFfda085)],
            onTap: () => _navigate(context, const CustomThemeExample()),
          ),
          _ExampleCard(
            icon: Icons.translate_rounded,
            title: 'Language Switching',
            subtitle: 'Toggle English ↔ Bengali ↔ French',
            gradient: const [Color(0xFF89f7fe), Color(0xFF66a6ff)],
            onTap: () => _navigate(context, const LanguageSwitchingExample()),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: gradient.first.withValues(alpha: 0.08),
            highlightColor: gradient.first.withValues(alpha: 0.04),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gradient.first.withValues(alpha: 0.06),
                    gradient.last.withValues(alpha: 0.03),
                    colorScheme.surface,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
                border: Border.all(
                  color: gradient.first.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.first.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: gradient.first.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: gradient.first.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
