import 'package:adminapp/providers/splash_provider.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context).splashTimer(context);
    return Scaffold(
      
      backgroundColor: AppColors.bgcolor,
      body: Center(
        child: Text("Admin", style: TextStyle(fontSize: 30, color: AppColors.dark),),
      ),
    );
  }
}