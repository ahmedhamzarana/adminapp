// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:watchhub/utils/app_routes.dart';

class SplashProvider extends ChangeNotifier{

    void splashTimer(BuildContext context) async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    String? email = await storage.read(key: "useremail");

    Future.delayed(Duration(seconds: 3), () {
      if (email != null && email.isNotEmpty) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeroute);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.signinRoute);
      }
    });
  }
}

