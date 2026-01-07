import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String labelText;
  final String? description; // optional
  final int maxLines;
  final String errorText;
  final TextEditingController? controller;

  const CustomInput({
    super.key,
    required this.labelText,
    this.description,
    this.maxLines = 1,
    required this.controller,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: AppColors.secondary),
        labelText: labelText,
        errorText: errorText,
        helperText: description, // shown only if not null
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
      ),
    );
  }
}
