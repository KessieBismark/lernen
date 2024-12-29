import 'package:flutter/material.dart';

import '../shared_pref.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = ThemeData.light();
  bool _isDarkTheme = false;

  ThemeData get theme => _theme;
  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _theme = _isDarkTheme ? ThemeData.dark() : ThemeData.light();
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Future<void> _loadThemeFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  //   _theme = _isDarkTheme ? ThemeData.dark() : ThemeData.light();
  //   notifyListeners();
  // }

  // Future<void> _saveThemeToPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isDarkTheme', _isDarkTheme);
  // }

  Future<void> _saveThemeToPrefs() async {
    await SharedPreferencesUtil.saveBoolean('isDarkTheme', _isDarkTheme);
  }

  Future<void> _loadThemeFromPrefs() async {
    final ativeTheme = await SharedPreferencesUtil.getBoolean('isDarkTheme');
    _isDarkTheme = ativeTheme ;
    _theme = _isDarkTheme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
