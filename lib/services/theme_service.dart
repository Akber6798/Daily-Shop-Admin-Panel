// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class ThemeService{

  static const THEME_STATUS = "THEMESTATUS";

  //* set theme in sharredprefernce
  setDarkTheme(bool value) async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    prefer.setBool(THEME_STATUS, value);
  }

  //* get theme from sharredprefernce
  Future<bool> getTheme() async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    return prefer.getBool(THEME_STATUS) ?? false;
  }
}