import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:flutter/material.dart';

class ThemeStyle {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
          isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      cardColor: isDarkTheme ? darkCardColor : lightCardColor,
      //* icon color
      iconTheme:
          IconThemeData(color: isDarkTheme ? darkIconsColor : lightIconsColor),
      //* text color
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: isDarkTheme ? darkTextColor : lightTextColor,
            displayColor: isDarkTheme ? darkTextColor : lightTextColor,
          ),
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: isDarkTheme ? darkIconsColor : lightIconsColor,
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      //* appbar
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        iconTheme:
            IconThemeData(color: GetColorThemeService(context).iconColor),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: AppTextStyle.instance.mainTextStyle(
            fSize: 23,
            fWeight: FontWeight.w600,
            color: GetColorThemeService(context).headingTextColor),
      ),
    );
  }
}