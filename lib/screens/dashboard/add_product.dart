import 'package:adminapp/providers/add_product_provider.dart';
import 'package:adminapp/reusable/custom_input.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final proProvider = Provider.of<AddProductProvider>(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                color: AppColors.primary,
                child: const Text(
                  "Add New Product",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            /// Form Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Image Section
                  const Text(
                    "Product Image",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                          border: Border.all(color: Colors.grey.withAlpha(80)),
                          image: proProvider.selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(proProvider.selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: proProvider.selectedImage == null
                            ? const Icon(
                                Icons.image_outlined,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Yahan function call karein
                          proProvider.pickImage();
                        },
                        icon: const Icon(
                          Icons.upload,
                          color: AppColors.secondary,
                        ),
                        label: const Text(
                          "Upload Image",
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// Product Name & Category
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
                          controller: proProvider.proCategorycontroller,
                          labelText: "Category",
                          errorText: proProvider.proCategoryerror,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Price & Stock
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
                          controller: proProvider.pronStockcontroller,
                          labelText: "Stock Quantity",
                          errorText: proProvider.proStockerror,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Description
                  CustomInput(
                    controller: proProvider.proDescriptioncontroller,
                    labelText: "Product Description",
                    maxLines: 4,
                    errorText: proProvider.proDescriptionerror,
                  ),

                  const SizedBox(height: 32),

                  /// Improved Button UI
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        bool isValid = proProvider.proValidateform(context);
                        if (isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product added successfully!"),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 22,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Add Product",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppColors.primary,
                        elevation: 6,
                        shadowColor: AppColors.primary.withAlpha(100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
