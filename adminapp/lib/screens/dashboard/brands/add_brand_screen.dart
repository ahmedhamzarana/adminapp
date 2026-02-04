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

    return AlertDialog(
      backgroundColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: 630,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 HEADER (same as AddProduct)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add New Brand",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // 🔹 BODY
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Brand Logo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: brandProvider.imageError.isEmpty
                                    ? Colors.grey.shade300
                                    : Colors.red,
                              ),
                            ),
                            child: brandProvider.selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      brandProvider.selectedImage!.path,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 40,
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

                          ElevatedButton(
                            onPressed: brandProvider.pickImage,
                            child: const Text("Select Image"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    CustomInput(
                      controller: brandProvider.nameController,
                      labelText: "Brand Name",
                      errorText: brandProvider.nameError,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                        onPressed: brandProvider.isLoading
                            ? null
                            : () async {
                                if (brandProvider.validateBrandForm()) {
                                  final success = await brandProvider
                                      .addBrand();
                                  if (success && context.mounted) {
                                    brandProvider.clearForm();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Brand Added"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                }
                              },
                        child: brandProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "ADD BRAND",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
