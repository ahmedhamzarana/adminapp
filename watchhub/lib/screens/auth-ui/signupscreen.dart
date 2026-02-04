import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/provider/signupprovider.dart';
import 'package:watchhub/utils/app_routes.dart';
import 'package:watchhub/utils/constants.dart';
import 'package:watchhub/utils/appconstant.dart';

class Signupscreen extends StatelessWidget {
  const Signupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<Signupprovider>(context);

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
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
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
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 35),
                    
                    // Name Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: TextField(
                        controller: signupProvider.usernamecontroller,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          hintText: "Enter your name",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: TextField(
                        controller: signupProvider.emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.white.withOpacity(0.8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: TextField(
                        controller: signupProvider.passwordcontroller,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: signupProvider.isLoading
                          ? Container(
                              decoration: BoxDecoration(
                                color: Appconstant.barcolor.withOpacity(0.8),
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
                              onPressed: () => signupProvider.signUp(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Appconstant.barcolor,
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "SIGN UP",
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
                    
                    // Sign In Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.signinRoute),
                          child: const Text(
                            "Sign In",
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