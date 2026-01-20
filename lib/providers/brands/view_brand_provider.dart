// lib/providers/brands/view_brand_provider.dart
import 'package:adminapp/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewBrandProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Brand> brands = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchBrands() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final data = await supabase
          .from('tbl_brand')
          .select('id, brand_name, brand_img_url')
          .order('brand_name', ascending: true);

      brands = (data as List).map((item) => Brand.fromJson(item)).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load brands';
      notifyListeners();
      debugPrint('Error fetching brands: $e');
    }
  }

  Future<bool> deleteBrand(int brandId) async {
    try {
      // Check if brand is used in products
      final productCheck = await supabase
          .from('tbl_products')
          .select('id')
          .eq('prod_brand', brands.firstWhere((b) => b.id == brandId).brandName)
          .limit(1);

      if (productCheck.isNotEmpty) {
        errorMessage = 'Cannot delete brand. It is being used by products.';
        notifyListeners();
        return false;
      }

      await supabase.from('tbl_brand').delete().eq('id', brandId);

      brands.removeWhere((brand) => brand.id == brandId);
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error deleting brand: $e');
      errorMessage = 'Failed to delete brand';
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshBrands() async {
    await fetchBrands();
  }
}