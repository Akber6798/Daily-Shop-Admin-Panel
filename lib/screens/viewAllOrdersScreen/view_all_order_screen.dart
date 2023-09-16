import 'package:daily_shop_admin_panel/commonWidgets/custom_drawer_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/header_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/responsive_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/screens/widget/order_product_listing_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllOrderScreen extends StatelessWidget {
  const ViewAllOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MainController>().getOrderScaffoldKey,
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
            Expanded(
              //* It takes 5/6 part of the screen
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      HeaderWidget(
                        title: "All Orders",
                        function: () {
                          context.read<MainController>().controlAllOrdersMenu();
                        },
                      ),
                      const VerticalSpacingWidget(height: 20),
                      const OrderProductListing()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
