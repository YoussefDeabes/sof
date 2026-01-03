import 'package:flutter/material.dart';
import 'package:sof/core/res/const_colors.dart';

class AppTheme {
  final Locale locale;

  const AppTheme(this.locale);

  ThemeData get themeDataLight {
    return ThemeData(
      useMaterial3: true,
      fontFamily: locale.languageCode == "ar" ? "Dubai" : 'Manrope',
      scaffoldBackgroundColor: ConstColors.scaffoldBackground,
      colorScheme: ColorScheme.light(
        primary: ConstColors.app,
        onPrimary: ConstColors.white,
        surface: ConstColors.white,
        onSurface: ConstColors.text,
        background: ConstColors.scaffoldBackground,
        onBackground: ConstColors.text,
        error: ConstColors.error,
        onError: ConstColors.white,
        outline: ConstColors.greyD0,
      ),
    );
  }

  ThemeData get themeDataDark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: locale.languageCode == "ar" ? "Dubai" : 'Manrope',
      scaffoldBackgroundColor: ConstColors.appDark,
      colorScheme: ColorScheme.dark(
        primary: ConstColors.app,
        onPrimary: ConstColors.white,
        surface: ConstColors.appDarkerShade,
        onSurface: ConstColors.white,
        background: ConstColors.appDark,
        onBackground: ConstColors.white,
        error: ConstColors.error,
        onError: ConstColors.white,
        outline: ConstColors.grey6D,
      ),
    );
  }
}

