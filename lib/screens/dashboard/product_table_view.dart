import 'package:adminapp/reusable/custom_table.dart';
import 'package:flutter/material.dart';
// Import your ResponsiveTableView file here

class ProductsTableView extends StatelessWidget {
  const ProductsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    // Luxury Watch Inventory Data
    final List<Map<String, dynamic>> productsData = [
      {
        'product': 'Rolex Submariner',
        'image':
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&q=80&w=200',
        'brand': 'Rolex',
        'category': 'Diver',
        'price': '₹9,50,000',
        'stock': 4, // Low stock example
        'sku': 'RLX-001',
      },
      {
        'product': 'Omega Seamaster',
        'image':
            'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?auto=format&fit=crop&q=80&w=200',
        'brand': 'Omega',
        'category': 'Sport',
        'price': '₹4,20,000',
        'stock': 15,
        'sku': 'OMG-052',
      },
      {
        'product': 'Patek Philippe Nautilus',
        'image':
            'https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=200',
        'brand': 'Patek',
        'category': 'Luxury',
        'price': '₹24,00,000',
        'stock': 1,
        'sku': 'PTK-099',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ResponsiveTableView(
        title: 'Watch Inventory',
        data: productsData,
        headerActions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Add New Watch"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
        headers: const ['Product', 'Brand', 'Price', 'Stock', 'SKU', 'Actions'],
        // Customizing the cells for a professional look
        rowBuilder: (context, header, value, item) {
          if (header == 'Product') {
            return _buildProductCell(item);
          }
          if (header == 'Stock') {
            return _buildStockCell(value);
          }
          if (header == 'Price') {
            return Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            );
          }
          if (header == 'Actions') {
            return _buildActionButtons();
          }
          return Text(value.toString());
        },
      ),
    );
  }

  // Combines Product Image, Name, and Category
  Widget _buildProductCell(Map<String, dynamic> item) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(item['image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['product'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              item['category'],
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  // Dynamic stock indicator (Red if low, Green if plenty)
  Widget _buildStockCell(int stock) {
    bool isLow = stock < 5;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLow ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "$stock units",
          style: TextStyle(
            color: isLow ? Colors.red : Colors.black87,
            fontWeight: isLow ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            Icons.edit_outlined,
            size: 18,
            color: Colors.blueGrey,
          ),
          onPressed: () {},
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
}
