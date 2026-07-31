import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

import 'demo_presets.dart';

/// A portrait composition used to generate the pub.dev store screenshot.
///
/// Not part of the demo app. Build it explicitly:
///
/// ```sh
/// flutter build web --release -t lib/screenshot_main.dart
/// ```
///
/// then load it at a phone viewport and capture the page.
/// Capture these exact logical dimensions.
const shotWidth = 430.0;
const shotHeight = 932.0;

void main() {
  initializeKeyboardLayouts();
  runApp(const ScreenshotApp());
}

class ScreenshotApp extends StatelessWidget {
  const ScreenshotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      home: const ScreenshotPage(),
    );
  }
}

class ScreenshotPage extends StatelessWidget {
  const ScreenshotPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pinned to the top left at a fixed size, so the composition does not
    // depend on the browser viewport the capture happens to run at.
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: shotWidth,
        height: shotHeight,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F4F8),
          body: Column(
            children: [
              const _Header(),
              const _Caption('QWERTY, 12 built-in languages'),
              const _Frame(
                child: VirtualKeypad(
                  type: KeyboardType.text,
                  height: 240,
                  hideWhenUnfocused: false,
                ),
              ),
              const _Caption('Numeric keypad, custom PIN pad, theming'),
              _Frame(
                child: VirtualKeypad(
                  type: KeyboardType.custom,
                  customLayout: pinLayout,
                  height: 210,
                  theme: VirtualKeypadTheme.dark,
                  hideWhenUnfocused: false,
                ),
              ),
              const _Caption('Emoji, floating and D-pad modes'),
              const _Frame(
                child: VirtualKeypad(
                  height: 250,
                  hideWhenUnfocused: false,
                  enableEmojiKey: true,
                  showEmojiKeyboardInitially: true,
                  // Opt out of the bundled monochrome web font so the engine
                  // supplies its colour emoji for the store image.
                  emojiTextStyle: TextStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
              ),
            ),
            child: const Icon(
              Icons.keyboard_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'virtual_keypad',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              Text(
                'On-screen keyboard for Flutter',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B6B7B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: Color(0xFF8A8A99),
          ),
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(borderRadius: BorderRadius.circular(14), child: child),
    );
  }
}
