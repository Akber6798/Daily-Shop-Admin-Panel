import 'package:daily_shop_admin_panel/commonWidgets/custom_drawer_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/header_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/responsive_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/screens/viewAllProductScreen/widget/product_grid_view_widget.dart';
import 'package:daily_shop_admin_panel/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllProductScreen extends StatelessWidget {
  const ViewAllProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MainController>().getProductScaffoldKey,
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      HeaderWidget(
                        title: "All Products",
                        function: () {
                          context.read<MainController>().controlAllProductsMenu();
                        },
                      ),
                      const VerticalSpacingWidget(height: 20),
                      ResponsiveWidget(
                        mobile: ProductGridViewWidget(
                          isInTheMain: false,
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductGridViewWidget(
                          isInTheMain: false,
                          childAspectRatio: size.width < 1400 ? 1.02 : 1.08,
                        ),
                      )
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
