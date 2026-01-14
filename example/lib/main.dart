import 'package:flutter/material.dart';
import 'screens/password_entry_example.dart';
import 'screens/numeric_input_example.dart';
import 'screens/multi_field_example.dart';
import 'screens/custom_theme_example.dart';
import 'screens/multiline_text_example.dart';
import 'screens/auto_hide_keyboard_example.dart';

void main() {
  runApp(const VirtualKeypadExampleApp());
}

class VirtualKeypadExampleApp extends StatelessWidget {
  const VirtualKeypadExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keypad Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Keypad Examples'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ExampleCard(
            title: 'Password Entry',
            subtitle: 'Secure PIN/password input with virtual keyboard',
            icon: Icons.lock_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PasswordEntryExample()),
            ),
          ),
          _ExampleCard(
            title: 'Numeric Input',
            subtitle: 'Number pad for numeric input only',
            icon: Icons.dialpad,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NumericInputExample()),
            ),
          ),
          _ExampleCard(
            title: 'Multi-Field Form',
            subtitle: 'Multiple text fields with shared keyboard',
            icon: Icons.article_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultiFieldExample()),
            ),
          ),
          _ExampleCard(
            title: 'Custom Theme',
            subtitle: 'Customized keyboard appearance',
            icon: Icons.palette_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomThemeExample()),
            ),
          ),
          _ExampleCard(
            title: 'Multiline Text',
            subtitle: 'Multi-line text area with auto-scroll',
            icon: Icons.notes_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultilineTextExample()),
            ),
          ),
          _ExampleCard(
            title: 'Auto-Hide Keyboard',
            subtitle: 'Keyboard appears only when text field is focused',
            icon: Icons.keyboard_hide_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AutoHideKeyboardExample()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
