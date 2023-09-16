import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/screens/widget/product_card_widget.dart';
import 'package:flutter/material.dart';

class ProductGridViewWidget extends StatelessWidget {
  const ProductGridViewWidget(
      {super.key, this.crossAxisCount = 4, this.childAspectRatio = 1,required this.isInTheMain});

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInTheMain;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: isInTheMain ? 4 :20,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: defaultPadding,
          crossAxisSpacing: defaultPadding,
        ),
        itemBuilder: (context, index) {
          return const ProductCardWidget();
        });
  }
}
