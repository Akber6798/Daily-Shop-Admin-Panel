import 'package:daily_shop_admin_panel/commonWidgets/header_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const VerticalSpacingWidget(height: 10),
          HeaderWidget(
            function: () {
              context.read<MainController>().controlDashboarkMenu();
            },
          ),
          VerticalSpacingWidget(height: 20),
        ],
      ),
    ));
  }
}
