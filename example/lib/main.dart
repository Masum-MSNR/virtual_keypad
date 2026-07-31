import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  // Registers the 12 built-in languages. Required before runApp.
  initializeKeyboardLayouts();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'virtual_keypad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// A 3x4 PIN pad, to show what `KeyboardType.custom` takes.
final pinLayout = <KeyRow>[
  [
    VirtualKey.character(text: '1'),
    VirtualKey.character(text: '2'),
    VirtualKey.character(text: '3'),
  ],
  [
    VirtualKey.character(text: '4'),
    VirtualKey.character(text: '5'),
    VirtualKey.character(text: '6'),
  ],
  [
    VirtualKey.character(text: '7'),
    VirtualKey.character(text: '8'),
    VirtualKey.character(text: '9'),
  ],
  [
    VirtualKey.action(action: KeyAction.backSpace),
    VirtualKey.character(text: '0'),
    VirtualKey.action(action: KeyAction.done, label: 'OK'),
  ],
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  KeyboardType _type = KeyboardType.text;
  String _language = 'en';
  bool _emoji = true;
  bool _dark = false;
  bool _floating = false;
  bool _dpad = false;

  static const _languages = ['en', 'bn', 'ar', 'fr', 'hi', 'ru'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  VirtualKeypadTheme get _theme =>
      _dark ? VirtualKeypadTheme.dark : VirtualKeypadTheme.light;

  Widget _buildKeypad() {
    return VirtualKeypad(
      standalone: true,
      type: _type,
      customLayout: _type == KeyboardType.custom ? pinLayout : null,
      theme: _theme,
      enableEmojiKey: _emoji,
      enableDpadNavigation: _dpad,
      availableLanguages: _languages,
      initialLanguage: _language,
      onLanguageChanged: (code) => setState(() => _language = code),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _controller,
          maxLines: _type == KeyboardType.multiline ? 4 : 1,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Tap here, then use the keyboard',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _controller.clear,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const _Label('Keyboard type'),
        Wrap(
          spacing: 8,
          children: [
            for (final entry in const {
              'Text': KeyboardType.text,
              'Multiline': KeyboardType.multiline,
              'Number': KeyboardType.number,
              'Phone': KeyboardType.phone,
              'Email': KeyboardType.emailAddress,
              'URL': KeyboardType.url,
              'PIN pad': KeyboardType.custom,
            }.entries)
              ChoiceChip(
                label: Text(entry.key),
                selected: _type == entry.value,
                onSelected: (_) => setState(() => _type = entry.value),
              ),
          ],
        ),
        const SizedBox(height: 20),
        const _Label('Language'),
        Wrap(
          spacing: 8,
          children: [
            for (final code in _languages)
              ChoiceChip(
                label: Text(code.toUpperCase()),
                selected: _language == code,
                onSelected: (_) {
                  KeyboardLayoutProvider.instance.setLanguage(code);
                  setState(() => _language = code);
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Long-press the space bar to switch language from the keyboard.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Emoji key'),
          value: _emoji,
          onChanged: (v) => setState(() => _emoji = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dark keyboard theme'),
          value: _dark,
          onChanged: (v) => setState(() => _dark = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Floating mode'),
          subtitle: const Text('Draggable panel instead of inline'),
          value: _floating,
          onChanged: (v) => setState(() => _floating = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('D-pad navigation'),
          subtitle: const Text('Arrow keys move, Enter presses'),
          value: _dpad,
          onChanged: (v) => setState(() => _dpad = v),
        ),
        const Divider(height: 32),
        _EmojiFontStatus(),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('virtual_keypad'), centerTitle: true),
      body: _floating
          ? VirtualKeypadFloating(
              standalone: true,
              theme: _theme,
              enableEmojiKey: _emoji,
              width: 380,
              borderRadius: 16,
              child: content,
            )
          : Column(
              children: [
                Expanded(child: content),
                _buildKeypad(),
              ],
            ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Shows which emoji font is in use, and why.
///
/// Web has no system emoji font, so the package bundles one. This is the
/// quickest way to confirm that is working in a browser, since
/// `flutter test --platform chrome` is broken on Windows.
class _EmojiFontStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = defaultEmojiTextStyle();
    final ok = kIsWeb
        ? style?.fontFamily == kBundledEmojiFontFamily
        : style == null;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        ok ? Icons.check_circle : Icons.error,
        color: ok ? Colors.green : Colors.red,
      ),
      title: Text(
        kIsWeb ? 'Web: bundled emoji font' : 'Native: system emoji font',
      ),
      subtitle: Text(
        kIsWeb
            ? 'Monochrome, renders offline. Pass colorEmojiFontLoader for color.'
            : 'Full colour from the OS, already works offline.',
      ),
    );
  }
}
