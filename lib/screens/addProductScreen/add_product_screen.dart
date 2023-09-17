import 'dart:io';

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
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
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
  String categoryDropDownValue = "Vegetables";
  int radioGroupValue = 1;
  bool inPiece = false;
  File? pickedMobileImage;
  Uint8List pickedWebImage = Uint8List(8);

  void validationForAddProduct() {
    final isValid = formKey.currentState!.validate();
  }

  void clearProduct() {
    titleController.clear();
    priceController.clear();
    inPiece = false;
    radioGroupValue = 1;
    categoryDropDownValue = "Vegetables";
    setState(() {
      pickedMobileImage = null;
      pickedWebImage = Uint8List(8);
    });
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
                          //! title add
                          Text(
                            "Product Title*",
                            style: AppTextStyle.instance.mainTextStyle(
                              fSize: 15,
                              fWeight: FontWeight.w500,
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
                                      //! price add
                                      Text(
                                        "Price in ₹*",
                                        style:
                                            AppTextStyle.instance.mainTextStyle(
                                          fSize: 15,
                                          fWeight: FontWeight.w500,
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
                                      //! select category
                                      Text(
                                        "Product Category*",
                                        style:
                                            AppTextStyle.instance.mainTextStyle(
                                          fSize: 15,
                                          fWeight: FontWeight.w500,
                                          color: GetColorThemeService(context)
                                              .headingTextColor,
                                        ),
                                      ),
                                      const VerticalSpacingWidget(height: 10),
                                      categoryDropDownButton(),
                                      const VerticalSpacingWidget(height: 20),
                                      //! select unit
                                      Text(
                                        "Measure Unit*",
                                        style:
                                            AppTextStyle.instance.mainTextStyle(
                                          fSize: 15,
                                          fWeight: FontWeight.w500,
                                          color: GetColorThemeService(context)
                                              .headingTextColor,
                                        ),
                                      ),
                                      const VerticalSpacingWidget(height: 10),
                                      Row(
                                        children: [
                                          const Text("KG"),
                                          Radio(
                                            value: 1,
                                            groupValue: radioGroupValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                radioGroupValue = 1;
                                                inPiece = false;
                                              });
                                            },
                                            activeColor:
                                                GetColorThemeService(context)
                                                    .headingTextColor,
                                          ),
                                          const Text("Piece"),
                                          Radio(
                                            value: 2,
                                            groupValue: radioGroupValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                radioGroupValue = 2;
                                                inPiece = true;
                                              });
                                            },
                                            activeColor:
                                                GetColorThemeService(context)
                                                    .headingTextColor,
                                          )
                                        ],
                                      ),
                                      const VerticalSpacingWidget(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                              //! select image
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: size.width > 650
                                          ? 350
                                          : size.width * 0.45,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: pickedMobileImage == null
                                          ? dottedBorderContainer()
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: kIsWeb
                                                  ? Image.memory(
                                                      pickedWebImage,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.file(
                                                      pickedMobileImage!,
                                                      fit: BoxFit.fill),
                                            )),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            pickedMobileImage = null;
                                            pickedWebImage = Uint8List(8);
                                          });
                                        },
                                        child: Text(
                                          "Clear image",
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
                                                  fSize: 26,
                                                  fWeight: FontWeight.bold,
                                                  color: redColor),
                                        ),
                                      ),
                                      const VerticalSpacingWidget(height: 40),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Update image",
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
                                                  fSize: 26,
                                                  fWeight: FontWeight.bold,
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
                                  onPressedFunction: () {
                                    clearProduct();
                                  },
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

  //! for select the image (need to check if mobile or web)
  Future<void> pickImage() async {
    if (!kIsWeb) {
      //* if mobile
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selectedImage = File(image.path);
        setState(() {
          pickedMobileImage = selectedImage;
        });
      } else {
        print("No image is picked");
      }
    } else if (kIsWeb) {
      //* if web
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var finalWebImage = await image.readAsBytes();
        setState(() {
          pickedWebImage = finalWebImage;
          pickedMobileImage = File("a"); // to avoid null error
        });
      } else {
        print("No image is picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  //! for dropdown
  Widget categoryDropDownButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: AppTextStyle.instance.mainTextStyle(
              fSize: 15, fWeight: FontWeight.w500, color: redColor),
          onChanged: (newValue) {
            setState(() {
              categoryDropDownValue = newValue!;
            });
          },
          value: categoryDropDownValue,
          hint: const Text("Select a category"),
          items: const [
            DropdownMenuItem(value: "Vegetables", child: Text("Vegetables")),
            DropdownMenuItem(value: "Fruites", child: Text("Fruites")),
            DropdownMenuItem(value: "Grains", child: Text("Grains")),
            DropdownMenuItem(value: "Nuts", child: Text("Nuts")),
            DropdownMenuItem(value: "Herbs", child: Text("Herbs")),
            DropdownMenuItem(value: "Spices", child: Text("Spices")),
          ],
        ),
      ),
    );
  }

  //! for dotborder
  Widget dottedBorderContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        dashPattern: const [6, 7],
        borderType: BorderType.RRect,
        color: GetColorThemeService(context).textColor,
        radius: const Radius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                color: GetColorThemeService(context).textColor,
                size: 150,
              ),
              TextButton(
                onPressed: () {
                  pickImage();
                },
                child: Text(
                  "Choose an image",
                  style: AppTextStyle.instance.mainTextStyle(
                      fSize: 18, fWeight: FontWeight.w600, color: Colors.blue),
                ),
              )
            ],
          ),
        ),
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
