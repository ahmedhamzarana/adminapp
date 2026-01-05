// ignore_for_file: use_build_context_synchronously
import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier{
  void splashTimer(BuildContext context){
    Future.delayed(Duration(seconds: 3),() => Navigator.pushReplacementNamed(context, AppRoutes.loginRoute));
  }
}