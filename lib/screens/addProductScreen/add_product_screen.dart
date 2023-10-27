// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_shop_admin_panel/commonWidgets/common_button_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/custom_drawer_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/header_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/loading_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/responsive_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:daily_shop_admin_panel/services/global_service.dart';
import 'package:daily_shop_admin_panel/services/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  bool isPiece = false;
  File? pickedMobileImage;
  Uint8List pickedWebImage = Uint8List(8);
  bool isLoading = false;

  //* add product
  void addProductToDatabase() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formKey.currentState!.save();
      if (pickedMobileImage == null) {
        GlobalServices.instance.errorDailogue(context, "Please pick an image");
        return;
      }
      final uuid = const Uuid().v4();
      try {
        setState(() {
          isLoading = true;
        });
        //* to add image to storage
        final firebaseStorage = FirebaseStorage.instance
            .ref()
            .child('productImages')
            .child('$uuid.jpg');
        if (kIsWeb) {
          await firebaseStorage.putData(pickedWebImage);
        } else {
          await firebaseStorage.putFile(pickedMobileImage!);
        }
        String imageUrl = await firebaseStorage.getDownloadURL();
        //* to add product to firestore
        await FirebaseFirestore.instance.collection('products').doc(uuid).set({
          'id': uuid,
          'title': titleController.text,
          'originalPrice': priceController.text,
          'offerPrice': 0.1,
          'imageUrl': imageUrl.toString(),
          'categoryName': categoryDropDownValue,
          'isOnOffer': false,
          'isPiece': isPiece,
          'createdAt': Timestamp.now()
        });
        clearProduct();
        Fluttertoast.showToast(
            msg: "Product uploaded succesfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade600,
            textColor: whiteColor,
            fontSize: 16);
      } on FirebaseException catch (firebaseError) {
        GlobalServices.instance
            .errorDailogue(context, firebaseError.message.toString());
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        GlobalServices.instance.errorDailogue(context, error.toString());
        setState(() {
          isLoading = false;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //* to clear products
  void clearProduct() {
    titleController.clear();
    priceController.clear();
    isPiece = false;
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
      body: LoadingWidget(
        isLoading: isLoading,
        child: Row(
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
                          context
                              .read<MainController>()
                              .controlAddProductsMenu();
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
                              cursorColor: GetColorThemeService(context)
                                  .headingTextColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //! price add
                                        Text(
                                          "Price in ₹*",
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
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
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
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
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
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
                                                  isPiece = false;
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
                                                  isPiece = true;
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                      addProductToDatabase();
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
            DropdownMenuItem(value: "Fruits", child: Text("Fruits")),
            DropdownMenuItem(value: "Nuts", child: Text("Grains")),
            DropdownMenuItem(value: "Grains", child: Text("Nuts")),
            DropdownMenuItem(value: "Dairy", child: Text("Dairy")),
            DropdownMenuItem(value: "Bread & baked goods", child: Text("Bread & baked goods")),
            DropdownMenuItem(value: "Meat & Fish", child: Text("Meat & Fish")),
            DropdownMenuItem(value: "Sauces & Condiments", child: Text("Sauces & Condiments")),
            DropdownMenuItem(value: "Herbs & Spices", child: Text("Herbs & Spices")),
            DropdownMenuItem(value: "Frozen foods", child: Text("Frozen foods")),
            DropdownMenuItem(value: "Snacks", child: Text("Snacks")),
            DropdownMenuItem(value: "Drinks", child: Text("Drinks")),
            DropdownMenuItem(value: "Household & cleaning", child: Text("Household & cleaning")),
            DropdownMenuItem(value: "Personal care", child: Text("Personal care")),
            DropdownMenuItem(value: "Pet care", child: Text("Pet care")),
            DropdownMenuItem(value: "Baby products", child: Text("Baby products")),
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
