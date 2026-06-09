import 'package:flutter/material.dart';

class AppTheme {
  // ── CORES DO DESIGN SYSTEM ────────────────────────────
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);

  // Texto
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // Destaque principal: azul
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEEF2FF);

  // Destaque: verde (recebido, criação)
  static const Color green = Color(0xFF3DA35C);

  // Destaque: âmbar (a receber, correção)
  static const Color amber = Color(0xFFF5A02F);

  // ── TEMA PRINCIPAL ────────────────────────────────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      surface: surface,
      background: background,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: border),
      ),
    ),
    dividerColor: border,
  );

  // ── SOMBRA DOS CARDS ──────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];
}
