import 'package:adminapp/reusable/info_row.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class OrderDetailDailog extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailDailog({super.key, required this.order});

  @override
  State<OrderDetailDailog> createState() => _OrderDetailDailogState();
}

class _OrderDetailDailogState extends State<OrderDetailDailog> {
  late String selectedStatus;

  final List<String> orderStatusList = [
    'Pending',
    'Processing',
    'Shipping',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order['status'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: const Text(
          "Order Detail",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            InfoRow(label: "Order ID", value: "#ORD-101"),
            InfoRow(label: "Name", value: "John Doe"),
            InfoRow(label: "Email", value: "johndoe@gmail.com"),
            InfoRow(
              label: "Address",
              value:
                  "Shanti Nagar, Near XYZ Society, ABC Road, Pune Maharashtra 411001",
            ),
            InfoRow(label: "Total", value: "₹799"),

            const Divider(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Update Status',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              items: orderStatusList
                  .map(
                    (status) =>
                        DropdownMenuItem(value: status, child: Text(status)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedStatus = value!);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.bgcolor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),

      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
