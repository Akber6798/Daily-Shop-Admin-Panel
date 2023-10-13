// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_shop_admin_panel/commonWidgets/common_button_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/custom_drawer_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/horizontal_spacing_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/loading_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:daily_shop_admin_panel/services/global_service.dart';
import 'package:daily_shop_admin_panel/services/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.price,
      required this.productCategory,
      required this.imageUrl,
      required this.isPiece,
      required this.isOnOffer,
      required this.offerPrice});

  final String id, title, price, productCategory, imageUrl;
  final bool isPiece, isOnOffer;
  final double offerPrice;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController editTitleController;
  late final TextEditingController editPriceController;
  String? offerPercentage;
  late String percentageToShow;
  late String editCategoryDropDownValue;
  late bool isOnOffer;
  late double offerPrice;
  late bool isPiece;
  late int quantityValue;
  late String imageUrl;
  int editRadioGroupValue = 1;
  File? editPickedMobileImage;
  Uint8List editPickedWebImage = Uint8List(8);
  bool isLoading = false;

  //* update product
  void editProductToDatabase() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formKey.currentState!.save();
      try {
        String? editImageUrl;
        setState(() {
          isLoading = true;
        });
        //* to add image to storage
        if (editPickedMobileImage != null) {
          final firebaseStorage = FirebaseStorage.instance
              .ref()
              .child('productImages')
              .child('${widget.id}.jpg');
          if (kIsWeb) {
            await firebaseStorage.putData(editPickedWebImage);
          } else {
            await firebaseStorage.putFile(editPickedMobileImage!);
          }
          editImageUrl = await firebaseStorage.getDownloadURL();
        }
        //* to add product to firestore
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update({
          'title': editTitleController.text,
          'originalPrice': editPriceController.text,
          'offerPrice': offerPrice,
          'imageUrl':
              editPickedMobileImage == null ? widget.imageUrl : editImageUrl,
          'categoryName': editCategoryDropDownValue,
          'isOnOffer': isOnOffer,
          'isPiece': isPiece,
        });
        await Fluttertoast.showToast(
            msg: "Product has been updated",
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

  @override
  void initState() {
    super.initState();
    editTitleController = TextEditingController(text: widget.title);
    editPriceController = TextEditingController(text: widget.price);
    editCategoryDropDownValue = widget.productCategory;
    isOnOffer = widget.isOnOffer;
    isPiece = widget.isPiece;
    offerPrice = widget.offerPrice;
    quantityValue = isPiece ? 2 : 1;
    imageUrl = widget.imageUrl;
    //* calculate the percentage
    percentageToShow =
        "${(100 - (offerPrice * 100) / double.parse(widget.price)).round().toStringAsFixed(1)}%";
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      // key: context.read<MainController>().getEditProductscaffoldKey,
      // drawer: const CustomDrawerWidget(),
      body: LoadingWidget(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // HeaderWidget(
                //     itInAddProductScreen: true,
                //     function: () {
                //       context
                //           .read<MainController>()
                //           .controlAddProductsMenu();
                //     },
                //     title: "Edit Product"),
                const VerticalSpacingWidget(height: 20),
                //! Edit product box
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
                        //! title
                        Text(
                          "Product Title*",
                          style: AppTextStyle.instance.mainTextStyle(
                            fSize: 15,
                            fWeight: FontWeight.w500,
                            color:
                                GetColorThemeService(context).headingTextColor,
                          ),
                        ),
                        const VerticalSpacingWidget(height: 10),
                        TextFormField(
                          controller: editTitleController,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //! price
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
                                        controller: editPriceController,
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
                                    //! category
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
                                    editCategoryDropDownButton(),
                                    const VerticalSpacingWidget(height: 20),
                                    //! unit =(kg or piece)
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
                                          groupValue: editRadioGroupValue,
                                          onChanged: (newValue) {
                                            setState(() {
                                              editRadioGroupValue = 1;
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
                                          groupValue: editRadioGroupValue,
                                          onChanged: (newValue) {
                                            setState(() {
                                              editRadioGroupValue = 2;
                                              isPiece = true;
                                            });
                                          },
                                          activeColor:
                                              GetColorThemeService(context)
                                                  .headingTextColor,
                                        )
                                      ],
                                    ),
                                    const VerticalSpacingWidget(height: 10),
                                    //! check box for offer
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: isOnOffer,
                                            onChanged: (newValue) {
                                              setState(() {
                                                isOnOffer = newValue!;
                                              });
                                            }),
                                        const HorizontalSpacingWidget(width: 5),
                                        Text(
                                          "Offer",
                                          style: AppTextStyle.instance
                                              .mainTextStyle(
                                                  fSize: 10,
                                                  fWeight: FontWeight.w500,
                                                  color: GetColorThemeService(
                                                          context)
                                                      .textColor),
                                        ),
                                      ],
                                    ),
                                    const VerticalSpacingWidget(height: 10),
                                    //! offer
                                    AnimatedSwitcher(
                                      duration: const Duration(seconds: 1),
                                      child: !isOnOffer
                                          ? Container()
                                          : Row(
                                              children: [
                                                Text(
                                                  "₹${offerPrice.toStringAsFixed(2)}",
                                                  style: AppTextStyle.instance
                                                      .mainTextStyle(
                                                    fSize: 12,
                                                    fWeight: FontWeight.w500,
                                                    color: GetColorThemeService(
                                                            context)
                                                        .textColor,
                                                  ),
                                                ),
                                                const HorizontalSpacingWidget(
                                                    width: 10),
                                                offerPercentageDropDownButton()
                                              ],
                                            ),
                                    )
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: editPickedMobileImage == null
                                          ? Image.network(imageUrl)
                                          : kIsWeb
                                              ? Image.memory(
                                                  editPickedWebImage,
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.file(
                                                  editPickedMobileImage!,
                                                  fit: BoxFit.fill),
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Update image",
                                    style: AppTextStyle.instance.mainTextStyle(
                                        fSize: 26,
                                        fWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const VerticalSpacingWidget(height: 20),
                        //! delete and update
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CommonButtonWidget(
                                height: 50,
                                width: 100,
                                title: "Delete",
                                onPressedFunction: () {
                                  GlobalServices.instance.closingDailogue(
                                      context,
                                      "Delete?",
                                      "Press okey to confirm", () async {
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(widget.id)
                                        .delete();
                                    await Fluttertoast.showToast(
                                        msg: "Product has been deleted",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey.shade600,
                                        textColor: whiteColor,
                                        fontSize: 16);
                                    while (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                icon: IconlyBold.danger,
                                buttonColor: redColor),
                            CommonButtonWidget(
                                height: 45,
                                width: 110,
                                title: "Update",
                                onPressedFunction: () {
                                  editProductToDatabase();
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
          editPickedMobileImage = selectedImage;
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
          editPickedWebImage = finalWebImage;
          editPickedMobileImage = File("a"); // to avoid null error
        });
      } else {
        print("No image is picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  //! for dropdown for category
  Widget editCategoryDropDownButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: AppTextStyle.instance.mainTextStyle(
              fSize: 15, fWeight: FontWeight.w500, color: redColor),
          onChanged: (newValue) {
            setState(() {
              editCategoryDropDownValue = newValue!;
            });
          },
          value: editCategoryDropDownValue,
          hint: const Text("Select a category"),
          items: const [
            DropdownMenuItem(value: "Vegetables", child: Text("Vegetables")),
            DropdownMenuItem(value: "Fruits", child: Text("Fruits")),
            DropdownMenuItem(value: "Grains", child: Text("Grains")),
            DropdownMenuItem(value: "Nuts", child: Text("Nuts")),
            DropdownMenuItem(value: "Herbs", child: Text("Herbs")),
            DropdownMenuItem(value: "Spices", child: Text("Spices")),
          ],
        ),
      ),
    );
  }

  //! for select the percentage
  DropdownButtonHideUnderline offerPercentageDropDownButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        style: AppTextStyle.instance.mainTextStyle(
            fSize: 15, fWeight: FontWeight.w500, color: redColor),
        items: const [
          DropdownMenuItem(
            value: "0",
            child: Text("0%"),
          ),
          DropdownMenuItem(
            value: "10",
            child: Text("10%"),
          ),
          DropdownMenuItem(
            value: "15",
            child: Text("15%"),
          ),
          DropdownMenuItem(
            value: "25",
            child: Text("25%"),
          ),
          DropdownMenuItem(
            value: "50",
            child: Text("50%"),
          ),
          DropdownMenuItem(
            value: "75",
            child: Text("75%"),
          ),
        ],
        onChanged: (newValue) {
          if (newValue == "0") {
            return;
          } else {
            setState(() {
              offerPercentage = newValue;
              //* calculation of offer price
              offerPrice = double.parse(widget.price) -
                  (double.parse(newValue!) * double.parse(widget.price) / 100);
            });
          }
        },
        hint: Text(offerPercentage ?? percentageToShow),
        value: offerPercentage,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    editTitleController.dispose();
    editPriceController.dispose();
  }
}
