import 'package:adminapp/reusable/custom_table.dart';
import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProductsTableView extends StatelessWidget {
  const ProductsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> productsData = [
      {
        'name': 'Rolex Submariner',
        'image':'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&q=80&w=200',
        'brand': 'Rolex',
        'price': '₹9,50,000',
        'stock': 4,
        'description': 'Iconic diving watch with exceptional water resistance',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ResponsiveTableView(
        title: 'Watch Inventory',
        data: productsData,
        headerActions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addProductRoute);
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Add New Watch"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
        headers: const [
          'Image',
          'Name',
          'Brand',
          'Price',
          'Stock',
          'Description',
          'Actions',
        ],
        rowBuilder: (context, header, value, item) {
          if (header == 'Image') {
            return Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }

          if (header == 'Name') {
            return Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            );
          }

          if (header == 'Stock') {
            final bool isLow = value < 5;
            return Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLow ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$value units",
                  style: TextStyle(
                    color: isLow ? Colors.red : Colors.black87,
                    fontWeight: isLow ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          }

          if (header == 'Price') {
            return Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            );
          }

          if (header == 'Description') {
            return Text(
              value,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              softWrap: true,
            );
          }

          if (header == 'Actions') {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {},
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {},
                  tooltip: 'Delete Product',
                ),
              ],
            );
          }

          return Text(value.toString());
        },
      ),
    );
  }
}
