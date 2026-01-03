import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sof/core/util/bloc/language/language_cubit.dart';
import 'package:sof/core/util/helpers/route_manager.dart';
import 'dart:ui' as ui;

// Manages font weight for every type of the font family.
class FontWeightManager {
  static const FontWeight light = FontWeight.w200;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight black = FontWeight.w900;
}

// Manages font sizes all around the application.
class FontSize {
  static const double superTiny = 10;
  static const double tinyText = 12;
  static const double smallText = 13;
  static const double kindaSmall = 14;
  static const double regular = 15;
  static const double medium = 16;
  static const double subTitle = 18;
  static const double title = 20;
  static const double kindaHuge = 23.0;
  static const double huge = 25.0;
}

TextStyle _getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  double? height,
  TextDecoration? decoration,
  FontStyle? fontStyle,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    fontFamily: getFontFamily(),
    color: color,
    letterSpacing: 0,
    decoration: decoration,
    height: height,
    fontStyle: fontStyle,
  );
}

String getFontFamily() {
  try {
    if (navigatorKey.currentContext != null) {
      final lang = navigatorKey.currentContext
          ?.read<LanguageCubit>()
          .state
          .languageCode;
      return lang == "ar" ? "Dubai" : "Manrope";
    }
  } catch (_) {}

  final currentLang = ui.PlatformDispatcher.instance.locale.languageCode;
  return currentLang == "ar" ? "Dubai" : "Manrope";
}

Color _defaultTextColor() {
  try {
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      return Theme.of(ctx).colorScheme.onSurface;
    }
  } catch (_) {}
  return Colors.black;
}

TextStyle getLightStyle({
  double fontSize = FontSize.smallText,
  Color? color,
  TextDecoration? decoration,
  double? height,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? _defaultTextColor(),
    fontWeight: FontWeightManager.light,
    decoration: decoration,
    height: height,
  );
}

TextStyle getMediumStyle({
  double fontSize = FontSize.regular,
  Color? color,
  TextDecoration? decoration,
  double? height,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? _defaultTextColor(),
    fontWeight: FontWeightManager.medium,
    decoration: decoration,
    height: height,
  );
}

TextStyle getRegularStyle({
  double fontSize = FontSize.kindaSmall,
  double? height,
  TextDecoration? decoration,
  Color? color,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? _defaultTextColor(),
    fontWeight: FontWeightManager.regular,
    decoration: decoration,
    height: height,
  );
}

TextStyle getSemiBoldStyle({
  double fontSize = FontSize.regular,
  Color? color,
  TextDecoration? decoration,
  double? height,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? _defaultTextColor(),
    fontWeight: FontWeightManager.semiBold,
    decoration: decoration,
    height: height,
  );
}

TextStyle getBoldStyle({
  double fontSize = FontSize.regular,
  Color? color,
  TextDecoration? decoration,
  double? height,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? _defaultTextColor(),
    fontWeight: FontWeightManager.bold,
    decoration: decoration,
    height: height,
  );
}

