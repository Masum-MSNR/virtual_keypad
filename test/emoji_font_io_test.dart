@TestOn('vm')
library;

import 'dart:io' show File;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

/// Loader tests that need real font bytes off disk, so they cannot run in a
/// browser. The platform-dependent behaviour is covered in
/// `virtual_keypad_test.dart`, which runs on both the VM and Chrome.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VirtualKeypadColorEmoji with real font bytes', () {
    setUp(VirtualKeypadColorEmoji.resetForTesting);
    tearDown(VirtualKeypadColorEmoji.resetForTesting);

    // The package's own bundled font stands in for a downloaded color font;
    // the loader does not care which font it is handed.
    Future<ByteData> realFontBytes() async {
      final bytes = await File('fonts/NotoEmoji-Regular.ttf').readAsBytes();
      return ByteData.sublistView(bytes);
    }

    test('registers the font and flips isLoaded', () async {
      expect(VirtualKeypadColorEmoji.isLoaded.value, isFalse);

      await expectLater(
        VirtualKeypadColorEmoji.load(realFontBytes),
        completion(isTrue),
      );

      expect(VirtualKeypadColorEmoji.isLoaded.value, isTrue);
    });

    test('fallback chain prefers color once it has loaded', () async {
      // Monochrome alone, and it must stay last so emoji always render.
      expect(bundledEmojiFallbackFamilies(), [kBundledEmojiFontFamily]);

      await VirtualKeypadColorEmoji.load(realFontBytes);

      expect(bundledEmojiFallbackFamilies(), [
        VirtualKeypadColorEmoji.fontFamily,
        kBundledEmojiFontFamily,
      ]);
    });

    test('loads once even when several keyboards ask', () async {
      var calls = 0;
      Future<ByteData> counted() {
        calls++;
        return realFontBytes();
      }

      await Future.wait([
        VirtualKeypadColorEmoji.load(counted),
        VirtualKeypadColorEmoji.load(counted),
        VirtualKeypadColorEmoji.load(counted),
      ]);

      expect(calls, 1);
    });
  });
}
