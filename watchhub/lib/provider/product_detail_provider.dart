import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/product.dart';

class ProductDetailProvider extends ChangeNotifier {
   final supabase = Supabase.instance.client;

  bool isLoading = false;
  String errorMessage = '';

  Product? products;

  Future<void> fetchsingleProducts(int id) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

  final response = await supabase
    .from('tbl_products')
    .select('id, prod_img, prod_name, prod_price, prod_stock, prod_description, prod_brand')
    .eq('id', id)
    .maybeSingle();

     if (response != null) {
        products = Product.fromJson(response);
      } else {
        products = null;
        errorMessage = 'Product not found';
      }

    } catch (e) {
      errorMessage = 'Failed to load products';
      debugPrint('❌ ProductDetailProvider error: $e');
      products = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}