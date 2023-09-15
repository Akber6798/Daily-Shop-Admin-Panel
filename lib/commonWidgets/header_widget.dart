import 'package:daily_shop_admin_panel/commonWidgets/responsive_widget.dart';
import 'package:daily_shop_admin_panel/consts/app_colors.dart';
import 'package:daily_shop_admin_panel/consts/app_text_style.dart';
import 'package:daily_shop_admin_panel/services/get_theme_color_service.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.function});

  final Function function;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //* if its not desktop this function leads to open the drawer
        if (!ResponsiveWidget.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              function();
            },
          ),
        if (ResponsiveWidget.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Dashboard",
              style: AppTextStyle.instance.mainTextStyle(
                  fSize: 23,
                  fWeight: FontWeight.w600,
                  color: GetColorThemeService(context).headingTextColor),
            ),
          ),
        if (ResponsiveWidget.isDesktop(context))
          Spacer(flex: ResponsiveWidget.isDesktop(context) ? 2 : 1),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              fillColor: Theme.of(context).cardColor,
              filled: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              suffixIcon: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  margin: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
