import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    OrderInformationCard(order: order),
                    const SizedBox(height: 16),
                    OrderItemsCard(orderItems: order['items'] ?? []),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    UpdateStatusCard(selectedStatus: order['status'] ?? 'Pending'),
                    const SizedBox(height: 16),
                    CustomerInfoCard(
                      customerName: order['customer'],
                      customerEmail: order['customer_email'] ?? 'customer@email.com',
                    ),
                    const SizedBox(height: 16),
                    ShippingAddressCard(
                      name: order['shipping_name'] ?? 'John Doe',
                      address: order['shipping_address'] ?? '123 Main Street, City',
                    ),
                    const SizedBox(height: 16),
                    const BillingAddressCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const BackButton(color: Colors.black87),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order [#${order['order_id']}] Details',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Payment Status is Unpaid. Order placed on ${order['date']}',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// Order Information Card Widget
class OrderInformationCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderInformationCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final itemCount = order['items']?.length ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade400, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Order Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoItem(label: 'Date', value: '${order['date']} at 01:36'),
              InfoItem(label: 'Items', value: '$itemCount Items'),
              InfoItem(label: 'Total', value: order['total']),
            ],
          ),
        ],
      ),
    );
  }
}

// Info Item Widget
class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Order Items Card Widget
class OrderItemsCard extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;

  const OrderItemsCard({super.key, required this.orderItems});

  double _calculateSubtotal() {
    return orderItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item['price'].toString().replaceAll('₹', '').replaceAll(',', '')) ?? 0.0;
      final qty = int.tryParse(item['quantity'].toString()) ?? 0;
      return sum + (price * qty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final couponDiscount = 0.0;
    final pointDiscount = 0.0;
    final shipping = 0.0;
    final tax = 0.0;
    final total = subtotal - couponDiscount - pointDiscount + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: Colors.blue.shade400, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const OrderItemsTableHeader(),
          const SizedBox(height: 12),
          ...orderItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderItemRow(item: item),
          )),
          const Divider(height: 32),
          PriceBreakdown(
            subtotal: subtotal,
            couponDiscount: couponDiscount,
            pointDiscount: pointDiscount,
            shipping: shipping,
            tax: tax,
            total: total,
          ),
        ],
      ),
    );
  }
}

// Order Items Table Header
class OrderItemsTableHeader extends StatelessWidget {
  const OrderItemsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(
              flex: 3,
              child: Text('Items',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(
              flex: 1,
              child: Text('Price',
                  textAlign: TextAlign.right,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(
              flex: 1,
              child: Text('Qty',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(
              flex: 1,
              child: Text('Total',
                  textAlign: TextAlign.right,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        ],
      ),
    );
  }
}

// Order Item Row
class OrderItemRow extends StatelessWidget {
  final Map<String, dynamic> item;

  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(item['price'].toString().replaceAll('₹', '').replaceAll(',', '')) ?? 0.0;
    final qty = int.tryParse(item['quantity'].toString()) ?? 0;
    final total = price * qty;

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: item['image'] != null 
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.watch, color: Colors.black54);
                  },
                ),
              )
            : const Icon(Icons.watch, color: Colors.black54),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            item['name'] ?? 'Unknown Product',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '₹${price.toStringAsFixed(0)}',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            qty.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '₹${total.toStringAsFixed(0)}',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// Price Breakdown Widget
class PriceBreakdown extends StatelessWidget {
  final double subtotal;
  final double couponDiscount;
  final double pointDiscount;
  final double shipping;
  final double tax;
  final double total;

