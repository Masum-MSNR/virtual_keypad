import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';
import 'screens/password_entry_example.dart';
import 'screens/numeric_input_example.dart';
import 'screens/multi_field_example.dart';
import 'screens/custom_theme_example.dart';
import 'screens/multiline_text_example.dart';
import 'screens/auto_hide_keyboard_example.dart';

void main() {
  initializeKeyboardLayouts();

  KeyboardLayoutProvider.instance.setLanguage('bn');

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
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
      appBar: AppBar(title: const Text('Virtual Keypad'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Examples',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          _ExampleTile(
            icon: Icons.dialpad,
            title: 'Numeric Input',
            subtitle: 'Number pad keyboard',
            onTap: () => _navigate(context, const NumericInputExample()),
          ),
          _ExampleTile(
            icon: Icons.lock_outline,
            title: 'Password Entry',
            subtitle: 'Obscured text input',
            onTap: () => _navigate(context, const PasswordEntryExample()),
          ),
          _ExampleTile(
            icon: Icons.article_outlined,
            title: 'Multi-Field Form',
            subtitle: 'Multiple fields, shared keyboard',
            onTap: () => _navigate(context, const MultiFieldExample()),
          ),
          _ExampleTile(
            icon: Icons.notes_outlined,
            title: 'Multiline Text',
            subtitle: 'Text area with auto-scroll',
            onTap: () => _navigate(context, const MultilineTextExample()),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Features',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          _ExampleTile(
            icon: Icons.keyboard_hide_outlined,
            title: 'Auto-Hide Keyboard',
            subtitle: 'Shows/hides with animation',
            onTap: () => _navigate(context, const AutoHideKeyboardExample()),
          ),
          _ExampleTile(
            icon: Icons.palette_outlined,
            title: 'Custom Theme',
            subtitle: 'Styled keyboard appearance',
            onTap: () => _navigate(context, const CustomThemeExample()),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
