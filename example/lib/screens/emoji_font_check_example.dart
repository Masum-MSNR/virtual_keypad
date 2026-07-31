import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

import '../example_page_layout.dart';

/// Reports which emoji font the keyboard is using and why.
///
/// `flutter test --platform chrome` is broken on Windows
/// (flutter/flutter#162798, #44583), so the web-only code paths cannot be
/// covered by a local test run there. This screen runs the same checks inside
/// the running app instead: open it with `flutter run -d chrome` and read the
/// results.
///
/// It doubles as a diagnostic when emoji do not look the way you expect in a
/// deployed web build.
class EmojiFontCheckExample extends StatefulWidget {
  const EmojiFontCheckExample({super.key});

  @override
  State<EmojiFontCheckExample> createState() => _EmojiFontCheckExampleState();
}

class _EmojiFontCheckExampleState extends State<EmojiFontCheckExample> {
  @override
  void initState() {
    super.initState();
    VirtualKeypadColorEmoji.isLoaded.addListener(_onColorEmojiChanged);
  }

  @override
  void dispose() {
    VirtualKeypadColorEmoji.isLoaded.removeListener(_onColorEmojiChanged);
    super.dispose();
  }

  void _onColorEmojiChanged() {
    if (mounted) setState(() {});
  }

  List<_Check> _runChecks() {
    const probe = TextStyle(fontSize: 18, color: Colors.teal);
    final theme = ThemeData.light();
    final emojiStyle = defaultEmojiTextStyle();
    final fallbackStyle = withBundledEmojiFallback(probe);
    final themedFallback = theme
        .withVirtualKeypadEmojiFont()
        .textTheme
        .bodyMedium
        ?.fontFamilyFallback;

    if (kIsWeb) {
      return [
        _Check(
          'Emoji grid uses the bundled font',
          emojiStyle?.fontFamily == kBundledEmojiFontFamily,
          emojiStyle?.fontFamily ?? 'null',
        ),
        _Check(
          'Text fields fall back to the bundled font',
          fallbackStyle?.fontFamilyFallback?.contains(
                kBundledEmojiFontFamily,
              ) ??
              false,
          '${fallbackStyle?.fontFamilyFallback}',
        ),
        _Check(
          'Caller styling survives the fallback',
          fallbackStyle?.fontSize == 18 && fallbackStyle?.color == Colors.teal,
          'size ${fallbackStyle?.fontSize}',
        ),
        _Check(
          'Theme extension adds the fallback',
          themedFallback?.contains(kBundledEmojiFontFamily) ?? false,
          '$themedFallback',
        ),
        _Check(
          'Monochrome font is last in the chain',
          bundledEmojiFallbackFamilies().last == kBundledEmojiFontFamily,
          '${bundledEmojiFallbackFamilies()}',
        ),
      ];
    }

    return [
      _Check(
        'Platform emoji font is left alone',
        emojiStyle == null,
        emojiStyle?.fontFamily ?? 'null (correct)',
      ),
      _Check(
        'Text field styling is untouched',
        identical(fallbackStyle, probe),
        'unchanged',
      ),
      _Check(
        'Theme is untouched',
        identical(theme.withVirtualKeypadEmojiFont(), theme),
        'unchanged',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final checks = _runChecks();
    final passed = checks.where((c) => c.passed).length;
    final allPassed = passed == checks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emoji Font Check'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ExampleScrollableContent(
              topPadding: 20,
              bottomPadding: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: allPassed
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.red.withValues(alpha: 0.12),
                    child: ListTile(
                      leading: Icon(
                        allPassed
                            ? Icons.check_circle_rounded
                            : Icons.error_rounded,
                        color: allPassed ? Colors.green : Colors.red,
                        size: 32,
                      ),
                      title: Text(
                        allPassed ? 'All checks passed' : 'Some checks failed',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '$passed of ${checks.length} on '
                        '${kIsWeb ? 'web' : 'native'}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final check in checks)
                    ListTile(
                      dense: true,
                      leading: Icon(
                        check.passed
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        color: check.passed ? Colors.green : Colors.red,
                      ),
                      title: Text(check.label),
                      subtitle: Text(
                        check.detail,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                    ),
                  const Divider(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      kIsWeb
                          ? 'On web the bundled font is applied so emoji render '
                                'without a network connection. They are monochrome, '
                                'which is the trade for a 708 KB font instead of '
                                '3.9 MB. Pass colorEmojiFontLoader for color.\n\n'
                                'Color font loaded: '
                                '${VirtualKeypadColorEmoji.isLoaded.value}'
                          : 'On this platform the system emoji font is used, so '
                                'emoji are in color and already work offline. The '
                                'bundled font is deliberately not applied.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Tap the emoji key below. If you see emoji rather than blank '
                      'boxes, the font in use can actually render them.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Type an emoji here',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VirtualKeypad(
            standalone: true,
            enableEmojiKey: true,
            hideWhenUnfocused: false,
          ),
        ],
      ),
    );
  }
}

class _Check {
  const _Check(this.label, this.passed, this.detail);

  final String label;
  final bool passed;
  final String detail;
}
