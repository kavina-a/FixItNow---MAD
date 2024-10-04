import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    onBackground: Colors.black,
    surface: Colors.transparent,
    secondary: Colors.grey[400]!, //border colors
    tertiary: Colors.white,
    primary: Colors.white// main color
  ),
);
