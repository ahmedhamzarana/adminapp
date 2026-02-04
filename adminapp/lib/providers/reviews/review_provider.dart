import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Method: Fetch and Join Data
  Future<void> fetchReviews({bool onlyPending = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var query = _supabase.from('tbl_reviews').select('*');
      if (onlyPending) query = query.eq('is_verified_purchase', false);
      
      final response = await query.order('created_at', ascending: false);
      final List<Map<String, dynamic>> fetchedReviews = List<Map<String, dynamic>>.from(response);

      if (fetchedReviews.isNotEmpty) {
        // IDs extract karein sahi format mein
        final productIds = fetchedReviews.map((r) => int.parse(r['product_id'].toString())).toSet().toList();
        final userIds = fetchedReviews.map((r) => r['user_id'].toString()).toSet().toList();

        // Related tables fetch karein (.filter use kiya hai keyword error se bachne ke liye)
        final productsData = await _supabase.from('tbl_products').select('id, prod_name').filter('id', 'in', productIds);
        final usersData = await _supabase.from('tbl_users').select('user_id, name').filter('user_id', 'in', userIds);

        final pMap = {for (var p in productsData) p['id'].toString(): p['prod_name']};
        final uMap = {for (var u in usersData) u['user_id'].toString(): u['name']};

        for (var review in fetchedReviews) {
          review['joined_product'] = pMap[review['product_id'].toString()] ?? 'Unknown Product';
          review['joined_customer'] = uMap[review['user_id'].toString()] ?? (review['user_name'] ?? 'Guest');
        }
      }
      _reviews = fetchedReviews;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method: Delete Review
  Future<void> deleteReview(dynamic id) async {
    try {
      await _supabase.from('tbl_reviews').delete().eq('id', id);
      _reviews.removeWhere((r) => r['id'] == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }

  // Method: Update Status
  Future<void> updateStatus(dynamic id, bool currentStatus) async {
    try {
      await _supabase.from('tbl_reviews').update({'is_verified_purchase': !currentStatus}).eq('id', id);
      final index = _reviews.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _reviews[index]['is_verified_purchase'] = !currentStatus;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Update error: $e");
    }
  }
    Future<void> refreshReview() async => fetchReviews();

}