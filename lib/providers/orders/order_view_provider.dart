import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderViewProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isLoading = false;
  List<Map<String, dynamic>> ordersList = [];

  /// Fetch Orders
  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      // Products aur Address ke saath join (foreign keys hain)
      final ordersResponse = await supabase.from('tbl_orders').select('''
        *,
        tbl_products ( prod_name, prod_price, prod_img ),
        tbl_address ( full_name, phone_number, address_details, city, zip_code )
      ''').order('created_at', ascending: false);

      List<Map<String, dynamic>> orders = List<Map<String, dynamic>>.from(ordersResponse);

      // Users ko manually fetch karo (foreign key nahi hai)
      for (var order in orders) {
        if (order['user_id'] != null && order['user_id'].toString().isNotEmpty) {
          try {
            final userResponse = await supabase
                .from('tbl_users')
                .select('name, email, image_url')
                .eq('user_id', order['user_id'])
                .maybeSingle();
            order['tbl_users'] = userResponse;
          } catch (e) {
            debugPrint("⚠️ User not found for order ${order['id']}: $e");
            order['tbl_users'] = null;
          }
        } else {
          order['tbl_users'] = null;
        }
      }

      ordersList = orders;
    } catch (e) {
      debugPrint("❌ Error Fetching Orders: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Update Order Status
  Future<bool> updateStatus(int orderId, String newStatus) async {
    try {
      isLoading = true;
      notifyListeners();

      // Lowercase format (enum ke liye)
      String formattedStatus = newStatus.toLowerCase();

      await supabase
          .from('tbl_orders')
          .update({'status': formattedStatus})
          .eq('id', orderId);

      // Local update for instant UI refresh
      int index = ordersList.indexWhere((element) => element['id'] == orderId);
      if (index != -1) {
        ordersList[index]['status'] = formattedStatus;
      }

      debugPrint("✅ Status updated successfully: $formattedStatus");
      return true;
    } catch (e) {
      debugPrint("❌ Error Updating Status: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}