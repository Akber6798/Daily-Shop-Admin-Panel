import 'package:daily_shop_admin_panel/screens/widget/order_product_widget.dart';
import 'package:flutter/material.dart';

class OrderProductListing extends StatelessWidget {
  const OrderProductListing({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: ((context, index) {
        return const Column(
          children: [
            OrderProductWidget(),
          ],
        );
      }),
      separatorBuilder: ((context, index) => const Divider(thickness: 3)),
    );
  }
}
