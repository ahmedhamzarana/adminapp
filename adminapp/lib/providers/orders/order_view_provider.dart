import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderViewProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = false;
  List<Map<String, dynamic>> ordersList = [];

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }

  // ---------------- FETCH ORDERS ----------------
  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.from('tbl_orders').select('''
        *,
        tbl_products ( prod_name, prod_price, prod_img ),
        tbl_address ( full_name, phone_number, address_details, city, zip_code )
      ''').order('created_at', ascending: false);

      final orders = List<Map<String, dynamic>>.from(response);

      for (var order in orders) {
        if (order['user_id'] != null) {
          order['tbl_users'] = await supabase
              .from('tbl_users')
              .select('name, email, image_url')
              .eq('user_id', order['user_id'])
              .maybeSingle();
        }
      }

      ordersList = orders;
    } catch (e) {
      debugPrint('❌ Fetch Orders Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- UPDATE STATUS ----------------
  Future<bool> updateStatus(int orderId, String newStatus) async {
    try {
      isLoading = true;
      notifyListeners();

      await supabase
          .from('tbl_orders')
          .update({'status': newStatus.toLowerCase()})
          .eq('id', orderId);

      final index = ordersList.indexWhere((o) => o['id'] == orderId);
      if (index != -1) {
        ordersList[index]['status'] = newStatus.toLowerCase();
      }

      return true;
    } catch (e) {
      debugPrint('❌ Update Status Error: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- DELETE CANCELLED ORDER ----------------
  Future<bool> deleteOrder(int orderId) async {
    try {
      final order = ordersList.firstWhere((o) => o['id'] == orderId);

      if (order['status'].toString().toLowerCase() != 'cancelled') {
        debugPrint('❌ Cannot delete non-cancelled order');
        return false;
      }

      await supabase.from('tbl_orders').delete().eq('id', orderId);
      ordersList.removeWhere((o) => o['id'] == orderId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Delete Order Error: $e');
      return false;
    }
  }

  Future<void> refreshOrders() => fetchOrders();
}
