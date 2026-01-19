import 'package:adminapp/screens/dashboard/orders/order_detail_dailog.dart';
import 'package:adminapp/widget/custom_table.dart';
import 'package:flutter/material.dart';

class OrdersTableView extends StatelessWidget {
  const OrdersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ordersData = [
      {
        'order_id': 'ORD-101',
        'customer': 'Alice Smith',
        'email': 'alice@gmail.com',
        'address': '221B Baker Street, London',
        'date': 'Jan 05',
        'total': '₹45,000',
        'status': 'Delivered',
      },
      {
        'order_id': 'ORD-102',
        'customer': 'Bob Johnson',
        'email': 'bob@gmail.com',
        'address': 'MG Road, Bengaluru',
        'date': 'Jan 06',
        'total': '₹1,20,000',
        'status': 'Pending',
      },
    ];

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ResponsiveTableView(
            title: "Order History",
            data: ordersData,
            headers: const [
              'Order ID',
              'Customer',
              'Date',
              'Total',
              'Status',
              'Actions',
            ],
            rowBuilder: (context, header, value, item) {
              if (header == 'Status') {
                Color color;
                switch (value) {
                  case 'Delivered':
                    color = Colors.green;
                    break;
                  case 'Pending':
                    color = Colors.orange;
                    break;
                  default:
                    color = Colors.blueGrey;
                }

                return Chip(
                  label: Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: color.withAlpha(12),
                );
              }

              if (header == 'Total') {
                return Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                );
              }

              if (header == 'Actions') {
                return IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => OrderDetailDailog(order: item),
                    );
                  },
                );
              }

              return Text(
                value.toString(),
                style: const TextStyle(fontSize: 13),
              );
            },
          ),
        ),
      ),
    );
  }
}
