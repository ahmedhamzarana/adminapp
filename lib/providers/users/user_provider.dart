import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  bool isLoading = false;

  Future<void> fetchUsers() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.from('tbl_users').select();

      users = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error fetching users: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}