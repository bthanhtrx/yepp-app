import 'package:flutter/material.dart';

import 'app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(width: 3, color: color));

  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColorDark,
      appBarTheme: const AppBarTheme(
          backgroundColor: AppPallete.backgroundColorDark,
          iconTheme: IconThemeData(color: Colors.white)),
      chipTheme: const ChipThemeData(
          color: MaterialStatePropertyAll(AppPallete.backgroundColorDark),
          side: BorderSide.none),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          focusedBorder: _border(AppPallete.gradient2),
          enabledBorder: _border(),
          border: _border(AppPallete.errorColor),
          errorBorder: _border(AppPallete.errorColor)));

  static final lightThemeMode = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColorLight,
      appBarTheme: const AppBarTheme(
          backgroundColor: AppPallete.backgroundColorLight,
          iconTheme: IconThemeData(color: Colors.black)),
      chipTheme: const ChipThemeData(
          color: MaterialStatePropertyAll(AppPallete.backgroundColorDark),
          side: BorderSide.none),
      textTheme: TextTheme(
              titleLarge: TextStyle(color: Colors.cyan),
              titleMedium: TextStyle(color: Colors.yellow))
          .apply(),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          focusedBorder: _border(AppPallete.gradient2),
          enabledBorder: _border(),
          border: _border(AppPallete.errorColor),
          errorBorder: _border(AppPallete.errorColor)));
}
