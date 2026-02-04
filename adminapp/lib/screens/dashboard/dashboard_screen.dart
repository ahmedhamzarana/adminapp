import 'package:adminapp/providers/dashboard_provider.dart';
import 'package:adminapp/screens/dashboard/products/add_product.dart';
import 'package:adminapp/widget/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, _) {
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
                    Row(
                      children: [
                        // Refresh Button
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AddProduct(),
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
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: dashboardProvider.isLoading
                              ? null
                              : () {
                                  context
                                      .read<DashboardProvider>()
                                      .fetchDashboardStats();
                                },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Refresh Stats"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            side: const BorderSide(color: Colors.black12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Dashboard Cards
                if (dashboardProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: DashboardCard(
                          title: "Total Revenue",
                          value: dashboardProvider.formatCurrency(
                            dashboardProvider.totalRevenue,
                          ),
                          trend:
                              "From ${dashboardProvider.completedOrders} completed",
                          icon: Icons.account_balance_wallet_outlined,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DashboardCard(
                          title: "Total Orders",
                          value: dashboardProvider.totalOrders.toString(),
                          trend:
                              "${dashboardProvider.completedOrders} completed",
                          icon: Icons.shopping_cart_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DashboardCard(
                          title: "Active Customers",
                          value: dashboardProvider.totalUsers.toString(),
                          trend: "Total registered",
                          icon: Icons.people_outline,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
