import 'package:flutter/material.dart';

import '../../core/brand.dart';

/// Tema Material 3 da marca — laranja sobre preto, alto contraste nos dois modos.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: Brand.orange,
      brightness: brightness,
      primary: Brand.orange,
      secondary: Brand.orange,
    ).copyWith(
      surface: isDark ? Brand.black : Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      // Roboto embutido (tem €/£/$) — evita "tofu" em fontes de sistema incompletas.
      fontFamily: 'Roboto',
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? Brand.black : const Color(0xFFF7F7F8),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Brand.black : Colors.white,
        foregroundColor: isDark ? Brand.white : Brand.black,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? Brand.blackElevated : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Brand.orange,
          foregroundColor: Colors.black,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Brand.orange,
        foregroundColor: Colors.black,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? Brand.blackElevated : Colors.white,
        indicatorColor: Brand.orange.withValues(alpha: 0.22),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Brand.blackElevated : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Brand.orange, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: Brand.orange,
        secondarySelectedColor: Brand.orange,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white12 : Colors.black12,
      ),
    );
  }
}
