import 'package:flutter/material.dart';

class VirtualKeypadTheme {
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

  final Color backgroundColor;
  final Color keyColor;
  final Color actionKeyColor;
  final Color keyTextColor;
  final double keyTextSize;
  final double keyBorderRadius;
  final bool keyShadow;
  final Color? splashColor;
  final double horizontalGap;
  final double verticalGap;

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

  static const light = VirtualKeypadTheme();

  static const dark = VirtualKeypadTheme(
    backgroundColor: Color(0xFF2C2C2E),
    keyColor: Color(0xFF636366),
    actionKeyColor: Color(0xFF48484A),
    keyTextColor: Colors.white,
  );
}

class VkpColors {
  VkpColors._();

  static const Color backgroundColor = Color(0xFFD1D3D9);
  static const Color keyColor = Color(0xFFFFFFFF);
  static const Color actionKeyColor = Color(0xFFADB3BC);
  static const Color keyTextColor = Color(0xFF1C1C1E);
  static const Color splashColor = Color(0xFFDDDDDD);
}

