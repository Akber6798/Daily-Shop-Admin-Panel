import 'package:daily_shop_admin_panel/consts/theme_style.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/controllers/theme_controller.dart';
import 'package:daily_shop_admin_panel/screens/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeController themeController = ThemeController();

//* get current theme
  void getCurrentAppTheme() async {
    themeController.setDarkTheme =
        await themeController.themeService.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeController),
        ChangeNotifierProvider(
          create: (_) => MainController(),
        )
      ],
      child: Consumer<ThemeController>(
        builder: (context, newTheme, child) {
          return MaterialApp(
            theme: ThemeStyle.themeData(newTheme.darkTheme, context),
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
