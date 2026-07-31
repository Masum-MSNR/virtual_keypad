import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

import 'demo_presets.dart';

/// A landscape composition showing the keyboard at desktop, tablet, and phone
/// widths in one image.
///
/// Not part of the demo app. Build it explicitly:
///
/// ```sh
/// flutter build web --release -t lib/screenshot_sizes_main.dart
/// ```
///
/// then capture the page at [canvasWidth] by [canvasHeight].
void main() {
  initializeKeyboardLayouts();
  runApp(const SizesShotApp());
}

const canvasWidth = 1600.0;
const canvasHeight = 700.0;

const _ink = Color(0xFF1B1B25);
const _muted = Color(0xFF7A7A8C);

class SizesShotApp extends StatelessWidget {
  const SizesShotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      home: const SizesShotPage(),
    );
  }
}

class SizesShotPage extends StatelessWidget {
  const SizesShotPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pinned at a fixed size so the composition does not depend on the
    // viewport the capture happens to run at.
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: canvasWidth,
        height: canvasHeight,
        // Material, not a bare ColoredBox: text with no Material ancestor
        // renders with Flutter's yellow debug underline.
        child: Material(
          color: const Color(0xFFF4F4F8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(44, 34, 44, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                const SizedBox(height: 26),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // One keyboard, three widths. The layout reflows to fit
                      // rather than scaling, which is the point of the image.
                      _Panel(
                        label: 'Desktop',
                        note: 'Kiosk, POS, and desktop apps',
                        width: 700,
                        child: VirtualKeypad(
                          type: KeyboardType.text,
                          height: 330,
                          hideWhenUnfocused: false,
                        ),
                      ),
                      const SizedBox(width: 28),
                      _Panel(
                        label: 'Tablet',
                        note: 'Emoji, 12 languages',
                        width: 452,
                        child: VirtualKeypad(
                          height: 440,
                          hideWhenUnfocused: false,
                          enableEmojiKey: true,
                          showEmojiKeyboardInitially: true,
                          // Opt out of the bundled monochrome web font so the
                          // engine supplies its colour emoji for this image.
                          emojiTextStyle: const TextStyle(),
                        ),
                      ),
                      const SizedBox(width: 28),
                      _Panel(
                        label: 'Phone',
                        note: 'Custom PIN pad, theming',
                        width: 304,
                        child: VirtualKeypad(
                          type: KeyboardType.custom,
                          customLayout: pinLayout,
                          height: 380,
                          theme: VirtualKeypadTheme.dark,
                          hideWhenUnfocused: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
            ),
          ),
          child: const Icon(
            Icons.keyboard_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'virtual_keypad',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'One on-screen keyboard that fits every screen',
              style: TextStyle(fontSize: 15, color: _muted),
            ),
          ],
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.label,
    required this.note,
    required this.width,
    required this.child,
  });

  final String label;
  final String note;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: _ink,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${width.toInt()} px',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(note, style: const TextStyle(fontSize: 13, color: _muted)),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.13),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
