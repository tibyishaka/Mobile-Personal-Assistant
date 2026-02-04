import 'package:flutter/material.dart';

class AppColors {
  static const aluBlue = Color.fromRGBO(0, 46, 109, 1);
  static const aluRed = Color(0xFFDC3545);
  static const white = Colors.white;
  static const grey = Color(0xFF6C757D);
  static const lightGrey = Color(0xFFF8F9FA);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.aluBlue,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.light(
        primary: AppColors.aluBlue,
        secondary: AppColors.aluRed,
        surface: AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.aluBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.aluBlue,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.aluRed,
        foregroundColor: AppColors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
