import 'package:adminapp/reusable/custom_table.dart';
import 'package:flutter/material.dart';

class OrdersTableView extends StatelessWidget {
  const OrdersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ordersData = [
      {
        'order_id': 'ORD-101',
        'customer': 'Alice Smith',
        'date': 'Jan 05',
        'total': '₹45,000',
        'status': 'Delivered',
      },
      {
        'order_id': 'ORD-102',
        'customer': 'Bob Johnson',
        'date': 'Jan 06',
        'total': '₹1,20,000',
        'status': 'Pending',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ResponsiveTableView(
        title: "Order History",
        data: ordersData,
        headers: const ['Order ID', 'Customer', 'Date', 'Total', 'Status'],
        rowBuilder: (context, header, value, item) {
          if (header == 'Status') {
            final Color color = value == 'Delivered' ? Colors.green : Colors.orange;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          
          if (header == 'Total') {
            return Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            );
          }
          
          return Text(value.toString());
        },
      ),
    );
  }
}