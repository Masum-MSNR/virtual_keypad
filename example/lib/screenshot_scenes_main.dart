import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

import 'demo_presets.dart';

/// One keyboard per scene, rendered on its own at an exact size so it can be
/// captured and stitched into a single store image.
///
/// Not part of the demo app. Build it, then load one scene per capture:
///
/// ```sh
/// flutter build web --release -t lib/screenshot_scenes_main.dart
/// # then open  /?scene=desktop  /?scene=emoji  /?scene=pin  ...
/// ```
///
/// `tool/make_showcase.py` drives the captures and composites the result.
void main() {
  initializeKeyboardLayouts();
  runApp(SceneApp(scene: Uri.base.queryParameters['scene'] ?? 'phone'));
}

/// Exact size of each scene, which is the size of the keyboard itself. The
/// capture viewport matches, so a shot contains the keyboard and nothing else.
const sceneSizes = <String, Size>{
  'desktop': Size(760, 300),
  'emoji': Size(460, 380),
  'phone': Size(390, 280),
  'pin': Size(320, 320),
  'arabic': Size(390, 280),
  'kiosk': Size(460, 300),
};

class SceneApp extends StatelessWidget {
  const SceneApp({super.key, required this.scene});

  final String scene;

  @override
  Widget build(BuildContext context) {
    final size = sceneSizes[scene] ?? sceneSizes['phone']!;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Pinned, so the layout does not depend on the capture viewport.
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: size.width,
          height: size.height,
          // Material, or text renders with Flutter's yellow debug underline.
          child: Material(child: _keyboard(scene, size.height)),
        ),
      ),
    );
  }

  Widget _keyboard(String scene, double height) {
    switch (scene) {
      case 'desktop':
        return VirtualKeypad(
          type: KeyboardType.emailAddress,
          height: height,
          hideWhenUnfocused: false,
        );

      case 'emoji':
        return VirtualKeypad(
          height: height,
          hideWhenUnfocused: false,
          enableEmojiKey: true,
          showEmojiKeyboardInitially: true,
          // Opt out of the bundled monochrome web font so the engine supplies
          // its colour emoji for the store image.
          emojiTextStyle: const TextStyle(),
        );

      case 'pin':
        return VirtualKeypad(
          type: KeyboardType.custom,
          customLayout: pinLayout,
          height: height,
          theme: VirtualKeypadTheme.dark,
          hideWhenUnfocused: false,
        );

      case 'arabic':
        return Builder(
          builder: (_) {
            KeyboardLayoutProvider.instance.setLanguage('ar');
            return VirtualKeypad(height: height, hideWhenUnfocused: false);
          },
        );

      case 'kiosk':
        return VirtualKeypad(
          type: KeyboardType.number,
          height: height,
          theme: keypadPresets.firstWhere((p) => p.name == 'Kiosk').theme,
          hideWhenUnfocused: false,
        );

      case 'phone':
      default:
        return Builder(
          builder: (_) {
            KeyboardLayoutProvider.instance.setLanguage('en');
            return VirtualKeypad(height: height, hideWhenUnfocused: false);
          },
        );
    }
  }
}
