import 'package:adminapp/providers/products/add_product_provider.dart';
import 'package:adminapp/widget/custom_input.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
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
      body: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
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
                        style: TextStyle(
                          fontSize: 16,
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
                              border: Border.all(
                                color: Colors.grey.withAlpha(80),
                              ),
                            ),
                            child: proProvider.selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      proProvider.selectedImage!.path,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
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
                            onPressed: () {
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

                      /// Product Name & Brand Dropdown
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
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
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: Image.network(
                                                brand.brandImgUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(Icons.image, size: 16);
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
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
                              ],
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
                              controller: proProvider.proStockcontroller,
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

                      /// Add Product Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: proProvider.isLoading
                              ? null
                              : () async {
                                  bool isValid = proProvider.proValidateform(context);
                                  if (isValid) {
                                    bool success = await proProvider.addProduct();
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Product added successfully!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      proProvider.clearForm();
                                    } else if (!success && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Failed to add product. Please try again."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          icon: proProvider.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Icon(
                                  Icons.add_circle_outline,
                                  size: 22,
                                  color: Colors.white,
                                ),
                          label: Text(
                            proProvider.isLoading ? "Adding..." : "Add Product",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: AppColors.secondary,
                            elevation: 6,
                            shadowColor: AppColors.secondary.withAlpha(100),
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
        ),
      ),
    );
  }
}