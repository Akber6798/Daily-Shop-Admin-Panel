import 'package:daily_shop_admin_panel/services/theme_service.dart';
import 'package:flutter/material.dart';

class ThemeController with ChangeNotifier {
  
  ThemeService themeService = ThemeService();

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  //* set dark theme
  set setDarkTheme(bool value) {
    _darkTheme = value;
    themeService.setDarkTheme(value);
    notifyListeners();
  }
}