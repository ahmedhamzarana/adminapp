import 'package:adminapp/models/brand_model.dart';
import 'package:adminapp/providers/products/add_product_provider.dart';
import 'package:adminapp/widget/custom_input.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Formatter ke liye
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

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
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
                child: const Text(
                  "Add New Product",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Image Section ---
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
                          onPressed: () => proProvider.pickImage(),
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

                    // --- Name & Brand ---
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.secondary,
                                ),
                              ),

                              // 🔹 FOCUSED BORDER
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.secondary,
                                  width: 2,
                                ),
                              ),

                              // 🔹 ERROR BORDER
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.secondary,
                                ),
                              ),

                              // 🔹 FOCUSED ERROR BORDER
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.secondary,
                                  width: 2,
                                ),
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
                            onChanged: (val) =>
                                proProvider.setSelectedBrand(val),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // --- Price & Stock ---
                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: proProvider.proPricecontroller,
                            labelText: "Price (Rs)",
                            errorText: proProvider.proPriceerror,
                            keyboardType: TextInputType.number,
                            // InputFormatter: User minus sign type hi nahi kar payega
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

                    // --- Submit Button ---
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
                                  bool success = await proProvider.addProduct();
                                  if (success && context.mounted) {
                                    proProvider.clearForm();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Success!"),
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
