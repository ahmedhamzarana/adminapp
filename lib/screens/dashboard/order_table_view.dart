import 'package:flutter/material.dart';
import '../../reusable/custom_table.dart';

class OrderTableView extends StatelessWidget {
  const OrderTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: CustomTable(
          headers: const [
            'Order ID',
            'Customer',
            'Product',
            'Amount',
            'Date',
            'Status', // This will now hold our custom Chip widget
            'Action',
          ],
          rows: [
            [
              '#ORD-7721',
              'John Doe',
              'Rolex Submariner',
              '\$5,000',
              'Oct 24, 2023',
              _buildStatusChip('Delivered', Colors.green),
              ElevatedButton(onPressed: () {}, child: const Text("Details")),
            ],
            [
              '#ORD-8832',
              'Jane Smith',
              'Casio F-91W',
              '\$100',
              'Oct 25, 2023',
              _buildStatusChip('Pending', Colors.orange),
              ElevatedButton(onPressed: () {}, child: const Text("Details")),
            ],
            [
              '#ORD-9910',
              'Mike Ross',
              'Fossil Grant',
              '\$250',
              'Oct 26, 2023',
              _buildStatusChip('Shipped', Colors.blue),
              ElevatedButton(onPressed: () {}, child: const Text("Details")),
            ],
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
        color: color.withOpacity(0.1), // Light background
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
