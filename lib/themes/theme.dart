import 'package:flutter/material.dart';

// Light Mode
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      surface: Colors.grey.shade300,
      primary: Colors.grey.shade200,
      secondary: Colors.grey.shade400,
      inversePrimary: Colors.grey.shade800),
);

// Dark Mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
      inversePrimary: Colors.grey.shade300),
);

// Colors
const tdRed = Color(0xFFDA4040);
const tdBlue = Color(0xFF5F52EE);

const tdBlack = Color(0xFF3A3A3A);
const tdGrey = Color(0xFF717171);

const tdBGColor = Color(0xFFEEEFC5);
