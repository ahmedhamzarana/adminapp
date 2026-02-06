// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  bool _isInitialized = false;

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final supabase = Supabase.instance.client;

  // Initialize user data from Supabase
  Future<void> initializeUserData() async {
    if (_isInitialized) return; // Prevent multiple initializations

    _isInitialized = true;
    isLoading = true;
    notifyListeners();

    try {
      final userEmail = await storage.read(key: "useremail");
      if (userEmail != null && userEmail.isNotEmpty) {
        final response = await supabase
            .from('tbl_users')
            .select('name, email')
            .eq('email', userEmail)
            .single();

        if (response != null) {
          nameController.text = response['name']?.toString() ?? '';
          emailController.text = response['email']?.toString() ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      _isInitialized = false; // Reset flag on error to allow retry
    }

    isLoading = false;
    notifyListeners();
  }

  // Method to reset initialization flag (for when user logs out/in)
  void resetInitialization() {
    _isInitialized = false;
  }

  // Save Profile
  Future<void> saveProfile(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final userEmail = await storage.read(key: "useremail");
      if (userEmail != null && userEmail.isNotEmpty) {
        // Validate that the name is not empty
        if (nameController.text.trim().isEmpty) {
          throw Exception("Name cannot be empty");
        }

        // Validate that the email is valid
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(emailController.text.trim())) {
          throw Exception("Invalid email format");
        }

        await supabase
            .from('tbl_users')
            .update({
              'name': nameController.text.trim(),
              'email': emailController.text.trim(),
            })
            .eq('email', userEmail);

        // Update the stored email if it was changed
        if (emailController.text.trim() != userEmail) {
          await storage.write(key: "useremail", value: emailController.text.trim());
        }

        // Update the initialization flag so data reloads properly
        resetInitialization();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to the profile screen
        Navigator.pop(context); // Pop the edit screen
      } else {
        throw Exception("No user email found");
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating profile: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Logout logic (without context)
  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await storage.delete(key: "useremail");
    await supabase.auth.signOut();
    resetInitialization(); // Reset initialization flag on logout

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
