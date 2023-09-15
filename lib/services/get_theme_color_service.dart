
import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetColorThemeService {
  // get colors as per the theme

  BuildContext context;

  GetColorThemeService(this.context);

  //* get theme
  bool get getTheme => Provider.of<ThemeController>(context).darkTheme;

  //* get heading text color
  Color get headingTextColor =>
      getTheme ? darkMainTextColor : lightMainTextColor;

  //* get text color
  Color get textColor => getTheme ? darkTextColor : lightTextColor;

  //* get icon color
  Color get iconColor => getTheme ? darkIconsColor : lightIconsColor;
}