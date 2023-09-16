import 'package:daily_shop_admin_panel/commonWidgets/drawer_list_tile_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/controllers/theme_controller.dart';
import 'package:daily_shop_admin_panel/screens/main_control_screen.dart';
import 'package:daily_shop_admin_panel/screens/viewAllOrdersScreen/view_all_order_screen.dart';
import 'package:daily_shop_admin_panel/screens/viewAllProductScreen/view_all_product_screen.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeController>(context);
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Image(
              image: AssetImage("assets/logo.png"),
            ),
          ),
          DrawerListTileWidget(
              title: "Main",
              pressFunction: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MainControlScreen();
                    },
                  ),
                );
              },
              icon: IconlyBold.home),
          DrawerListTileWidget(
              title: "View all products",
              pressFunction: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ViewAllProductScreen();
                    },
                  ),
                );
              },
              icon: Icons.store),
          DrawerListTileWidget(
              title: "View all orders",
              pressFunction: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ViewAllOrderScreen();
                    },
                  ),
                );
              },
              icon: IconlyBold.bag_2),
          SwitchListTile(
              title: Text(
                "Dark Mode",
                style: AppTextStyle.instance.mainTextStyle(
                    fSize: 14,
                    fWeight: FontWeight.w400,
                    color: GetColorThemeService(context).textColor),
              ),
              secondary: Icon(
                themeState.darkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: Theme.of(context).iconTheme.color,
                size: 18,
              ),
              value: themeState.darkTheme,
              onChanged: (value) {
                themeState.setDarkTheme = value;
              }),
        ],
      ),
    );
  }
}
