import 'package:adminapp/screens/dashboard/add_product.dart';
import 'package:adminapp/screens/home_screen.dart';
import 'package:adminapp/screens/login_screen.dart';
import 'package:adminapp/screens/splash_screen.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String homeRoute = "/home";
  static const String addProductRoute = "/addproduct";

  static Map<String, WidgetBuilder> routes = {
    splashRoute: (context) => SplashScreen(),
    loginRoute: (context) => LoginScreen(),
    homeRoute: (context) => HomeScreen(),
    addProductRoute: (context) => AddProduct(),
  };
}