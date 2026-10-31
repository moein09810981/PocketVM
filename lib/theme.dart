import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const appName = 'Glacier';
const appTagline = 'Your VM, Your Control';
const appVersion = '1.1.0';

/// Central color palette (mountain blue). Change colors only here.
class G {
  G._();
  static const bg = Color(0xFF050A12);
  static const card = Color(0xFF0D1626);
  static const card2 = Color(0xFF142137);
  static const line = Color(0xFF1B2A41);
  static const accent = Color(0xFF3D9BFF);
  static const accentLight = Color(0xFF7FD4FF);
  static const accentDeep = Color(0xFF1F63D6);
  static const text = Color(0xFFF1F5FB);
  static const muted = Color(0xFF8793A8);
  static const green = Color(0xFF2BD385);
  static const danger = Color(0xFFFF6B6B);
  static const onAccent = Color(0xFF04101F);
  static const gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2F84F5), Color(0xFF5BBBFF)],
  );
}

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: G.bg,
    colorScheme: const ColorScheme.dark(
      primary: G.accent,
      secondary: G.accentLight,
      surface: G.card,
    ),
    textTheme: GoogleFonts.vazirmatnTextTheme(base.textTheme)
        .apply(bodyColor: G.text, displayColor: G.text),
    splashColor: G.accent.withValues(alpha: .08),
    highlightColor: Colors.transparent,
    sliderTheme: SliderThemeData(
      trackHeight: 4,
      activeTrackColor: G.accent,
      inactiveTrackColor: G.line,
      thumbColor: G.accentLight,
      overlayColor: G.accent.withValues(alpha: .15),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: G.card2,
      contentTextStyle: const TextStyle(color: G.text, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
