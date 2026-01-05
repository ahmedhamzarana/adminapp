import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
  }
}
