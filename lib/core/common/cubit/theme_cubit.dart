
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/core/shared_pref.dart';
import 'package:yepp/core/theme/theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightThemeMode) {
    _getCurrentTheme();
  }

  bool get isDarkMode => state == AppTheme.darkThemeMode;

  Future<void> _getCurrentTheme() async {
    final isDarkMode = await SharedPref.instance.isDarkMode;
    emit(isDarkMode ? AppTheme.darkThemeMode : AppTheme.lightThemeMode);
  }

  Future<void> changeTheme({required bool isDarkMode}) async {
    await SharedPref.instance.setDarkMode(isDarkMode);
    emit(isDarkMode ? AppTheme.darkThemeMode : AppTheme.lightThemeMode);
  }

  Future<bool> getIsDarkMode() async {
    final isDark = await SharedPref.instance.isDarkMode;
    return isDark;
  }
}
