import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adminapp/providers/products/view_product_provider.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:adminapp/widget/custom_table.dart';
import 'package:adminapp/screens/dashboard/products/product_edit_dailog.dart';

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
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final productsData = productProvider.products
        .map(
          (product) => {
            'id': product.id,
            'name': product.prodName,
            'image': product.prodImg,
            'brand': product.prodBrandName, // Using model property
            'price': 'Rs${product.prodPrice.toStringAsFixed(2)}',
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
            headers: const [
              'Image',
              'Name',
              'Brand',
              'Price',
              'Stock',
              'Actions',
            ],
            headerActions: [
              IconButton(
                onPressed: () => productProvider.refreshProducts(),
                icon: const Icon(Icons.refresh, color: AppColors.secondary),
              ),
            ],
            rowBuilder: (context, header, value, item) {
              switch (header) {
                case 'Image':
                  return _buildImage(item['image']);
                case 'Name':
                  return Text(
                    item['name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                case 'Brand':
                  return Text(item['brand'] ?? 'N/A');
                case 'Price':
                  return Text(
                    value.toString(),
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                case 'Stock':
                  return _buildStock(value);
                case 'Actions':
                  return _buildActions(context, item, productProvider);
                default:
                  return Text(value.toString());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? url) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: (url != null && url.isNotEmpty)
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.error_outline, size: 20),
              )
            : const Icon(Icons.image, size: 20),
      ),
    );
  }

  Widget _buildStock(dynamic value) {
    final int stock = value is int ? value : 0;
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 8,
          color: stock < 5 ? Colors.red : Colors.green,
        ),
        const SizedBox(width: 5),
        Text("$stock"),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    Map item,
    ViewProductProvider provider,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
          onPressed: () => showDialog(
            context: context,
            builder: (context) =>
                ProductEditDialog(product: item['product_obj']),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          onPressed: () => provider.deleteProduct(item['id']),
        ),
      ],
    );
  }
}
