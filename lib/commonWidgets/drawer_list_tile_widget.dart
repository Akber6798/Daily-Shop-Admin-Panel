import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:flutter/material.dart';

class DrawerListTileWidget extends StatelessWidget {
  const DrawerListTileWidget(
      {super.key,
      required this.title,
      required this.pressFunction,
      required this.icon});

  final String title;
  final VoidCallback pressFunction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: pressFunction,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        size: 18,
        color: GetColorThemeService(context).headingTextColor,
      ),
      title: Text(
        title,
        style: AppTextStyle().mainTextStyle(
            fSize: 13,
            fWeight: FontWeight.w500,
            color: GetColorThemeService(context).textColor),
      ),
    );
  }
}
