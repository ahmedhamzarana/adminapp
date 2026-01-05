import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  String usernameerror = "";
  String passworderror = "";
  bool obsecureText = true;

  void toggleObsecure() {
    obsecureText = !obsecureText;
    notifyListeners();
  }

  bool formvalidate(BuildContext context) {
    bool isvalid = true;

    if (usernamecontroller.text.isEmpty) {
      usernameerror = "Username is required";
      isvalid = false;
    }
    if (passwordcontroller.text.isEmpty) {
      passworderror = "Password is required";
      isvalid = false;
    }
    notifyListeners();
    return isvalid;
  }
}
