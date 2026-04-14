import 'package:flutter/material.dart';

/// Palette de couleurs de l'application Metronome for Live.
/// Inspirée du design sombre professionnel avec accents cyan.
class AppColors {
  AppColors._();

  // ─── Backgrounds ───────────────────────────────────────
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF252525);
  static const Color surfaceBorder = Color(0xFF2A2A2A);

  // ─── Accent ────────────────────────────────────────────
  static const Color accent = Color(0xFF00E5CC);
  static const Color accentDark = Color(0xFF00A896);
  static const Color accentDim = Color(0xFF004D44);

  // ─── Text ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textDim = Color(0xFF555555);

  // ─── Semantic ──────────────────────────────────────────
  static const Color error = Color(0xFFFF4454);
  static const Color warning = Color(0xFFFFAA00);
  static const Color success = Color(0xFF00CC66);

  // ─── Beat visualization ────────────────────────────────
  static const Color beatAccent = accent;
  static const Color beatNormal = Color(0xFF00A896);
  static const Color beatSubdivision = Color(0xFF005C50);
  static const Color beatInactive = Color(0xFF333333);
}
