import 'package:daily_shop_admin_panel/commonWidgets/common_button_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/header_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/responsive_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/screens/addProductScreen/add_product_screen.dart';
import 'package:daily_shop_admin_panel/screens/viewAllOrdersScreen/widget/order_product_listing_widget.dart';
import 'package:daily_shop_admin_panel/screens/viewAllProductScreen/widget/product_grid_view_widget.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:daily_shop_admin_panel/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpacingWidget(height: 10),
              HeaderWidget(
                title: "Dashboard",
                function: () {
                  context.read<MainController>().controlDashboarkMenu();
                },
              ),
              const VerticalSpacingWidget(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Latest products",
                  style: AppTextStyle.instance.mainTextStyle(
                      fSize: 15,
                      fWeight: FontWeight.w600,
                      color: GetColorThemeService(context).textColor),
                ),
              ),
              const VerticalSpacingWidget(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonButtonWidget(
                      height: 50,
                      width: 130,
                      title: "View All",
                      icon: Icons.store,
                      buttonColor: greenColor,
                      onPressedFunction: () {}),
                  CommonButtonWidget(
                      height: 50,
                      width: 130,
                      title: "Add New",
                      icon: Icons.add,
                      buttonColor: greenColor,
                      onPressedFunction: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AddProductScreen();
                            },
                          ),
                        );
                      })
                ],
              ),
              const VerticalSpacingWidget(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ResponsiveWidget(
                          mobile: ProductGridViewWidget(
                            isInTheMain: true,
                            crossAxisCount: size.width < 650 ? 2 : 4,
                            childAspectRatio:
                                size.width < 650 && size.width > 350
                                    ? 1.1
                                    : 0.8,
                          ),
                          desktop: ProductGridViewWidget(
                            isInTheMain: true,
                            childAspectRatio: size.width < 1400 ? 1.02 : 1.08,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const VerticalSpacingWidget(height: 20),
              Text(
                "Resent Order",
                style: AppTextStyle.instance.mainTextStyle(
                    fSize: 16,
                    fWeight: FontWeight.w600,
                    color: GetColorThemeService(context).headingTextColor),
              ),
              const VerticalSpacingWidget(height: 20),
              const OrderProductListing()
            ],
          ),
        ),
      ),
    );
  }
}