  const PriceBreakdown({
    super.key,
    required this.subtotal,
    required this.couponDiscount,
    required this.pointDiscount,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PriceRow(label: 'Subtotal', value: '₹${subtotal.toStringAsFixed(0)}'),
        const SizedBox(height: 8),
        PriceRow(label: 'Coupon Discount', value: '-₹${couponDiscount.toStringAsFixed(0)}', color: Colors.red),
        const SizedBox(height: 8),
        PriceRow(label: 'Point Based Discount', value: '-₹${pointDiscount.toStringAsFixed(0)}', color: Colors.red),
        const SizedBox(height: 8),
        PriceRow(label: 'Shipping', value: '₹${shipping.toStringAsFixed(1)}'),
        const SizedBox(height: 8),
        PriceRow(label: 'Tax', value: '₹${tax.toStringAsFixed(1)}'),
        const Divider(height: 24),
        PriceRow(label: 'Total', value: '₹${total.toStringAsFixed(0)}', isBold: true, fontSize: 16),
      ],
    );
  }
}

// Price Row Widget
class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final double fontSize;
  final Color? color;

  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.fontSize = 14,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: color ?? Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Update Status Card Widget
class UpdateStatusCard extends StatelessWidget {
  final String selectedStatus;

  const UpdateStatusCard({
    super.key,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sync_outlined, color: Colors.blue.shade400, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Update Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedStatus,
                  style: const TextStyle(fontSize: 14),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Customer Info Card Widget
class CustomerInfoCard extends StatelessWidget {
  final String customerName;
  final String customerEmail;

  const CustomerInfoCard({
    super.key,
    required this.customerName,
    required this.customerEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline,
                  color: Colors.blue.shade400, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Customer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customerEmail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Shipping Address Card Widget
class ShippingAddressCard extends StatelessWidget {
  final String name;
  final String address;

  const ShippingAddressCard({
    super.key,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined,
                  color: Colors.blue.shade400, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Billing Address Card Widget
class BillingAddressCard extends StatelessWidget {
  const BillingAddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  color: Colors.blue.shade400, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Billing Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Same as shipping address',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// Demo Data
class OrderDetailDemoData {
  static final List<Map<String, dynamic>> demoOrders = [
    {
      'order_id': '898bf',
      'customer': 'Aditya Jaiswal',
      'customer_email': 'aditya.jaiswal@gmail.com',
      'date': '09/01/2026',
      'total': '₹3,80,000',
      'status': 'Pending',
      'shipping_name': 'Aditya Jaiswal',
      'shipping_address': '123 Marine Drive, Apartment 5B, Mumbai, Maharashtra 400020',
      'items': [
        {
          'name': 'ROLEX Submariner (Black, 41mm)',
          'price': '3,80,000',
          'quantity': '1',
          'image': null,
        }
      ]
    },
    {
      'order_id': '7a3d2',
      'customer': 'Rajesh Kumar',
      'customer_email': 'rajesh.kumar@gmail.com',
      'date': '08/01/2026',
      'total': '₹2,45,000',
      'status': 'Shipped',
      'shipping_name': 'Rajesh Kumar',
      'shipping_address': '456 Park Street, Delhi, Delhi 110001',
      'items': [
        {
          'name': 'OMEGA Seamaster (Blue, 42mm)',
          'price': '1,85,000',
          'quantity': '1',
          'image': null,
        },
        {
          'name': 'TAG Heuer Carrera (Silver, 39mm)',
          'price': '60,000',
          'quantity': '1',
          'image': null,
        }
      ]
    },
    {
      'order_id': 'f5b9c',
      'customer': 'Priya Sharma',
      'customer_email': 'priya.sharma@gmail.com',
      'date': '07/01/2026',
      'total': '₹5,20,000',
      'status': 'Delivered',
      'shipping_name': 'Priya Sharma',
      'shipping_address': '789 MG Road, Bengaluru, Karnataka 560001',
      'items': [
        {
          'name': 'PATEK PHILIPPE Calatrava (Gold, 38mm)',
          'price': '5,20,000',
          'quantity': '1',
          'image': null,
        }
      ]
    },
  ];
}

// Example usage:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => OrderDetailPage(
//       order: OrderDetailDemoData.demoOrders[0],
//     ),
//   ),
// );