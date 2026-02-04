import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/provider/profileprovider.dart';
import 'package:watchhub/utils/app_routes.dart';

class Signinprovider extends ChangeNotifier {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final supabase = Supabase.instance.client;
  bool isLoading = false;

  // FORM VALIDATION
  bool formvalidate(BuildContext context) {
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

  // LOGIN
  Future<void> login(BuildContext context) async {
    if (!formvalidate(context)) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password"), backgroundColor: Colors.red),
        );
        isLoading = false;
        notifyListeners();
        return;
      }

      // Check if user exists in tbl_users
      final existing = await supabase
          .from("tbl_users")
          .select()
          .eq("user_id", user.id)
          .limit(1);

      if (existing.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found in database"), backgroundColor: Colors.red),
        );
        isLoading = false;
        notifyListeners();
        return;
      }

      // Save email locally
      await storage.write(key: "useremail", value: emailcontroller.text.trim());

      // Clear fields
      emailcontroller.clear();
      passwordcontroller.clear();

      // Navigate to Home
      Navigator.pushReplacementNamed(context, AppRoutes.homeroute);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!"), backgroundColor: Colors.green),
      );
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

  // RESET PASSWORD (FORGOT PASSWORD)
  Future<void> resetPassword(BuildContext context) async {
    final email = emailcontroller.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email"), backgroundColor: Colors.red),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await supabase.auth.resetPasswordForEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset email sent! Check your inbox."),
          backgroundColor: Colors.green,
        ),
      );
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

  // CHANGE PASSWORD (LOGGED-IN USER)
  Future<void> changePassword(BuildContext context, String newPassword) async {
    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password cannot be empty"), backgroundColor: Colors.red),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!"), backgroundColor: Colors.green),
      );
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

  // LOGOUT
  Future<void> logout(BuildContext context) async {
    // Get the ProfileProvider instance from the global scope and call its logout method
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.logout(context);

    Navigator.pushReplacementNamed(context, AppRoutes.signinRoute);
  }
}
