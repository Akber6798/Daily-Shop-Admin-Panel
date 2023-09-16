import 'package:daily_shop_admin_panel/commonWidgets/horizontal_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:daily_shop_admin_panel/services/utils.dart';
import 'package:flutter/material.dart';

class OrderProductWidget extends StatelessWidget {
  const OrderProductWidget({super.key});

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
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(
                    "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"),
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
                  "10x For ₹ 600",
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
                        "Akber A A",
                        style: AppTextStyle.instance.mainTextStyle(
                            fSize: 12,
                            fWeight: FontWeight.w500,
                            color: GetColorThemeService(context).textColor),
                      ),
                    ],
                  ),
                ),
                Text(
                  "03/07/2023",
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
