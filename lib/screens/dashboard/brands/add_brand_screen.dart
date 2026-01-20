// lib/screens/dashboard/brands/add_brand_screen.dart
import 'package:adminapp/providers/brands/add_brand_provider.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:adminapp/widget/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBrandScreen extends StatelessWidget {
  const AddBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<AddBrandProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.branding_watermark,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Add New Brand",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Upload Brand Logo",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),

                // Image Preview Container
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: brandProvider.selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  brandProvider.selectedImage!.path,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                      ),
                      const SizedBox(height: 10),
                      if (brandProvider.imageError.isNotEmpty)
                        Text(
                          brandProvider.imageError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      TextButton.icon(
                        onPressed: () => brandProvider.pickImage(),
                        icon: const Icon(Icons.image),
                        label: const Text("Select From Gallery"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Name Input
                CustomInput(
                  controller: brandProvider.nameController,
                  labelText: "Brand Name",
                  errorText: brandProvider.nameError,
                ),

                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: brandProvider.isLoading
                        ? null
                        : () async {
                            if (brandProvider.validateBrandForm()) {
                              bool isDone = await brandProvider.addBrand();
                              if (isDone && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Success: Brand Added!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                brandProvider.clearForm();
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Error: Failed to save data"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: brandProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SAVE BRAND",
                            style: TextStyle(
                              color: Colors.white,
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
