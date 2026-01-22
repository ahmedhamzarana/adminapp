import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderViewProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<dynamic> ordersList = [];
  bool isLoading = false;

  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      // Table Join: tbl_orders se data aur tbl_products se prod_name
      final response = await supabase
          .from('tbl_orders')
          .select('''
            *,
            tbl_products (
              prod_name
            )
          ''')
          .order('created_at', ascending: false);

      ordersList = response as List<dynamic>;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      debugPrint("Error Fetching Orders: $e");
      notifyListeners();
    }
  }

  // Status update karne ke liye function
  Future<void> updateStatus(int orderId, String newStatus) async {
    try {
      await supabase
          .from('tbl_orders')
          .update({'status': newStatus})
          .eq('id', orderId);
      
      // List ko locally update karna taaki UI foran change ho jaye
      int index = ordersList.indexWhere((element) => element['id'] == orderId);
      if (index != -1) {
        ordersList[index]['status'] = newStatus;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }
}