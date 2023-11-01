// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_shop_admin_panel/commonWidgets/horizontal_spacing_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/screens/editProductScreen/edit_product_screen.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:daily_shop_admin_panel/services/global_service.dart';
import 'package:flutter/material.dart';

class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({super.key, required this.productId});

  final String productId;

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  String title = '';
  String categoryName = '';
  String? imageUrl;
  String originalPrice = "0.0";
  double offerPrice = 0.0;
  bool isOnOffer = false;
  bool isPiece = false;

  @override
  void initState() {
    super.initState();
    getProductInformation();
  }

  //* to get the user details
  Future<void> getProductInformation() async {
    try {
      final DocumentSnapshot productData = await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.productId)
          .get();
      if (productData == null) {
        return;
      } else {
        setState(() {
          title = productData.get('title');
          categoryName = productData.get('categoryName');
          imageUrl = productData.get('imageUrl');
          originalPrice = productData.get('originalPrice');
          offerPrice = productData.get('offerPrice');
          isOnOffer = productData.get('isOnOffer');
          isPiece = productData.get('isPiece');
        });
      }
    } catch (error) {
      GlobalServices.instance.errorDailogue(context, error.toString());
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EditProductScreen(
                  id: widget.productId,
                  imageUrl: imageUrl == null
                      ? "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                      : imageUrl!,
                  title: title,
                  price: originalPrice,
                  offerPrice: offerPrice,
                  isOnOffer: isOnOffer,
                  isPiece: isPiece,
                  productCategory: categoryName,
                );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: NetworkImage(imageUrl == null
                            ? "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                            : imageUrl!),
                        width: 230,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {},
                        value: 1,
                        child: const Text('Edit'),
                      ),
                      PopupMenuItem(
                        onTap: () {},
                        value: 2,
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const VerticalSpacingWidget(height: 5),
              Row(
                children: [
                  Text(
                    isOnOffer
                        ? "₹${offerPrice.toStringAsFixed(2)}"
                        : "₹$originalPrice",
                    style: AppTextStyle.instance.mainTextStyle(
                        fSize: 16,
                        fWeight: FontWeight.bold,
                        color: GetColorThemeService(context).headingTextColor),
                  ),
                  const HorizontalSpacingWidget(width: 7),
                  Visibility(
                    visible: isOnOffer,
                    child: Text(
                      originalPrice,
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: GetColorThemeService(context).textColor),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isPiece ? "Piece" : "1Kg",
                    style: AppTextStyle.instance.mainTextStyle(
                        fSize: 15,
                        fWeight: FontWeight.bold,
                        color: GetColorThemeService(context).textColor),
                  )
                ],
              ),
              const VerticalSpacingWidget(height: 10),
              Text(
                title,
                style: AppTextStyle.instance.mainTextStyle(
                    fSize: 17,
                    fWeight: FontWeight.w500,
                    color: GetColorThemeService(context).textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
