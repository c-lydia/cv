import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  void toggle() {
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }
}
