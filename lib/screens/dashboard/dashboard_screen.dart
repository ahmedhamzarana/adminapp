import 'package:adminapp/screens/dashboard/products/add_product.dart';
import 'package:adminapp/widget/dashboard_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final homeProvider = Provider.of<HomeProvider>(context);

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Watches Hub",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      "Luxury Watch Inventory & Sales Overview",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddProduct(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add New Watch"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            Row(
              children: [
                const Expanded(
                  child: DashboardCard(
                    title: "Total Revenue",
                    value: "Rs842,500",
                    trend: "+14.2%",
                    icon: Icons.account_balance_wallet_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: DashboardCard(
                    title: "Luxury Items Sold",
                    value: "124",
                    trend: "+5.1%",
                    icon: Icons.watch_outlined,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DashboardCard(
                    title: "Active Customers",
                    value: "1,500",
                    trend: "+12.5%",
                    icon: Icons.people_outline,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recent Watch Shipments",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  _buildOrderRow("Rolex Submariner", "Success", "₹9,50,000"),
                  _buildOrderRow("Omega Seamaster", "Pending", "₹4,20,000"),
                  _buildOrderRow("Tag Heuer Carrera", "Success", "₹2,10,000"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow(String item, String status, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: status == "Success"
                  ? Colors.green.withAlpha(40)
                  : Colors.orange.withAlpha(40),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == "Success" ? Colors.green : Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
