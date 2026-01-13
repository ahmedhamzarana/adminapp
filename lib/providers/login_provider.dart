// ignore_for_file: use_build_context_synchronously
import 'package:adminapp/utils/app_colors.dart';
import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FlutterSecureStorage storage = FlutterSecureStorage();
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
    if (!formValidate()) {
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await supabase.auth.signInWithPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      storage.write(key: "useremail", value: usernameController.text);
      isLoading = false;
      notifyListeners();
      usernameController.text = "";
      passwordController.text = "";
      // final Session? session = res.session;
      // final User? user = res.user;
      Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login SuccessFully"),
          backgroundColor: AppColors.success,
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An unexpected error occurred"),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
