import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/models/order.dart';
import 'package:watchhub/provider/orderprovider.dart';
import 'package:watchhub/utils/appconstant.dart';

class RunningOrdersWidget extends StatefulWidget {
  const RunningOrdersWidget({super.key});

  @override
  State<RunningOrdersWidget> createState() => _RunningOrdersWidgetState();
}

class _RunningOrdersWidgetState extends State<RunningOrdersWidget> {
  static const int maxOrdersToShow = 3;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fetchOrders();
    });
  }

  bool _isRunningOrder(String status) {
    final normalizedStatus = status.toLowerCase().trim();
    
    return normalizedStatus == 'pending' ||
        normalizedStatus == 'confirmed' ||
        normalizedStatus == 'shipped' ||
        normalizedStatus == 'processing' ||
        normalizedStatus == 'in_transit';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final runningOrders = orderProvider.orders
            .where((order) => _isRunningOrder(order.status))
            .take(maxOrdersToShow)
            .toList();

        if (orderProvider.isLoading && runningOrders.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (runningOrders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "No Running Orders",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your active orders will appear here",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: runningOrders.map((order) {
              return Padding(
                key: ValueKey(order.id),
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildRunningOrderCard(order),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildRunningOrderCard(Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order.id}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getStatusColor(order.status),
                    width: 1,
                  ),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            "Date",
            order.orderDate.split('T')[0],
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.shopping_bag,
            "Items",
            "${order.totalItem} items",
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.monetization_on,
            "Total",
            "Rs ${order.totalAmount.toStringAsFixed(0)}",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Appconstant.appmaincolor),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
      case 'in_transit':
        return Colors.purple;
      case 'processing':
        return Colors.teal;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}