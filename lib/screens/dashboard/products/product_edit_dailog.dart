import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:adminapp/models/product_model.dart';
import 'package:adminapp/providers/products/edit_product_provider.dart';
import 'package:adminapp/widget/custom_input.dart';
import 'package:adminapp/utils/app_colors.dart';

class ProductEditDialog extends StatefulWidget {
  final Product product;
  const ProductEditDialog({super.key, required this.product});

  @override
  State<ProductEditDialog> createState() =>
      _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditProductProvider>(
        context,
        listen: false,
      ).initializeProduct(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProductProvider>(context);

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
              // HEADER
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: const Text(
                  "Edit Product",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // IMAGE
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: provider.selectedImage != null
                                ? (kIsWeb
                                    ? Image.network(
                                        provider.selectedImage!.path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(provider.selectedImage!.path),
                                        fit: BoxFit.cover,
                                      ))
                                : Image.network(
                                    provider.existingImageUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: provider.pickImage,
                          child: const Text("Change Image"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // NAME + BRAND
                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: provider.proNamecontroller,
                            labelText: "Product Name",
                            errorText: provider.proNameerror,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value:
                                provider.selectedBrand?.brandName,
                            decoration: InputDecoration(
                              labelText: "Select Brand",
                              errorText:
                                  provider.proBranderror.isEmpty
                                      ? null
                                      : provider.proBranderror,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8)),
                            ),
                            items: provider.brandList
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b.brandName,
                                    child: Text(b.brandName),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              final brand = provider.brandList
                                  .firstWhere(
                                      (b) => b.brandName == value);
                              provider.setSelectedBrand(brand);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // PRICE + STOCK
                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller:
                                provider.proPricecontroller,
                            labelText: "Price (PKR)",
                            errorText:
                                provider.proPriceerror,
                            keyboardType:
                                TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomInput(
                            controller:
                                provider.proStockcontroller,
                            labelText: "Stock",
                            errorText:
                                provider.proStockerror,
                            keyboardType:
                                TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // DESCRIPTION
                    CustomInput(
                      controller:
                          provider.proDescriptioncontroller,
                      labelText: "Description",
                      maxLines: 3,
                      errorText:
                          provider.proDescriptionerror,
                    ),

                    const SizedBox(height: 30),

                    // BUTTONS
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primary,
                          ),
                          onPressed: provider.isLoading
                              ? null
                              : () async {
                                  if (provider
                                      .proValidateform()) {
                                    final success =
                                        await provider
                                            .updateProduct();
                                    if (success &&
                                        context.mounted) {
                                      Navigator.pop(
                                          context, true);
                                    }
                                  }
                                },
                          child: provider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Update Product",
                                  style: TextStyle(
                                      color: Colors.white),
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
