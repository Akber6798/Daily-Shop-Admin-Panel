import 'package:daily_shop_admin_panel/commonWidgets/horizontal_spacing_widget.dart';
import 'package:daily_shop_admin_panel/commonWidgets/vertical_spacing_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {},
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
                  const Flexible(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: NetworkImage(
                            "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"),
                        width: 180,
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
                    "₹ 60",
                    style: AppTextStyle.instance.mainTextStyle(
                        fSize: 16,
                        fWeight: FontWeight.bold,
                        color: GetColorThemeService(context).headingTextColor),
                  ),
                  const HorizontalSpacingWidget(width: 7),
                  Visibility(
                    visible: true,
                    child: Text(
                      '100',
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: GetColorThemeService(context).textColor),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "1Kg",
                    style: AppTextStyle.instance.mainTextStyle(
                        fSize: 15,
                        fWeight: FontWeight.bold,
                        color: GetColorThemeService(context).textColor),
                  )
                ],
              ),
              const VerticalSpacingWidget(height: 10),
              Text(
                "Title",
                style: AppTextStyle.instance.mainTextStyle(
                    fSize: 17,
                    fWeight: FontWeight.w500,
                    color: GetColorThemeService(context).textColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
