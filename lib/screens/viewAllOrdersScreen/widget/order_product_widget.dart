import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_shop_admin_panel/commonWidgets/horizontal_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:daily_shop_admin_panel/services/utils.dart';
import 'package:flutter/material.dart';

class OrderProductWidget extends StatefulWidget {
  const OrderProductWidget(
      {super.key,
      required this.price,
      required this.totalPrice,
      required this.productId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.quantity,
      required this.orderDate});

  final double price, totalPrice;
  final String productId, userId, imageUrl, userName;
  final int quantity;
  final Timestamp orderDate;

  @override
  State<OrderProductWidget> createState() => _OrderProductWidgetState();
}

class _OrderProductWidgetState extends State<OrderProductWidget> {
  late String orderDateToShow;

  @override
  void initState() {
    super.initState();
    var date = widget.orderDate.toDate();
    orderDateToShow = "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: size.width < 650 ? 3 : 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const HorizontalSpacingWidget(width: 12),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${widget.quantity}x For ₹ ${widget.price.toStringAsFixed(2)}",
                  style: AppTextStyle.instance.mainTextStyle(
                      fSize: 14,
                      fWeight: FontWeight.w500,
                      color: GetColorThemeService(context).headingTextColor),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Text(
                        "By ",
                        style: AppTextStyle.instance.mainTextStyle(
                            fSize: 13,
                            fWeight: FontWeight.w500,
                            color: Colors.blue),
                      ),
                      Text(
                        widget.userName,
                        style: AppTextStyle.instance.mainTextStyle(
                            fSize: 12,
                            fWeight: FontWeight.w500,
                            color: GetColorThemeService(context).textColor),
                      ),
                    ],
                  ),
                ),
                Text(
                  orderDateToShow,
                  style: AppTextStyle.instance.mainTextStyle(
                      fSize: 10,
                      fWeight: FontWeight.w500,
                      color: GetColorThemeService(context).textColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
