import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _gridScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addProductScaffoldKey =
      GlobalKey<ScaffoldState>();

  //* Getters
  GlobalKey<ScaffoldState> get getScaffoldKey =>
      _scaffoldKey; // this is used to identify the screen in this project they multiple dashboard screens
  GlobalKey<ScaffoldState> get getgridscaffoldKey => _gridScaffoldKey;
  GlobalKey<ScaffoldState> get getAddProductscaffoldKey =>
      _addProductScaffoldKey;

  //* Callbacks
  void controlDashboarkMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  // void controlProductsMenu() {
  //   if (!_gridScaffoldKey.currentState!.isDrawerOpen) {
  //     _gridScaffoldKey.currentState!.openDrawer();
  //   }
  // }

  // void controlAddProductsMenu() {
  //   if (!_addProductScaffoldKey.currentState!.isDrawerOpen) {
  //     _addProductScaffoldKey.currentState!.openDrawer();
  //   }
  // }
}
