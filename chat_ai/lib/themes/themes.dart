import 'package:flutter/material.dart';
class Themes {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: Colors.deepPurple,
    ),
  ).copyWith(primaryColor:  Colors.blueGrey,
  scaffoldBackgroundColor: const Color(0xFFF2F4F7));
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
       primary: Color(0xFF5081FF),
    )).copyWith(primaryColor: const Color(0xFF5081FF));
}