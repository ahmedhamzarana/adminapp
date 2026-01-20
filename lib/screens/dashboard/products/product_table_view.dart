// lib/screens/dashboard/products/product_table_view.dart
import 'package:adminapp/providers/products/view_product_provider.dart';
import 'package:adminapp/screens/dashboard/products/product_edit_dailog.dart';
import 'package:adminapp/widget/custom_table.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsTableView extends StatefulWidget {
  const ProductsTableView({super.key});

  @override
  State<ProductsTableView> createState() => _ProductsTableViewState();
}

class _ProductsTableViewState extends State<ProductsTableView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ViewProductProvider>(context);

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productProvider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              productProvider.errorMessage,
              style: const TextStyle(color: AppColors.danger),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => productProvider.fetchProducts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final productsData = productProvider.products
        .map(
          (product) => {
            'id': product.id,
            'name': product.prodName,
            'image': product.prodImg,
            'brand': product.prodBrand,
            'price': '₹${product.prodPrice.toStringAsFixed(2)}',
            'stock': product.prodStock,
            'product_obj': product,
          },
        )
        .toList();

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ResponsiveTableView(
            title: 'Product Inventory',
            data: productsData,
            headerActions: [
              IconButton(
                onPressed: () => productProvider.refreshProducts(),
                icon: const Icon(Icons.refresh, color: AppColors.secondary),
                tooltip: 'Refresh',
              ),
            ],
            headers: const [
              'Image',
              'Name',
              'Brand',
              'Price',
              'Stock',
              'Actions',
            ],
            rowBuilder: (context, header, value, item) {
              if (header == 'Image') {
                final imageUrl = item['image'] ?? '';
                return Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl.isNotEmpty &&
                            imageUrl != 'https://via.placeholder.com/200'
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    color: Colors.grey),
                          )
                        : const Icon(Icons.image_outlined,
                            color: Colors.grey),
                  ),
                );
              }

              if (header == 'Name') {
                return Text(
                  item['name'] ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                );
              }

              if (header == 'Brand') {
                return Text(
                  item['brand'] ?? 'N/A',
                  style: const TextStyle(fontSize: 13),
                );
              }

              if (header == 'Stock') {
                final int stockValue = value is int ? value : 0;
                final bool isLow = stockValue < 5;
                return Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLow ? AppColors.danger : AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("$stockValue units"),
                  ],
                );
              }

              if (header == 'Price') {
                return Text(
                  value ?? '₹0.00',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                );
              }

              if (header == 'Actions') {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.success,
                        size: 18,
                      ),
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => ProductEditDialog(
                            product: item['product_obj'],
                          ),
                        );
                        if (result == true && context.mounted) {
                          productProvider.refreshProducts();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.danger,
                        size: 18,
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Product'),
                            content: const Text(
                              'Are you sure you want to delete this product?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.danger,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          final success = await productProvider
                              .deleteProduct(item['id']);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product deleted successfully'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                );
              }
              return Text(value.toString());
            },
          ),
        ),
      ),
    );
  }
}