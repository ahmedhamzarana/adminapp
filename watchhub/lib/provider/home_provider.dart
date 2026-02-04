import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/brands.dart';
import 'package:watchhub/models/product.dart'; // Import the Product model

class HomeProvider extends ChangeNotifier {
  int bottomNavIndex = 0;

  // ================= CAROUSEL =================
  final List<String> carouselImages = [
    "https://www.swisswatchexpo.com/thewatchclub/wp-content/uploads/2024/07/Rolex-Watches-in-Yellow-Gold-and-Green.jpg",
    "https://i.pinimg.com/736x/db/12/fe/db12fea16a6836ac1a7580921983fa06.jpg",
    "https://www.swisswatchexpo.com/thewatchclub/wp-content/uploads/2023/04/Modern-Rolex-Sports-Watches-with-Blue-Bezels-and-Dials-1-1200x700.png",
    "https://wallpapercave.com/wp/wp4345512.jpg",
    "https://i.pinimg.com/736x/66/01/43/660143948271fc5cf9dc2b7b4769ea12.jpg",
  ];

  // ================= BOTTOM NAV =================
  final List<IconData> iconList = const [
    Icons.home,
    Icons.shopping_bag_sharp,
    Icons.favorite_sharp,
    Icons.person,
  ];

  // ================= SUPABASE =================
  final SupabaseClient supabase = Supabase.instance.client;

  // ================= BRAND DATA =================
  List<Brand> brands = [];
  bool isLoading = false;
  String errorMessage = '';

  // ================= PRODUCT DATA =================
  List<Product> allProducts = []; // List to hold all products
  List<Product> searchResults = []; // List to hold search results
  String currentSearchQuery = ''; // Track current search query

  // ================= FETCH BRANDS =================
  Future<void> fetchBrands() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await supabase
          .from('tbl_brand')
          .select('id, brand_name, brand_img_url')
          .order('created_at', ascending: false);

      brands = (response as List).map((e) => Brand.fromJson(e)).toList();
    } catch (e) {
      errorMessage = 'Failed to load brands';
      debugPrint('❌ Error fetching brands: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= FETCH ALL PRODUCTS =================
  Future<void> fetchAllProducts() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await supabase
          .from('tbl_products')
          .select('*') // Select all columns for products
          .order('created_at', ascending: false);

      allProducts = (response as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (e) {
      errorMessage = 'Failed to load all products';
      debugPrint('❌ Error fetching all products: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= SEARCH PRODUCTS =================
  Future<List<Product>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      currentSearchQuery = '';
      searchResults = [];
      notifyListeners();
      return [];
    }

    currentSearchQuery = query.toLowerCase();

    searchResults = allProducts.where((product) {
      return product.name.toLowerCase().contains(currentSearchQuery) ||
             product.description.toLowerCase().contains(currentSearchQuery) ||
             (product.category?.toLowerCase().contains(currentSearchQuery) ?? false) ||
             (product.type?.toLowerCase().contains(currentSearchQuery) ?? false) ||
             (product.color?.toLowerCase().contains(currentSearchQuery) ?? false) ||
             (product.brandId != null &&
              brands.any((brand) =>
                brand.id == product.brandId &&
                brand.name.toLowerCase().contains(currentSearchQuery)));
    }).toList();

    notifyListeners();
    return searchResults;
  }
}

