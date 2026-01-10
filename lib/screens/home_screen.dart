import 'package:adminapp/providers/home_provider.dart';
import 'package:adminapp/screens/dashboard/add_product.dart';
import 'package:adminapp/screens/dashboard/main_view.dart';
import 'package:adminapp/screens/dashboard/order_table_view.dart';
import 'package:adminapp/reusable/sidebar.dart';
import 'package:adminapp/screens/dashboard/product_table_view.dart';
import 'package:adminapp/screens/dashboard/review_table_view.dart';
import 'package:adminapp/screens/dashboard/users_table_view.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const MainView(),
    const AddProduct(),
    const ProductsTableView(),
    const OrdersTableView(),
    const ReviewsTableView(),
    const UsersTableView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Text(
          "Watches Hub Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        actions: [
          SizedBox(
            width: 250, // Slightly wider for better usability
            height: 40,
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              cursorColor: AppColors.secondary, // Added for consistency
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 18,
                ), // Added search icon
                filled: true,
                fillColor: Colors.white.withAlpha(
                  30,
                ), // Increased alpha for better visibility
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),

                // Removed the duplicate 'border' property and streamlined the styles
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.secondary.withAlpha(50),
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
          const SizedBox(width: 10),
          IconButton(
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
          // SIDEBAR
          Container(
            width: 250,
            height: MediaQuery.of(context).size.height,
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "MAIN MENU",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Pass current state to the Sidebar items
                Sidebar(
                  icon: Icons.dashboard,
                  title: "Dashboard",
                  isActive: selectedIndex == 0,
                  onTap: () => setState(() => selectedIndex = 0),
                ),
                Sidebar(
                  icon: Icons.type_specimen,
                  title: "Add Product",
                  isActive: selectedIndex == 1,
                  onTap: () => setState(() => selectedIndex = 1),
                ),
                Sidebar(
                  icon: Icons.branding_watermark,
                  title: "Products",
                  isActive: selectedIndex == 2,
                  onTap: () => setState(() => selectedIndex = 2),
                ),
                Sidebar(
                  icon: Icons.branding_watermark,
                  title: "Orders",
                  isActive: selectedIndex == 3,
                  onTap: () => setState(() => selectedIndex = 3),
                ),
                Sidebar(
                  icon: Icons.person,
                  title: "Review",
                  isActive: selectedIndex == 4,
                  onTap: () => setState(() => selectedIndex = 4),
                ),
                Sidebar(
                  icon: Icons.person,
                  title: "Manage Users",
                  isActive: selectedIndex == 5,
                  onTap: () => setState(() => selectedIndex = 5),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "v 1.0.0",
                    style: TextStyle(color: Colors.white30),
                  ),
                ),
              ],
            ),
          ),

          // M
          //AIN CONTENT AREA
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: screens[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
