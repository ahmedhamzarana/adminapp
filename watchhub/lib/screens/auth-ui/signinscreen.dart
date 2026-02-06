import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/provider/signinprovider.dart';
import 'package:watchhub/utils/app_routes.dart';
import 'package:watchhub/utils/appconstant.dart';

class Signinscreen extends StatelessWidget {
  const Signinscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signinProvider = Provider.of<Signinprovider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Appconstant.appmaincolor, Color(0xFF004D2A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or App Icon Space
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(38),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withAlpha(76), width: 2),
                      ),
                      child: const Icon(
                        Icons.watch_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Welcome Text
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        color: Colors.white.withAlpha(204),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withAlpha(51)),
                      ),
                      child: TextField(
                        controller: signinProvider.emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white.withAlpha(204)),
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: Colors.white.withAlpha(127)),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.white.withAlpha(204)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withAlpha(51)),
                      ),
                      child: TextField(
                        controller: signinProvider.passwordcontroller,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white.withAlpha(204)),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: Colors.white.withAlpha(127)),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withAlpha(204)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => signinProvider.resetPassword(context),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.white.withAlpha(229),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: signinProvider.isLoading
                          ? Container(
                              decoration: BoxDecoration(
                                color: Appconstant.barcolor.withAlpha(204),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () => signinProvider.login(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Appconstant.barcolor,
                                elevation: 5,
                                shadowColor: Colors.black.withAlpha(76),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 25),
                    
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white.withAlpha(204),
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.signupRoute),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}