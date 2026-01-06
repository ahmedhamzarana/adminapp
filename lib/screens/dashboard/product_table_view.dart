import 'package:adminapp/providers/products_view_provider.dart';
import 'package:adminapp/reusable/custom_table.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTableView extends StatelessWidget {
  const ProductTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final proProvider = Provider.of<ProductsViewProvider>(context);

    // Example product list
    final products = [
      {
        'id': 1,
        'name': 'Rolex',
        'brand': 'Luxury',
        'description':
            'Submariner with long text that may wrap into multiple lines',
        'price': '\$5000',
        'stock': '12',
        'category': 'Watch',
        'image':
            'https://media.istockphoto.com/id/1359180038/photo/wristwatch.jpg?s=612x612&w=0&k=20&c=AWkZ-gaLo601vG5eiQcsjYRjCjDxZdGL7v-jWvvAjEM=',
      },
      // Add more products here
    ];

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
            /// ================= HEADER =================
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
                child: Row(
                  children: [
                    const Text(
                      "Product List",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Edit"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              ),
            ),

            /// ================= TABLE BODY =================
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: CustomTable(
                    headers: const [
                      '', // Checkbox
                      'Id',
                      'Name',
                      'Brand',
                      'Description',
                      'Price',
                      'Stock',
                      'Category',
                      'Image',
                    ],
                    rows: products.map((product) {
                      int id = product['id'] as int;
                      return [
                        Checkbox(
                          value: proProvider.isSelected(id),
                          onChanged: (bool? value) {
                            proProvider.toggleRow(id);
                          },
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary; // checked color
                            }
                            return Colors.grey; // unchecked color
                          }),
                        ),
                        '${product['id']}',
                        '${product['name']}',
                        '${product['brand']}',
                        '${product['description']}',
                        '${product['price']}',
                        '${product['stock']}',
                        '${product['category']}',
                        Image.network(
                          '${product['image']}',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ];
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
