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

      final data = await supabase
          .from('tbl_products')
          .select('''
            id, 
            prod_img, 
            prod_name, 
            prod_price, 
            prod_stock, 
            prod_description,
            tbl_brand ( id, brand_name)
          ''')
          .order('created_at', ascending: false);

      products = (data as List).map((item) {
        final rawItem = Map<String, dynamic>.from(item);
        rawItem['tbl_brand'] ??= {
          'id': 0,
          'brand_name': 'No Brand',
        };
        return Product.fromJson(rawItem);
      }).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load products';
      notifyListeners();
    }
  }

  // 🔥 FIXED DELETE (same syntax, FK handled)
  Future<bool> deleteProduct(dynamic productId) async {
    try {
      await supabase.from('tbl_products').delete().eq('id', productId);
      products.removeWhere((p) => p.id == productId);
      notifyListeners();
      return true;
    } on PostgrestException catch (e) {
      if (e.code == '23503') {
        errorMessage = 'Product is already in orders';
      } else {
        errorMessage = 'Failed to delete product';
      }
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong';
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshProducts() async => fetchProducts();
}
