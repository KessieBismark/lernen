import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = ThemeData.light();
  bool _isDarkTheme = false;

  ThemeData get theme => _theme;
  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadThemeFromPrefs(); // Load theme on app startup
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _theme = _isDarkTheme ? ThemeData.dark() : ThemeData.light();
    _saveThemeToPrefs(); // Save theme to SharedPreferences
    notifyListeners();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _theme = _isDarkTheme ? ThemeData.dark() : ThemeData.light();
    notifyListeners(); // Notify listeners to rebuild UI with loaded theme
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
  }
}
