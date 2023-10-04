import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/screens/viewAllProductScreen/widget/product_card_widget.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:flutter/material.dart';

class ProductGridViewWidget extends StatelessWidget {
  const ProductGridViewWidget(
      {super.key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      required this.isInTheMain});

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInTheMain;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return snapshot.data!.docs.isEmpty
                  ? Center(
                      child: Text(
                        "You didnot add any product yet",
                        style: AppTextStyle.instance.mainTextStyle(
                            fSize: 18,
                            fWeight: FontWeight.w700,
                            color: GetColorThemeService(context).headingTextColor),
                      ),
                    )
                  : GridView.builder(
                      itemCount: isInTheMain && snapshot.data!.docs.length > 4
                          ? 4
                          : snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCardWidget(
                          productId: snapshot.data!.docs[index]["id"],
                        );
                      });
            } else {
              return Center(
                child: Text(
                  "Your store is empty",
                  style: AppTextStyle.instance.mainTextStyle(
                      fSize: 18,
                      fWeight: FontWeight.w700,
                      color: GetColorThemeService(context).headingTextColor),
                ),
              );
            }
          }
          return Center(
            child: Text(
              "Something went wrong",
              style: AppTextStyle.instance.mainTextStyle(
                  fSize: 18,
                  fWeight: FontWeight.w700,
                  color: GetColorThemeService(context).headingTextColor),
            ),
          );
        });
  }
}
