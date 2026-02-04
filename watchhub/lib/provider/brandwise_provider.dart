import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class BrandWiseProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  String errorMessage = '';
  
  List<Product> products = [];

  Future<void> fetchBrandProducts(int brandid) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await supabase
          .from('tbl_products')
          .select('id,prod_img, prod_name, prod_price, prod_stock, prod_description')
          .eq('prod_brand', brandid);

      products = (response as List)
          .map((e) => Product.fromJson(e))
          .toList();

    } catch (e) {
      errorMessage = 'Failed to load products';
      debugPrint('❌ BrandWise error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  
  Future<void> fetchsingleProducts(int brandid) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await supabase
          .from('tbl_products')
          .select('prod_img, prod_name, prod_price, prod_stock, prod_description')
          .eq('prod_brand', brandid);

      products = (response as List)
          .map((e) => Product.fromJson(e))
          .toList();

    } catch (e) {
      errorMessage = 'Failed to load products';
      debugPrint('❌ BrandWise error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
