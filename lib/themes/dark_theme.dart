import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary:  Color(0xFF121212),
    background: Colors.black,
    onBackground: Colors.white,
    secondary: Colors.grey[800]!, //border colors
    tertiary: Colors.black,//used for icons
  ),
);
