// ignore_for_file: use_build_context_synchronously

import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String usernameError = "";
  String passwordError = "";
  bool obscureText = true;
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  void toggleObscure() {
    obscureText = !obscureText;
    notifyListeners();
  }

  bool formValidate() {
    // Reset errors first
    usernameError = "";
    passwordError = "";
    
    bool isValid = true;

    if (usernameController.text.isEmpty) {
      usernameError = "Username is required";
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError = "Password is required";
      isValid = false;
    }
    
    notifyListeners();
    return isValid;
  }

  Future<void> adminLogin(BuildContext context) async {
    if(!formValidate()){
        return;
      }

    isLoading = true;
    notifyListeners();

    try {
      final res = await supabase.auth.signInWithPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
        // final Session? session = res.session;
        final User? user = res.user;
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}