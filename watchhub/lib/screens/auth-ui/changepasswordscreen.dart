import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/provider/signinprovider.dart';

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();

  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signinProvider = Provider.of<Signinprovider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Enter new password",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: signinProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => signinProvider.changePassword(
                          context, newPasswordController.text.trim()),
                      child: const Text("Change Password"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
