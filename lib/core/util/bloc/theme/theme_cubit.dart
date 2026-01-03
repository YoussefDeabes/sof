import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void setLight() => emit(ThemeMode.light);
  void setDark() => emit(ThemeMode.dark);
  void toggle() =>
      emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final v = json['mode'] as String?;
    switch (v) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
    }
    return ThemeMode.light;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    final mode = state == ThemeMode.dark
        ? 'dark'
        : state == ThemeMode.light
        ? 'light'
        : 'system';
    return {'mode': mode};
  }
}

