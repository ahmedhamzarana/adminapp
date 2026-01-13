import 'package:adminapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Product> products = []; // Sare products yahan store honge
  bool isLoading = false; // Loading state
  String errorMessage = ''; // Error message

  // Sare products fetch karna
  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      // Supabase se data fetch karo (latest first)
      final data = await supabase
          .from('tbl_products')
          .select(
            'prod_img, prod_name, prod_brand, prod_price, prod_stock',
          )
          .order('created_at', ascending: false);

      // Data ko Product objects me convert karo
      products = (data as List).map((item) => Product.fromJson(item)).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load products';
      notifyListeners();
      print('Error fetching products: $e');
    }
  }

  // Product delete karna
  Future<bool> deleteProduct(int productId) async {
    try {
      // Database se delete karo
      await supabase.from('tbl_products').delete().eq('id', productId);

      // Local list se bhi remove karo
      products.removeWhere((product) => product.id == productId);
      notifyListeners();

      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Products refresh karna
  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}
