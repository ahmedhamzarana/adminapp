import 'package:adminapp/models/brand_model.dart';
import 'package:adminapp/providers/products/add_product_provider.dart';
import 'package:adminapp/widget/custom_input.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddProductProvider>(context, listen: false).fetchBrands();
    });
  }

  @override
  Widget build(BuildContext context) {
    final proProvider = Provider.of<AddProductProvider>(context);

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
              // Header
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
                    Text(
                      "Add New Product",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel, color: AppColors.dark),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Image",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: proProvider.proImageerror.isEmpty
                                  ? Colors.grey.shade300
                                  : Colors.red,
                            ),
                          ),
                          child: proProvider.selectedImageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    proProvider.selectedImageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: proProvider.pickImage,
                          child: const Text("Select Image"),
                        ),
                      ],
                    ),

                    if (proProvider.proImageerror.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          proProvider.proImageerror,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proNamecontroller,
                            labelText: "Product Name",
                            errorText: proProvider.proNameerror,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: DropdownButtonFormField<Brand>(
                            value: proProvider.selectedBrand,
                            decoration: InputDecoration(
                              labelText: "Brand",
                              errorText: proProvider.proBranderror.isEmpty
                                  ? null
                                  : proProvider.proBranderror,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: proProvider.brandList
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b,
                                    child: Text(b.brandName),
                                  ),
                                )
                                .toList(),
                            onChanged: proProvider.setSelectedBrand,
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
                            labelText: "Price (Rs)",
                            errorText: proProvider.proPriceerror,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proStockcontroller,
                            labelText: "Stock",
                            errorText: proProvider.proStockerror,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    CustomInput(
                      controller: proProvider.proDescriptioncontroller,
                      labelText: "Description",
                      maxLines: 3,
                      errorText: proProvider.proDescriptionerror,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                        onPressed: proProvider.isLoading
                            ? null
                            : () async {
                                if (proProvider.proValidateform()) {
                                  final success = await proProvider
                                      .addProduct();
                                  if (success && context.mounted) {
                                    proProvider.clearForm();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Product Added"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                }
                              },
                        child: proProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "ADD PRODUCT",
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
