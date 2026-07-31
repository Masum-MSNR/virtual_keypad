import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  // Registers the 12 built-in languages. Required before runApp.
  initializeKeyboardLayouts();
  runApp(const ExampleApp());
}

const _seed = Color(0xFF6C63FF);

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'virtual_keypad',
      debugShowCheckedModeBanner: false,
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: HomePage(
        dark: _dark,
        onDarkChanged: (value) => setState(() => _dark = value),
      ),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF6F6FA)
          : const Color(0xFF121216),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide.none,
      ),
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

const _types = <String, KeyboardType>{
  'Text': KeyboardType.text,
  'Multiline': KeyboardType.multiline,
  'Number': KeyboardType.number,
  'Phone': KeyboardType.phone,
  'Email': KeyboardType.emailAddress,
  'URL': KeyboardType.url,
  'PIN pad': KeyboardType.custom,
};

const _languages = <String, String>{
  'en': 'English',
  'bn': 'বাংলা',
  'ar': 'العربية',
  'fr': 'Français',
  'hi': 'हिन्दी',
  'ru': 'Русский',
};

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.dark, required this.onDarkChanged});

  final bool dark;
  final ValueChanged<bool> onDarkChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  KeyboardType _type = KeyboardType.text;
  String _language = 'en';
  bool _emoji = true;
  bool _floating = false;
  bool _dpad = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  VirtualKeypadTheme get _keypadTheme =>
      widget.dark ? VirtualKeypadTheme.dark : VirtualKeypadTheme.light;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'virtual_keypad',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: widget.dark ? 'Switch to light' : 'Switch to dark',
            icon: Icon(
              widget.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () => widget.onDarkChanged(!widget.dark),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody(scheme)),
          if (!_floating)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: scheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
              child: _buildKeypad(),
            ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return VirtualKeypad(
      standalone: true,
      type: _type,
      customLayout: _type == KeyboardType.custom ? pinLayout : null,
      theme: _keypadTheme,
      enableEmojiKey: _emoji,
      enableDpadNavigation: _dpad,
      availableLanguages: _languages.keys.toList(),
      initialLanguage: _language,
      onLanguageChanged: (code) => setState(() => _language = code),
    );
  }

  Widget _buildBody(ColorScheme scheme) {
    final content = ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        _Display(text: _controller.text, scheme: scheme),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          maxLines: _type == KeyboardType.multiline ? 3 : 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            hintText: 'Tap here, then use the keyboard below',
            prefixIcon: const Icon(Icons.keyboard_rounded),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: _controller.clear,
                  ),
          ),
        ),
        const SizedBox(height: 20),
        _Section(
          icon: Icons.dialpad_rounded,
          title: 'Keyboard type',
          subtitle: 'The layout adapts to the field',
          child: _ChipRow(
            labels: _types.keys.toList(),
            isSelected: (label) => _types[label] == _type,
            onTap: (label) => setState(() => _type = _types[label]!),
          ),
        ),
        const SizedBox(height: 12),
        _Section(
          icon: Icons.translate_rounded,
          title: 'Language',
          subtitle: 'Long-press the space bar to switch from the keyboard',
          child: _ChipRow(
            labels: _languages.keys.toList(),
            labelBuilder: (code) => _languages[code]!,
            isSelected: (code) => code == _language,
            onTap: (code) {
              KeyboardLayoutProvider.instance.setLanguage(code);
              setState(() => _language = code);
            },
          ),
        ),
        const SizedBox(height: 12),
        _Section(
          icon: Icons.tune_rounded,
          title: 'Options',
          child: Column(
            children: [
              _Toggle(
                icon: Icons.emoji_emotions_rounded,
                title: 'Emoji key',
                subtitle: 'Adds an emoji page to text layouts',
                value: _emoji,
                onChanged: (v) => setState(() => _emoji = v),
              ),
              _Toggle(
                icon: Icons.open_in_new_rounded,
                title: 'Floating mode',
                subtitle: 'Draggable panel instead of inline',
                value: _floating,
                onChanged: (v) => setState(() => _floating = v),
              ),
              _Toggle(
                icon: Icons.gamepad_rounded,
                title: 'D-pad navigation',
                subtitle: 'Arrow keys move, Enter presses. For TV',
                value: _dpad,
                onChanged: (v) => setState(() => _dpad = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _EmojiFontStatus(),
      ],
    );

    // Keep the column readable on desktop and web instead of stretching it
    // across the full window.
    final constrained = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: content,
      ),
    );

    if (!_floating) return constrained;

    return VirtualKeypadFloating(
      standalone: true,
      theme: _keypadTheme,
      enableEmojiKey: _emoji,
      width: 380,
      borderRadius: 18,
      child: constrained,
    );
  }
}

/// Big read-out of what has been typed, so the keyboard's effect is obvious.
class _Display extends StatelessWidget {
  const _Display({required this.text, required this.scheme});

  final String text;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final empty = text.isEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [_seed, const Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                empty ? 'Nothing typed yet' : '${text.characters.length} chars',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            empty ? 'Your text appears here' : text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: empty ? Colors.white38 : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 12, color: scheme.outline),
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.labels,
    required this.isSelected,
    required this.onTap,
    this.labelBuilder,
  });

  final List<String> labels;
  final String Function(String)? labelBuilder;
  final bool Function(String) isSelected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final label in labels)
          ChoiceChip(
            label: Text(labelBuilder?.call(label) ?? label),
            selected: isSelected(label),
            showCheckmark: false,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected(label) ? scheme.onPrimary : scheme.onSurface,
            ),
            selectedColor: scheme.primary,
            backgroundColor: scheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            onSelected: (_) => onTap(label),
          ),
      ],
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      secondary: Icon(
        icon,
        size: 20,
        color: value ? scheme.primary : scheme.outline,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11.5, color: scheme.outline),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Reports which emoji font is in use, and why.
///
/// Web has no system emoji font, so the package bundles one and applies it
/// there only. This is the quickest way to confirm that works in a browser,
/// since `flutter test --platform chrome` is broken on Windows.
class _EmojiFontStatus extends StatelessWidget {
  const _EmojiFontStatus();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = defaultEmojiTextStyle();
    final ok = kIsWeb
        ? style?.fontFamily == kBundledEmojiFontFamily
        : style == null;

    final color = ok ? const Color(0xFF12A150) : scheme.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              ok ? Icons.check_circle_rounded : Icons.error_rounded,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kIsWeb
                        ? 'Web: bundled emoji font'
                        : 'Native: system emoji font',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    kIsWeb
                        ? 'Monochrome, renders offline. Pass '
                              'colorEmojiFontLoader for colour.'
                        : 'Full colour from the OS, already works offline.',
                    style: TextStyle(fontSize: 11.5, color: scheme.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
