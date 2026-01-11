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
      {
        'order_id': 'ORD-103',
        'customer': 'Charlie Brown',
        'date': 'Jan 07',
        'total': '₹78,500',
        'status': 'Shipped',
      },
    ];

    return Padding(
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
              case 'Shipped':
                color = Colors.blue;
                break;
              case 'Pending':
                color = Colors.orange;
                break;
              default:
                color = Colors.grey;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withAlpha(100), width: 1),
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
                fontSize: 14,
                color: Colors.green,
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
                    size: 18,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetail(order: item),));
                  },
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

          return Text(
            value.toString(),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          );
        },
      ),
    );
  }
}
