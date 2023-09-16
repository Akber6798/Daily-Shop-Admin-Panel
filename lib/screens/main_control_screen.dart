import 'package:daily_shop_admin_panel/commonWidgets/custom_drawer_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/responsive_widget.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/screens/dashBoardScreen/dash_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainControlScreen extends StatelessWidget {
  const MainControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MainController>().getDashBoardScaffoldKey,
      drawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* We want this side menu only for large screen
            if (ResponsiveWidget.isDesktop(context))
              const Expanded(
                //* default flex = 1
                //* and it takes 1/6 part of the screen
                child: CustomDrawerWidget(),
              ),
            const Expanded(
              //* It takes 5/6 part of the screen
              flex: 5,
              child: DashBoardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
