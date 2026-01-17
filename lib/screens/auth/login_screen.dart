import 'package:adminapp/providers/auth/login_provider.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(100),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 70,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 15),

                const Text(
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),

                const SizedBox(height: 30),

                // Username
                TextField(
                  controller: authProvider.usernameController,
                  style: const TextStyle(color: AppColors.bgcolor),
                  cursorColor: AppColors.secondary,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: const TextStyle(color: AppColors.secondary),
                    errorText: authProvider.usernameError,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: AppColors.secondary,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.secondary),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                TextField(
                  controller: authProvider.passwordController,
                  obscureText: authProvider.obscureText,
                  style: const TextStyle(color: AppColors.bgcolor),
                  cursorColor: AppColors.secondary,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: AppColors.secondary),
                    errorText: authProvider.passwordError,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColors.secondary,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: authProvider.toggleObscure,
                      child: Icon(
                        authProvider.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.secondary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.secondary),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: authProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.success,
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            context.read<LoginProvider>().adminLogin(context);
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: AppColors.bgcolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
