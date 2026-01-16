import 'package:adminapp/models/product_model.dart';
import 'package:adminapp/providers/products/edit_product_provider.dart';
import 'package:adminapp/reusable/custom_input.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProductEditDialog extends StatefulWidget {
  final Product product; // Add product parameter

  const ProductEditDialog({super.key, required this.product});

  @override
  State<ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  @override
  void initState() {
    super.initState();
    // Initialize provider with existing product data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditProductProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final proProvider = Provider.of<EditProductProvider>(context);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Container(
          width: 630,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark.withAlpha(15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: const Text(
                  "Edit Product",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              /// 🔹 Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Image",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: proProvider.selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(proProvider.selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : (proProvider.existingImageUrl != null &&
                                    proProvider.existingImageUrl!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    proProvider.existingImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, e, s) =>
                                        const Icon(Icons.broken_image),
                                  ),
                                )
                              : const Icon(
                                  Icons.image_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: proProvider.pickImage,
                          icon: const Icon(Icons.upload),
                          label: const Text("Upload Image"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proNamecontroller,
                            labelText: "Product Name",
                            errorText: proProvider.proNameerror,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proBrandcontroller,
                            labelText: "Brand",
                            errorText: proProvider.proBranderror,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proPricecontroller,
                            labelText: "Price",
                            errorText: proProvider.proPriceerror,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proStockcontroller,
                            labelText: "Stock Quantity",
                            errorText: proProvider.proStockerror,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    CustomInput(
                      controller: proProvider.proDescriptioncontroller,
                      labelText: "Product Description",
                      maxLines: 4,
                      errorText: proProvider.proDescriptionerror,
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: proProvider.isLoading
                              ? null
                              : () async {
                                  if (proProvider.proValidateform(context)) {
                                    bool success = await proProvider
                                        .updateProduct();
                                    if (context.mounted && success) {
                                      Navigator.pop(context, true);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: proProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Update Product",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                        ),
                      ],
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
