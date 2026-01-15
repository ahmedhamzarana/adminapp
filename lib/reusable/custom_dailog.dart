import 'package:flutter/material.dart';

class CustomDailog extends StatefulWidget {
  final Map<String, dynamic> order;

  const CustomDailog({super.key, required this.order});

  @override
  State<CustomDailog> createState() => _CustomDailogState();
}

class _CustomDailogState extends State<CustomDailog> {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.receipt_long),
          SizedBox(width: 8),
          Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info('Order ID', widget.order['order_id']),
            _info('Customer', widget.order['customer']),
            _info('Email', widget.order['email']),
            _info('Address', widget.order['address']),
            _info('Total Amount', widget.order['total']),
            const SizedBox(height: 12),
            const Text(
              'Update Status',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
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
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Updated Status: $selectedStatus');
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
