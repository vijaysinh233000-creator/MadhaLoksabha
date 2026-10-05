import 'package:flutter/material.dart';

/// Locked public-facing palette: one forest family, neutrals and one action.
class AppColors {
  AppColors._();

  // Legacy green token names remain aliases while older widgets are migrated.
  static const saffron = Color(0xFFE97824);
  static const saffronDark = Color(0xFFC85E16);
  static const saffronLight = Color(0xFFFFF1E7);
  static const green = Color(0xFF173F35);
  static const greenDark = Color(0xFF173F35);
  static const greenLight = Color(0xFFEAF3EF);
  static const whatsapp = Color(0xFF25D366);
  static const navy = greenDark;
  static const navyText = Color(0xFF18211E);
  static const blue = greenDark;
  static const purple = greenDark;
  static const surface = Color(0xFFFAFBF9);
  static const card = Colors.white;
  static const border = Color(0xFFE2E8E5);
  static const textPrimary = Color(0xFF18211E);
  static const textSecondary = Color(0xFF68736F);
  static const textMuted = Color(0xFF8B9692);
  static const danger = Color(0xFFC93D3D);
  static const heritageGold = greenDark;
  static const heritageBrown = greenDark;
}

class AppShadows {
  AppShadows._();

  static const subtle = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F173F35),
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];
  static const prominent = <BoxShadow>[
    BoxShadow(
      color: Color(0x1C173F35),
      blurRadius: 40,
      offset: Offset(0, 16),
    ),
  ];
  static const floating = <BoxShadow>[
    BoxShadow(
      color: Color(0x26173F35),
      blurRadius: 26,
      offset: Offset(0, 10),
    ),
  ];
}

class AppMotion {
  AppMotion._();

  static const quick = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 220);
  static const reveal = Duration(milliseconds: 420);
  static const curve = Curves.easeOutCubic;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.saffron,
        primary: AppColors.greenDark,
        secondary: AppColors.saffron,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.surface,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
        fontFamily: 'NotoSansDevanagari',
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.greenDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.saffron, width: 1.6),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navyText,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.saffronDark),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        selectedColor: AppColors.saffronLight,
        checkmarkColor: AppColors.saffronDark,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.saffron,
        indicatorColor: AppColors.saffron,
        unselectedLabelColor: AppColors.textSecondary,
      ),
    );
  }
}
