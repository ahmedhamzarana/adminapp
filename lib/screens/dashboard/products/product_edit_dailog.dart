import 'dart:io';
import 'package:adminapp/models/product_model.dart';
import 'package:adminapp/providers/products/edit_product_provider.dart';
import 'package:adminapp/widget/custom_input.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductEditDialog extends StatefulWidget {
  final Product product;
  const ProductEditDialog({super.key, required this.product});

  @override
  State<ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditProductProvider>(context, listen: false)
          .initializeProduct(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final proProvider = Provider.of<EditProductProvider>(context);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: SingleChildScrollView(
        child: Container(
          width: 630,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: const Text(
                  "Edit Product",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Image Section
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: proProvider.selectedImage != null
                                ? (kIsWeb
                                    ? Image.network(
                                        proProvider.selectedImage!.path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(proProvider.selectedImage!.path),
                                        fit: BoxFit.cover,
                                      ))
                                : Image.network(
                                    proProvider.existingImageUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) =>
                                        const Icon(Icons.image),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: proProvider.pickImage,
                          child: const Text("Change Image"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Product Name & Brand Dropdown
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proNamecontroller,
                            labelText: "Product Name",
                            errorText: proProvider.proNameerror,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: proProvider.selectedBrand?.brandName,
                            decoration: InputDecoration(
                              labelText: "Select Brand",
                              errorText: proProvider.proBranderror.isEmpty
                                  ? null
                                  : proProvider.proBranderror,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            items: proProvider.brandList.map((brand) {
                              return DropdownMenuItem<String>(
                                value: brand.brandName,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          brand.brandImgUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.image,
                                                size: 14);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(brand.brandName),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              final brand = proProvider.brandList
                                  .firstWhere((b) => b.brandName == value);
                              proProvider.setSelectedBrand(brand);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Price & Stock
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proPricecontroller,
                            labelText: "Price",
                            errorText: proProvider.proPriceerror,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proStockcontroller,
                            labelText: "Stock",
                            errorText: proProvider.proStockerror,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Description Field
                    CustomInput(
                      controller: proProvider.proDescriptioncontroller,
                      labelText: "Product Description",
                      maxLines: 3,
                      errorText: proProvider.proDescriptionerror,
                    ),

                    const SizedBox(height: 30),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: proProvider.isLoading
                              ? null
                              : () async {
                                  if (proProvider.proValidateform()) {
                                    bool success =
                                        await proProvider.updateProduct();
                                    if (context.mounted && success) {
                                      Navigator.pop(context, true);
                                    }
                                  }
                                },
                          child: proProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Update Product",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}