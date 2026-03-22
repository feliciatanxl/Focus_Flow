import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // By default, the app starts in Light Mode
  ThemeMode themeMode = ThemeMode.light;

  // A quick way to check if we are in dark mode
  bool get isDarkMode => themeMode == ThemeMode.dark;

  // This is the function the switch will trigger
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    // THIS IS THE MAGIC LINE! It shouts to the whole app: "UPDATE YOUR COLORS!"
    notifyListeners();
  }
}