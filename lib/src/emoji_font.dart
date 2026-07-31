import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Emoji font bundled with this package, subset to the codepoints the emoji
/// picker uses.
///
/// Only needed on Flutter web. The CanvasKit and Skwasm renderers ignore the
/// browser font stack and download a fallback emoji font on demand, so without
/// a bundled font emoji render as blank boxes until that download succeeds.
/// Native platforms ship their own color emoji font and work offline already.
///
/// The keyboard applies this automatically on web, both to the emoji picker
/// grid and to [VirtualKeypadTextField]. Use the constant directly when you
/// need the same coverage elsewhere in your app, or call
/// [VirtualKeypadEmojiFont.withVirtualKeypadEmojiFont] on your theme.
const String kBundledEmojiFontFamily = 'packages/virtual_keypad/NotoEmoji';

/// Emoji text style applied when the caller does not supply one.
///
/// Returns null off the web so the platform's color emoji font is used as-is.
TextStyle? defaultEmojiTextStyle() =>
    kIsWeb ? const TextStyle(fontFamily: kBundledEmojiFontFamily) : null;

/// Appends [kBundledEmojiFontFamily] to [style] so emoji in that text render
/// offline on web.
///
/// Returns [style] untouched off the web, where the platform already provides
/// a color emoji font.
TextStyle? withBundledEmojiFallback(TextStyle? style) {
  if (!kIsWeb) return style;
  final existing = style?.fontFamilyFallback ?? const <String>[];
  if (existing.contains(kBundledEmojiFontFamily)) return style;
  return (style ?? const TextStyle()).copyWith(
    fontFamilyFallback: [...existing, kBundledEmojiFontFamily],
  );
}

/// Adds the bundled emoji font to a [ThemeData] so emoji render offline on web.
extension VirtualKeypadEmojiFont on ThemeData {
  /// Returns a copy of this theme with [kBundledEmojiFontFamily] appended as a
  /// font fallback across the text themes.
  ///
  /// The keyboard already handles its own emoji grid and
  /// [VirtualKeypadTextField]. Use this when your app drives the keyboard in
  /// standalone mode with plain [TextField] widgets, so emoji the user inserts
  /// keep rendering without a network connection:
  ///
  /// ```dart
  /// MaterialApp(
  ///   theme: ThemeData.light().withVirtualKeypadEmojiFont(),
  ///   home: const MyHomePage(),
  /// )
  /// ```
  ///
  /// Returns this theme unchanged off the web.
  ThemeData withVirtualKeypadEmojiFont() {
    if (!kIsWeb) return this;
    const fallback = <String>[kBundledEmojiFontFamily];
    return copyWith(
      textTheme: textTheme.apply(fontFamilyFallback: fallback),
      primaryTextTheme: primaryTextTheme.apply(fontFamilyFallback: fallback),
    );
  }
}
