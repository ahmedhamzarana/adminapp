import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  bool isLoading = false;
  
  // For user detail dialog
  Map<String, dynamic>? selectedUser;
  List<Map<String, dynamic>> userOrders = [];
  bool isLoadingOrders = false;

  Future<void> fetchUsers() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.from('tbl_users').select();

      users = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("❌ Error fetching users: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch user orders
  Future<void> fetchUserOrders(String userId) async {
    try {
      isLoadingOrders = true;
      notifyListeners();

      final ordersResponse = await supabase
          .from('tbl_orders')
          .select('''
            *,
            tbl_products ( prod_name, prod_price )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      userOrders = List<Map<String, dynamic>>.from(ordersResponse);
    } catch (e) {
      debugPrint("❌ Error fetching user orders: $e");
      userOrders = [];
    } finally {
      isLoadingOrders = false;
      notifyListeners();
    }
  }

  /// Set selected user and fetch their orders
  Future<void> selectUser(Map<String, dynamic> user) async {
    selectedUser = user;
    userOrders = [];
    notifyListeners();
    
    if (user['user_id'] != null) {
      await fetchUserOrders(user['user_id']);
    }
  }

  void clearSelection() {
    selectedUser = null;
    userOrders = [];
    notifyListeners();
  }
}