import 'package:daily_shop_admin_panel/commonWidgets/common_button_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/custom_drawer_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/header_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/responsive_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:daily_shop_admin_panel/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final priceController = TextEditingController();

  void validationForAddProduct() {
    final isValid = formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MainController>().getAddProductscaffoldKey,
      drawer: const CustomDrawerWidget(),
      body: Row(
        children: [
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
              child: Column(
                children: [
                  HeaderWidget(
                      itInAddProductScreen: true,
                      function: () {
                        context.read<MainController>().controlAddProductsMenu();
                      },
                      title: "Add Product"),
                  const VerticalSpacingWidget(height: 20),
                  //! product add box
                  Container(
                    width: size.width > 650 ? 650 : size.width,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue[100],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Product Title*",
                            style: AppTextStyle.instance.mainTextStyle(
                              fSize: 16,
                              fWeight: FontWeight.w600,
                              color: GetColorThemeService(context)
                                  .headingTextColor,
                            ),
                          ),
                          const VerticalSpacingWidget(height: 10),
                          TextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.name,
                            cursorColor:
                                GetColorThemeService(context).headingTextColor,
                            key: const ValueKey(
                              "Title",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter the title";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GetColorThemeService(context)
                                        .headingTextColor,
                                    width: 1.0),
                              ),
                            ),
                          ),
                          const VerticalSpacingWidget(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: FittedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price in ₹*",
                                        style:
                                            AppTextStyle.instance.mainTextStyle(
                                          fSize: 16,
                                          fWeight: FontWeight.w600,
                                          color: GetColorThemeService(context)
                                              .headingTextColor,
                                        ),
                                      ),
                                      const VerticalSpacingWidget(height: 10),
                                      SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          controller: priceController,
                                          keyboardType: TextInputType.number,
                                          cursorColor:
                                              GetColorThemeService(context)
                                                  .headingTextColor,
                                          key: const ValueKey("Price"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter the price";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GetColorThemeService(
                                                          context)
                                                      .headingTextColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const VerticalSpacingWidget(height: 20),
                                      const Text("Product Category*"),
                                      const VerticalSpacingWidget(height: 10),
                                      //* drop down menu
                                      const VerticalSpacingWidget(height: 20),
                                      const Text("Measure Unit*"),
                                      const VerticalSpacingWidget(height: 10),
                                      //* radio button
                                      const VerticalSpacingWidget(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(color: redColor),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Clear",
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
                                                  fSize: 18,
                                                  fWeight: FontWeight.w600,
                                                  color: redColor),
                                        ),
                                      ),
                                      const VerticalSpacingWidget(height: 5),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Update image",
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
                                                  fSize: 18,
                                                  fWeight: FontWeight.w600,
                                                  color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const VerticalSpacingWidget(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonButtonWidget(
                                  height: 50,
                                  width: 100,
                                  title: "Clear",
                                  onPressedFunction: () {},
                                  icon: IconlyBold.danger,
                                  buttonColor: redColor),
                              CommonButtonWidget(
                                  height: 45,
                                  width: 110,
                                  title: "Upload",
                                  onPressedFunction: () {
                                    validationForAddProduct();
                                  },
                                  icon: IconlyBold.upload,
                                  buttonColor: greenColor)
                            ],
                          ),
                          const VerticalSpacingWidget(height: 30)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    priceController.dispose();
  }
}
