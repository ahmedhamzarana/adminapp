import 'package:adminapp/providers/orders/order_view_provider.dart';
import 'package:adminapp/screens/dashboard/orders/order_detail_dailog.dart';
import 'package:adminapp/widget/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersTableView extends StatefulWidget {
  const OrdersTableView({super.key});

  @override
  State<OrdersTableView> createState() => _OrdersTableViewState();
}

class _OrdersTableViewState extends State<OrdersTableView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<OrderViewProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderViewProvider>(context);

    if (orderProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Supabase data ko Table format ke liye map karna
    final List<Map<String, dynamic>> ordersData = orderProvider.ordersList.map((
      order,
    ) {
      return {
        'id': order['id'],
        'order_id': '#ORD-${order['id']}',
        'product': order['tbl_products'] != null
            ? order['tbl_products']['prod_name']
            : 'Unknown',
        'qty': order['total_item'],
        'total': 'Rs${order['total_amount']}',
        'status': order['status'],
        'full_item': order,
      };
    }).toList();

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ResponsiveTableView(
            title: "Order Inventory",
            data: ordersData,
            headers: const [
              'Order ID',
              'Product',
              'Qty',
              'Total',
              'Status',
              'Actions',
            ],
            rowBuilder: (context, header, value, item) {
              if (header == 'Status') {
                Color color;
                switch (value.toString().toLowerCase()) {
                  case 'delivered':
                  case 'completed':
                    color = Colors.green;
                    break;
                  case 'pending':
                    color = Colors.orange;
                    break;
                  case 'cancelled':
                    color = Colors.red;
                    break;
                  case 'shipping':
                  case 'progressing':
                    color = Colors.blue;
                    break;
                  default:
                    color = Colors.blueGrey;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withAlpha(5)),
                  ),
                  child: Text(
                    value.toString().toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
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

              if (header == 'Actions') {
                return IconButton(
                  icon: const Icon(
                    Icons.visibility,
                    size: 20,
                    color: Colors.indigo,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          OrderDetailDailog(order: item['full_item']),
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
