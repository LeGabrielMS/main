import 'package:flutter/material.dart';
import 'package:main/themes/theme.dart';

class ThemeProvider with ChangeNotifier {
  // Default = Light Mode
  ThemeData _themeData = lightMode;

  // Getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  // Getter method to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

  // Setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle Switch
  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }
}
