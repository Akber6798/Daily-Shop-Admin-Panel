import 'package:daily_shop_admin_panel/consts/theme_style.dart';
import 'package:daily_shop_admin_panel/controllers/main_controller.dart';
import 'package:daily_shop_admin_panel/controllers/theme_controller.dart';
import 'package:daily_shop_admin_panel/screens/main_control_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBNWPM79qFb0EK4c_H24cSuUzf3Zeqtb5I",
        appId: "1:58854265954:web:7d53de0a8eeb090b91ad3b",
        messagingSenderId: "58854265954",
        projectId: "daily-shop-cc247",
        storageBucket: "daily-shop-cc247.appspot.com",
        ),
        
  );
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
        ChangeNotifierProvider(create: (_) => MainController())
      ],
      child: Consumer<ThemeController>(
        builder: (context, newTheme, child) {
          return MaterialApp(
            theme: ThemeStyle.themeData(newTheme.darkTheme, context),
            debugShowCheckedModeBanner: false,
            home: const MainControlScreen(),
          );
        },
      ),
    );
  }
}
