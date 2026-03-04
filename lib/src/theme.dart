import 'package:flutter/material.dart';

/// Theme configuration for [VirtualKeypad] appearance.
///
/// Provides colors, sizes, and styling options for keyboard keys.
/// Use [VirtualKeypadTheme.light] or [VirtualKeypadTheme.dark] for
/// predefined themes, or create a custom theme.
///
/// ```dart
/// VirtualKeypad(
///   theme: VirtualKeypadTheme(
///     backgroundColor: Colors.grey[200]!,
///     keyColor: Colors.white,
///     keyTextColor: Colors.black,
///   ),
/// )
/// ```
class VirtualKeypadTheme {
  /// Creates a custom keyboard theme.
  const VirtualKeypadTheme({
    this.backgroundColor = VkpColors.backgroundColor,
    this.keyColor = VkpColors.keyColor,
    this.actionKeyColor = VkpColors.actionKeyColor,
    this.keyTextColor = VkpColors.keyTextColor,
    this.keyTextSize = 22.0,
    this.keyBorderRadius = 6.0,
    this.keyShadow = true,
    this.splashColor,
    this.horizontalGap = 6.0,
    this.verticalGap = 8.0,
  });

  /// Background color of the keyboard container.
  final Color backgroundColor;

  /// Background color of character keys.
  final Color keyColor;

  /// Background color of action keys (shift, backspace, etc.).
  final Color actionKeyColor;

  /// Text and icon color for all keys.
  final Color keyTextColor;

  /// Font size for key text.
  final double keyTextSize;

  /// Border radius for key buttons.
  final double keyBorderRadius;

  /// Whether to show drop shadow on keys.
  final bool keyShadow;

  /// Splash/ripple color when keys are tapped.
  final Color? splashColor;

  /// Horizontal gap between keys.
  final double horizontalGap;

  /// Vertical gap between key rows.
  final double verticalGap;

  /// Decoration for character keys.
  BoxDecoration get keyDecoration => BoxDecoration(
    color: keyColor,
    borderRadius: BorderRadius.circular(keyBorderRadius),
    boxShadow: keyShadow
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 1,
              spreadRadius: 0.5,
              offset: const Offset(0, 1),
            ),
          ]
        : null,
  );

  /// Decoration for action keys.
  BoxDecoration get actionKeyDecoration => BoxDecoration(
    color: actionKeyColor,
    borderRadius: BorderRadius.circular(keyBorderRadius),
    boxShadow: keyShadow
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 1,
              spreadRadius: 0.5,
              offset: const Offset(0, 1),
            ),
          ]
        : null,
  );

  /// Creates a copy of this theme with the given fields replaced.
  VirtualKeypadTheme copyWith({
    Color? backgroundColor,
    Color? keyColor,
    Color? actionKeyColor,
    Color? keyTextColor,
    double? keyTextSize,
    double? keyBorderRadius,
    bool? keyShadow,
    Color? splashColor,
    double? horizontalGap,
    double? verticalGap,
  }) {
    return VirtualKeypadTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      keyColor: keyColor ?? this.keyColor,
      actionKeyColor: actionKeyColor ?? this.actionKeyColor,
      keyTextColor: keyTextColor ?? this.keyTextColor,
      keyTextSize: keyTextSize ?? this.keyTextSize,
      keyBorderRadius: keyBorderRadius ?? this.keyBorderRadius,
      keyShadow: keyShadow ?? this.keyShadow,
      splashColor: splashColor ?? this.splashColor,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      verticalGap: verticalGap ?? this.verticalGap,
    );
  }

  /// Light theme preset (iOS-style light keyboard).
  static const light = VirtualKeypadTheme();

  /// Dark theme preset (iOS-style dark keyboard).
  static const dark = VirtualKeypadTheme(
    backgroundColor: Color(0xFF2C2C2E),
    keyColor: Color(0xFF636366),
    actionKeyColor: Color(0xFF48484A),
    keyTextColor: Colors.white,
  );
}

/// Default color constants for [VirtualKeypadTheme].
class VkpColors {
  VkpColors._();

  /// Default keyboard background color.
  static const Color backgroundColor = Color(0xFFD1D3D9);

  /// Default character key background color.
  static const Color keyColor = Color(0xFFFFFFFF);

  /// Default action key background color.
  static const Color actionKeyColor = Color(0xFFADB3BC);

  /// Default key text color.
  static const Color keyTextColor = Color(0xFF1C1C1E);

  /// Default tap splash/ripple color.
  static const Color splashColor = Color(0xFFDDDDDD);
}
