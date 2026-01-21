import 'package:adminapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Product> products = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      // Query includes 'id' inside 'tbl_brand' to satisfy your model's factory
      final data = await supabase
          .from('tbl_products')
          .select('''
            id, 
            prod_img, 
            prod_name, 
            prod_price, 
            prod_stock, 
            prod_description,
            tbl_brand ( id, brand_name)''')
          .order('created_at', ascending: false);

      products = (data as List).map((item) {
        // Fallback agar tbl_brand null ho (Data integrity ke liye)
        final rawItem = Map<String, dynamic>.from(item);
        if (rawItem['tbl_brand'] == null) {
          rawItem['tbl_brand'] = {'id': 0, 'brand_name': 'No Brand'};
        }

        return Product.fromJson(rawItem);
      }).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load products: $e';
      notifyListeners();
      debugPrint("Fetch Error: $e");
    }
  }

  Future<bool> deleteProduct(dynamic productId) async {
    try {
      await supabase.from('tbl_products').delete().eq('id', productId);
      products.removeWhere((p) => p.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshProducts() async => await fetchProducts();
}