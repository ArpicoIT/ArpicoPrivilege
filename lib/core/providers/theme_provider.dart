import 'package:arpicoprivilege/app/app_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() : _themeMode = ThemeMode.light;

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  Color _seedColor = AppTheme.primaryColor;
  Color get seedColor => _seedColor;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     // statusBarColor: _themeMode == ThemeMode.light ? Colors.green : Colors.red,
    //     statusBarColor: Colors.grey,
    //     statusBarIconBrightness: _themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
    //     statusBarBrightness: _themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
    //   ),
    // );

    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void setSeedColor(Color seedColor) {
    _seedColor = seedColor;
    notifyListeners();
  }

  void updateThemeBasedOnSystem(Brightness brightness) {
    final newThemeMode = (brightness == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
    (_themeMode != newThemeMode) ? setTheme(newThemeMode) : null;

    print(
        (_themeMode != newThemeMode) ? "Theme changed" : "Theme not changed"
    );
  }

}
