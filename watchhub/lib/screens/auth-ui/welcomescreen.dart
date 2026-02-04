// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watchhub/utils/app_routes.dart';
import '../../utils/appconstant.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appconstant.appmaincolor,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Appconstant.appmaincolor,
              child: Center(
                child: Image.asset(
                  'assets/images/mainlogo.png',
                  width: 350,
                  height: 400,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Appconstant.appmaincolor, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "🛍️ Happy Shopping with Watch Hub",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                  const SizedBox(height: 20),

                 
                  TextButton.icon(
                    icon: Image.asset(
                      'assets/images/googlelog.png',
                      width: 22,
                      height: 22,
                    ),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Appconstant.barcolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      minimumSize:
                          Size(Get.width / 1.7, Get.height / 14),
                    ),
                  ),

                  const SizedBox(height: 16),

                
                  TextButton.icon(
                    icon: Image.asset(
                      'assets/images/email.png',
                      width: 22,
                      height: 22,
                    ),
                    label: const Text(
                      "Sign in with Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signinRoute );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Appconstant.barcolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      minimumSize:
                          Size(Get.width / 1.7, Get.height / 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
