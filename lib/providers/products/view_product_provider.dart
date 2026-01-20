// lib/providers/products/view_product_provider.dart
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
          .select('id, prod_img, prod_name, prod_brand, prod_price, prod_stock, prod_description')
          .order('created_at', ascending: false);

      products = (data as List).map((item) {
        final Map<String, dynamic> productData = {
          'id': item['id'],
          'prod_img': item['prod_img'],
          'prod_name': item['prod_name'],
          'prod_brand': item['prod_brand'],
          'prod_price': item['prod_price'],
          'prod_stock': item['prod_stock'],
          'prod_description': item['prod_description'],
        };
        return Product.fromJson(productData);
      }).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load products';
      notifyListeners();
      debugPrint('Error fetching products: $e');
    }
  }

  Future<bool> deleteProduct(dynamic productId) async {
    if (productId == null) {
      debugPrint('Error: Product ID is null');
      return false;
    }

    try {
      await supabase.from('tbl_products').delete().eq('id', productId);

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