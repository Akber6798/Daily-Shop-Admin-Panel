import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/screens/viewAllOrdersScreen/widget/order_product_widget.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:flutter/material.dart';

class OrderProductListing extends StatelessWidget {
  const OrderProductListing({super.key, this.isInDashboard = false});

  final bool isInDashboard;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
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
                        "There is no Orders",
                        style: AppTextStyle.instance.mainTextStyle(
                            fSize: 18,
                            fWeight: FontWeight.w700,
                            color:
                                GetColorThemeService(context).headingTextColor),
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: isInDashboard && snapshot.data!.docs.length > 5
                          ? 5
                          : snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            OrderProductWidget(
                              imageUrl: snapshot.data!.docs[index]["imageUrl"],
                              orderDate: snapshot.data!.docs[index]
                                  ["orderDate"],
                              price: snapshot.data!.docs[index]["price"],
                              productId: snapshot.data!.docs[index]
                                  ["productId"],
                              quantity: snapshot.data!.docs[index]["quantity"],
                              totalPrice: snapshot.data!.docs[index]
                                  ["totalPrice"],
                              userId: snapshot.data!.docs[index]["userId"],
                              userName: snapshot.data!.docs[index]["userName"],
                            ),
                          ],
                        );
                      }),
                      separatorBuilder: ((context, index) =>
                          const Divider(thickness: 3)),
                    );
            } else {
              return Center(
                child: Text(
                  "Your Odres are empty",
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
