import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = false;

  // Dashboard Stats
  int totalUsers = 0;
  int totalOrders = 0;
  int completedOrders = 0;
  double totalRevenue = 0.0;

  /// Fetch all dashboard stats
  Future<void> fetchDashboardStats() async {
    try {
      isLoading = true;
      notifyListeners();

      // Fetch in parallel for better performance
      await Future.wait([_fetchTotalUsers(), _fetchOrderStats()]);
    } catch (e) {
      debugPrint("❌ Error fetching dashboard stats: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch total users count
  Future<void> _fetchTotalUsers() async {
    try {
      final response = await supabase.from('tbl_users').select('id').count();

      totalUsers = response.count;
    } catch (e) {
      debugPrint("❌ Error fetching total users: $e");
      totalUsers = 0;
    }
  }

  /// Fetch order statistics
  Future<void> _fetchOrderStats() async {
    try {
      // Get all orders with count
      final allOrdersResponse = await supabase
          .from('tbl_orders')
          .select('id, status, total_amount')
          .count();

      totalOrders = allOrdersResponse.count;

      // Get the actual data
      final List<dynamic> orders = allOrdersResponse.data as List<dynamic>;

      completedOrders = 0;
      totalRevenue = 0.0;

      for (var order in orders) {
        final String status = order['status']?.toString().toLowerCase() ?? '';

        // Count completed orders
        if (status == 'completed' || status == 'delivered') {
          completedOrders++;

          // Sum total revenue from completed orders only
          final double amount = (order['total_amount'] ?? 0).toDouble();
          totalRevenue += amount;
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching order stats: $e");
      totalOrders = 0;
      completedOrders = 0;
      totalRevenue = 0.0;
    }
  }

  /// Format currency
  String formatCurrency(double amount) {
    if (amount >= 100000) {
      return "Rs${(amount / 1000).toStringAsFixed(1)}k";
    }
    return "Rs${amount.toStringAsFixed(0)}";
  }
}
