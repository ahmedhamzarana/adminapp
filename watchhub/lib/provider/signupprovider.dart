import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/utils/app_routes.dart';

class Signupprovider extends ChangeNotifier {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  final supabase = Supabase.instance.client;
  bool isLoading = false;

  // Form validation
  bool formValidate(BuildContext context) {
    final nameRegex = RegExp(r'^[a-zA-Z]+$'); // Only alphabets

    if (usernamecontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name is required"), backgroundColor: Colors.red),
      );
      return false;
    } else if (!nameRegex.hasMatch(usernamecontroller.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name must contain only letters"), backgroundColor: Colors.red),
      );
      return false;
    }

    if (emailcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email is required"), backgroundColor: Colors.red),
      );
      return false;
    }

    if (passwordcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password is required"), backgroundColor: Colors.red),
      );
      return false;
    }

    return true;
  }

  // Sign Up
  Future<void> signUp(BuildContext context) async {
    if (!formValidate(context)) return;

    isLoading = true;
    notifyListeners();

    try {
      // Check duplicate email
      final existing = await supabase
          .from("tbl_users")
          .select()
          .eq("email", emailcontroller.text.trim())
          .limit(1);

      if (existing.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email already registered"), backgroundColor: Colors.red),
        );
        isLoading = false;
        notifyListeners();
        return;
      }

      // Register user
      final response = await supabase.auth.signUp(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create account"), backgroundColor: Colors.red),
        );
        return;
      }

      // Add to tbl_users
      await supabase.from("tbl_users").insert({
        "user_id": user.id,
        "name": usernamecontroller.text.trim(),
        "email": emailcontroller.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!"), backgroundColor: Colors.green),
      );

      usernamecontroller.clear();
      emailcontroller.clear();
      passwordcontroller.clear();

      Navigator.pushReplacementNamed(context, AppRoutes.signinRoute);

    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong"), backgroundColor: Colors.red),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
