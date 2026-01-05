import 'package:adminapp/reusable/dashboard_card.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard Overview",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Top Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DashboardCard(
                width: w,
                title: "Users",
                value: "1,250",
                icon: Icons.people,
                color: Colors.blue,
              ),
              DashboardCard(
                width: w,
                title: "Sales",
                value: "₹45K",
                icon: Icons.shopping_cart,
                color: Colors.green,
              ),
              DashboardCard(
                width: w,
                title: "Orders",
                value: "320",
                icon: Icons.receipt_long,
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Chart / Content Area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Charts / Analytics Area",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
