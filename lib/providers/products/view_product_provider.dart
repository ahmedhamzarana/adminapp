import 'package:adminapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Product> products = [];
  bool isLoading = false;
  String errorMessage = '';

  // Fetch all products
  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      // FIXED: Added 'id' to the select query
      final data = await supabase
          .from('tbl_products')
          .select(
            'id, prod_img, prod_name, prod_brand, prod_price, prod_stock, prod_description',
          )
          .order('created_at', ascending: false);

      products = (data as List).map((item) => Product.fromJson(item)).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load products';
      notifyListeners();
      debugPrint('Error fetching products: $e');
    }
  }

  // Delete product
  Future<bool> deleteProduct(dynamic productId) async {
    if (productId == null) {
      debugPrint('Error: Product ID is null');
      return false;
    }
    
    try {
      // 1. Delete from Supabase
      await supabase.from('tbl_products').delete().eq('id', productId);

      // 2. Update local list and UI
      products.removeWhere((product) => product.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}