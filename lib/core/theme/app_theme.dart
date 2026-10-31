import 'package:flutter/material.dart';

import 'tokens.dart';

/// Builds the Material theme from the HelloFit tokens so screens never
/// hard-code a colour or radius.
abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: HFColors.pageBackground,
      colorScheme: base.colorScheme.copyWith(
        primary: HFColors.primary,
        surface: Colors.white,
        onSurface: HFColors.ink,
        error: HFColors.primary,
        secondary: HFColors.success,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: HFFonts.body,
        bodyColor: HFColors.ink,
        displayColor: HFColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: HFColors.ivory,
        foregroundColor: HFColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HFRadius.card),
          side: const BorderSide(color: HFColors.hairline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HFColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HFRadius.control),
          ),
          textStyle: const TextStyle(
            fontFamily: HFFonts.body,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HFRadius.control),
          borderSide: const BorderSide(color: HFColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HFRadius.control),
          borderSide: const BorderSide(color: HFColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HFRadius.control),
          borderSide: const BorderSide(color: HFColors.primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: HFColors.muted),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: HFColors.ivory,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontFamily: HFFonts.body, fontSize: 12),
        ),
      ),
      dividerColor: HFColors.hairline,
    );
  }
}
