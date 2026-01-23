// lib/screens/home_screen.dart
import 'package:adminapp/screens/dashboard/brands/view_brand_screen.dart';
import 'package:adminapp/screens/dashboard/chats/inchatapp_screen.dart';
import 'package:adminapp/screens/dashboard/orders/order_table_view.dart';
import 'package:adminapp/screens/dashboard/products/product_table_view.dart';
import 'package:adminapp/screens/dashboard/reviews/review_table_view.dart';
import 'package:adminapp/screens/dashboard/users/users_table_view.dart';
import 'package:adminapp/screens/dashboard/dashboard_screen.dart';
import 'package:adminapp/providers/home_provider.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:adminapp/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    DashboardScreen(),
    ProductsTableView(),
    ViewBrandScreen(),
    OrdersTableView(),
    ReviewsTableView(),
    UsersTableView(),
    InchatappScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        titleSpacing: 24,
        title: Row(
          children: const [
            Icon(Icons.watch, color: AppColors.secondary),
            SizedBox(width: 10),
            Text(
              "Watches Hub Admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 280,
            height: 42,
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              cursorColor: AppColors.secondary,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 18,
                ),
                filled: true,
                fillColor: Colors.white.withAlpha(35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.secondary.withAlpha(80),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.secondary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: "Logout",
            onPressed: () {
              Provider.of<HomeProvider>(context, listen: false).logout(context);
            },
            icon: const Icon(Icons.logout, color: AppColors.secondary),
          ),
          const SizedBox(width: 20),
        ],
      ),

      body: Row(
        children: [
          Container(
            width: 250,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text(
                    "MAIN MENU",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Divider(color: Colors.white24, thickness: 0.5),

                Sidebar(
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard",
                  isActive: selectedIndex == 0,
                  onTap: () => setState(() => selectedIndex = 0),
                ),

                // Products Section Header
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    "PRODUCTS",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Sidebar(
                  icon: Icons.inventory_2_outlined,
                  title: "Products",
                  isActive: selectedIndex == 1,
                  onTap: () => setState(() => selectedIndex = 1),
                ),

                // Brands Section Header
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    "BRANDS",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Sidebar(
                  icon: Icons.label_outline,
                  title: "Brands",
                  isActive: selectedIndex == 2,
                  onTap: () => setState(() => selectedIndex = 2),
                ),

                const Divider(color: Colors.white24, thickness: 0.5),

                Sidebar(
                  icon: Icons.shopping_cart_outlined,
                  title: "Orders",
                  isActive: selectedIndex == 3,
                  onTap: () => setState(() => selectedIndex = 3),
                ),
                Sidebar(
                  icon: Icons.rate_review_outlined,
                  title: "Reviews",
                  isActive: selectedIndex == 4,
                  onTap: () => setState(() => selectedIndex = 4),
                ),
                Sidebar(
                  icon: Icons.group_outlined,
                  title: "Manage Users",
                  isActive: selectedIndex == 5,
                  onTap: () => setState(() => selectedIndex = 5),
                ),
                Sidebar(
                  icon: Icons.chat_bubble_outline,
                  title: "In Chats App",
                  isActive: selectedIndex == 6,
                  onTap: () => setState(() => selectedIndex = 6),
                ),

                const Spacer(),

                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Watches Hub • v1.0.0",
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: screens[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
