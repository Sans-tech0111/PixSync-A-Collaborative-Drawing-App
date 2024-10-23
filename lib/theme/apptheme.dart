import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static const Color primary = Color(0xFF9489F5);
  static const Color secondary = Color(0xFF39D2C0);
  static const Color tertiary = Color(0xFF6D5FED);
  static const Color alternate = Color(0xFFE0E3E7);
  static const Color primaryText = Color(0xFF101213);
  static const Color secondaryText = Color(0xFF57636C);
  static const Color primaryBackground = Color(0xFFF1F4F8);
  static const Color secondaryBackground = Color(0xFFFFFFFF);
  static const Color accent1 = Color(0x4D9489F5);
  static const Color accent2 = Color(0x4E39D2C0);
  static const Color accent3 = Color(0x4D6D5FED);
  static const Color accent4 = Color(0xCCFFFFFF);
  static const Color success = Color(0xFF24A891);
  static const Color warning = Color(0xFFCA6C45);
  static const Color error = Color(0xFFE74852);
  static const Color info = Color(0xFFFFFFFF);
}

ThemeData customThemeData() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: CustomTheme.primary,
    scaffoldBackgroundColor: CustomTheme.secondaryBackground,
    textTheme: GoogleFonts.ralewayTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: CustomTheme.primary,
      secondary: CustomTheme.secondary,
      tertiary: CustomTheme.tertiary,
      surface: CustomTheme.primaryBackground,
      surfaceContainerHighest: CustomTheme.secondaryBackground,
      error: CustomTheme.error,
      onPrimary: CustomTheme.primaryText,
      onSecondary: CustomTheme.secondaryText,
      onSurface: CustomTheme.primaryText,
      onError: CustomTheme.info,
    ),
  );
}
