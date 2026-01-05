import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String labelText;
  const CustomInput({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
