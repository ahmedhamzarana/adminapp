import 'package:adminapp/reusable/custom_table.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UsersTableView extends StatelessWidget {
  const UsersTableView({super.key});

  @override
  Widget build(BuildContext context) {
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
                        color: AppColors.bgcolor,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined),
                      color: AppColors.success,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.danger,
                    ),
                  ],
                ),
              ),
            ),

            /// ================= TABLE BODY =================
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Landscape scroll
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width, // Full width
                  ),
                  child: CustomTable(
                    headers: const [
                      '', // Checkbox column
                      'Id',
                      'Name',
                      'Brand',
                      'Description',
                      'Price',
                      'Stock',
                      'Category',
                      'Image',
                    ],
                    rows: [
                      [
                        Checkbox(value: false, onChanged: (val) {}),

                        '1',
                        'Rolex',
                        'Luxury',
                        'Submariner with long text that may wrap into multiple lines',
                        '\$5000',
                        '12',
                        'Watch',
                        Image.network(
                          'https://media.istockphoto.com/id/1359180038/photo/wristwatch.jpg?s=612x612&w=0&k=20&c=AWkZ-gaLo601vG5eiQcsjYRjCjDxZdGL7v-jWvvAjEM=',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ],
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
