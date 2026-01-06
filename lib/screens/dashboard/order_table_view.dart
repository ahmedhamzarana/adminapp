import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../../reusable/custom_table.dart';

class OrderTableView extends StatelessWidget {
  const OrderTableView({super.key});

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
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Edit button color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Text("Edit"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Delete button color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Text("Delete"),
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
                      '',
                      'Order ID',
                      'Customer',
                      'Product',
                      'Amount',
                      'Date',
                      'Status',
                    ],
                    rows: [
                      [
                        Checkbox(value: false, onChanged: (val) {}),
                        '#ORD-7721',
                        'John Doe',
                        'Rolex Submariner',
                        '\$5,000',
                        'Oct 24, 2023',
                        _buildStatusChip('Delivered', Colors.green),
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

  // Helper method to create a professional-looking Status Badge
  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(1), // Light background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
