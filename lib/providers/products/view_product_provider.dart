import 'package:adminapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Product> products = [];
  bool isLoading = false; 
  String errorMessage = '';

  // Sare products fetch karna
  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final data = await supabase
          .from('tbl_products')
          .select(
            'prod_img, prod_name, prod_brand, prod_price, prod_stock',
          )
          .order('created_at', ascending: false);

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

  Future<bool> deleteProduct(int productId) async {
    try {
      await supabase.from('tbl_products').delete().eq('id', productId);

      products.removeWhere((product) => product.id == productId);
      notifyListeners();

      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }
  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}
