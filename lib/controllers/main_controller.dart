import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _dashBoardScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _producScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _orderScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addProductScaffoldKey =
      GlobalKey<ScaffoldState>();

  //* Getters
  //* this is used to identify the screen in this project they multiple dashboard screens
  GlobalKey<ScaffoldState> get getDashBoardScaffoldKey => _dashBoardScaffoldKey;
  GlobalKey<ScaffoldState> get getProductScaffoldKey => _producScaffoldKey;
  GlobalKey<ScaffoldState> get getOrderScaffoldKey => _orderScaffoldKey;
  GlobalKey<ScaffoldState> get getAddProductscaffoldKey =>
      _addProductScaffoldKey;

  //* for dashboard
  void controlDashboarkMenu() {
    if (!_dashBoardScaffoldKey.currentState!.isDrawerOpen) {
      _dashBoardScaffoldKey.currentState!.openDrawer();
    }
  }

  //* for all products
  void controlAllProductsMenu() {
    if (!getProductScaffoldKey.currentState!.isDrawerOpen) {
      getProductScaffoldKey.currentState!.openDrawer();
    }
  }

  //* for all orders
  void controlAllOrdersMenu() {
    if (!_orderScaffoldKey.currentState!.isDrawerOpen) {
      _orderScaffoldKey.currentState!.openDrawer();
    }
  }

  //* for add product
  void controlAddProductsMenu() {
    if (!_addProductScaffoldKey.currentState!.isDrawerOpen) {
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }
}
