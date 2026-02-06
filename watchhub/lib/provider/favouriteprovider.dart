// ignore_for_file: unnecessary_type_check, unnecessary_cast, unnecessary_null_comparison, duplicate_ignore
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/product.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoriteIds = [];
  final Map<int, Product> _cachedProducts = {};
  final Map<int, String> _cachedBrands = {};
  final supabase = Supabase.instance.client;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Public getters
  List<int> get favoriteIds => List.from(_favoriteIds);
  int get favoriteCount => _favoriteIds.length;

  Product? getProductById(int productId) => _cachedProducts[productId];
  String? getBrandNameById(int brandId) => _cachedBrands[brandId];

  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  FavoriteProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final favoritesJson = await _secureStorage.read(key: 'favorites');
      if (favoritesJson != null) {
        final favoritesData = json.decode(favoritesJson) as Map<String, dynamic>;
        final favoriteIds = (favoritesData['ids'] as List<dynamic>).cast<int>();
        _favoriteIds.addAll(favoriteIds);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites from storage: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final favoritesData = {
        'ids': _favoriteIds,
      };
      await _secureStorage.write(key: 'favorites', value: json.encode(favoritesData));
    } catch (e) {
      debugPrint('Error saving favorites to storage: $e');
    }
  }

  // ✅ Toggle favorite WITH product data (RECOMMENDED)
  Future<void> toggleFavoriteWithProduct(Product product, String? brandName) async {
    try {
      if (_favoriteIds.contains(product.id)) {
        _favoriteIds.remove(product.id);
        _cachedProducts.remove(product.id);
      } else {
        _favoriteIds.add(product.id);
        _cachedProducts[product.id] = product;

        if (product.brandId != null && brandName != null && brandName.isNotEmpty) {
          _cachedBrands[product.brandId!] = brandName;
        }
      }
      await _saveToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('Error in toggleFavoriteWithProduct: $e');
      rethrow;
    }
  }

  // ✅ Toggle favorite (with auto-fetch)
  Future<void> toggleFavorite(int productId) async {
    try {
      if (_favoriteIds.contains(productId)) {
        // Remove from favorites
        _favoriteIds.remove(productId);
        _cachedProducts.remove(productId);
        await _saveToStorage();
        notifyListeners();
      } else {
        // Add to favorites
        _favoriteIds.add(productId);
        await _saveToStorage();
        notifyListeners();

        // Fetch product data in background if not cached
        if (!_cachedProducts.containsKey(productId)) {
          await fetchAndCacheProduct(productId);
        }
      }
    } catch (e) {
      debugPrint('Error in toggleFavorite: $e');
      // Don't rethrow - keep the UI working
    }
  }

  Future<void> addToFavorites(int productId) async {
    try {
      if (!_favoriteIds.contains(productId)) {
        _favoriteIds.add(productId);
        await _saveToStorage();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error in addToFavorites: $e');
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    try {
      if (_favoriteIds.contains(productId)) {
        _favoriteIds.remove(productId);
        _cachedProducts.remove(productId);
        await _saveToStorage();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error in removeFromFavorites: $e');
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      _favoriteIds.clear();
      _cachedProducts.clear();
      _cachedBrands.clear();
      await _saveToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('Error in clearAllFavorites: $e');
    }
  }

  // ✅ Fetch single product and cache it
  Future<Product?> fetchAndCacheProduct(int productId) async {
    // Return cached if available
    if (_cachedProducts.containsKey(productId)) {
      return _cachedProducts[productId];
    }

    try {
      final response = await supabase
          .from('tbl_products')
          .select('id, prod_img, prod_name, prod_price, prod_stock, prod_description, prod_brand')
          .eq('id', productId)
          .maybeSingle();

      if (response == null) {
        debugPrint('No product found with id: $productId');
        return null;
      }

      final product = Product.fromJson(response);
      _cachedProducts[productId] = product;

      // Fetch brand name if needed
      if (product.brandId != null && !_cachedBrands.containsKey(product.brandId)) {
        try {
          await fetchBrandName(product.brandId!);
        } catch (e) {
          debugPrint('Error fetching brand for product $productId: $e');
          // Continue even if brand fetch fails
        }
      }

      notifyListeners();
      return product;
    } catch (e) {
      debugPrint('Error fetching product $productId: $e');
      return null;
    }
  }

  // ✅ Fetch and cache brand name
  Future<String> fetchBrandName(int brandId) async {
    // Return cached if available
    if (_cachedBrands.containsKey(brandId)) {
      return _cachedBrands[brandId]!;
    }

    try {
      final response = await supabase
          .from('tbl_brands')
          .select('id, brand_name')
          .eq('id', brandId)
          .maybeSingle();

      if (response == null) {
        debugPrint('No brand found with id: $brandId');
        _cachedBrands[brandId] = 'Unknown';
        return 'Unknown';
      }

      final brandName = response['brand_name'] as String? ?? 'Unknown';
      _cachedBrands[brandId] = brandName;
      notifyListeners();
      return brandName;
    } catch (e) {
      debugPrint('Error fetching brand $brandId: $e');
      _cachedBrands[brandId] = 'Unknown';
      return 'Unknown';
    }
  }

  // ✅ Prefetch all favorite products and brands
  Future<void> prefetchAllFavorites() async {
    if (_favoriteIds.isEmpty) {
      debugPrint('No favorites to prefetch');
      return;
    }

    try {
      debugPrint('Prefetching ${_favoriteIds.length} favorites...');

      // Fetch all products
      final response = await supabase
          .from('tbl_products')
          .select('id, prod_img, prod_name, prod_price, prod_stock, prod_description, prod_brand')
          .inFilter('id', _favoriteIds);

      if (response == null || response is! List || response.isEmpty) {
        debugPrint('No products found for favorites');
        return;
      }

      // Parse products
      for (var productData in response) {
        try {
          final product = Product.fromJson(productData as Map<String, dynamic>);
          _cachedProducts[product.id] = product;
        } catch (e) {
          debugPrint('Error parsing product: $e');
          // Continue with other products
        }
      }

      // Collect unique brand IDs
      final Set<int> brandIds = _cachedProducts.values
          .where((p) => p.brandId != null)
          .map((p) => p.brandId!)
          .toSet();

      // Fetch brands if any
      if (brandIds.isNotEmpty) {
        try {
          final brandsResponse = await supabase
              .from('tbl_brands')
              .select('id, brand_name')
              .inFilter('id', brandIds.toList());

          if (brandsResponse != null && brandsResponse is List) {
            for (var brandData in brandsResponse) {
              try {
                final brandId = brandData['id'] as int;
                final brandName = brandData['brand_name'] as String? ?? 'Unknown';
                _cachedBrands[brandId] = brandName;
              } catch (e) {
                debugPrint('Error parsing brand: $e');
                // Continue with other brands
              }
            }
          }
        } catch (e) {
          debugPrint('Error fetching brands: $e');
          // Don't fail the whole operation if brands fail
        }
      }

      notifyListeners();
      debugPrint('Prefetch completed: ${_cachedProducts.length} products, ${_cachedBrands.length} brands cached');
    } catch (e, stackTrace) {
      debugPrint('Error prefetching favorites: $e');
      debugPrint(stackTrace.toString());
      // Don't rethrow - let the UI handle gracefully
    }
  }

  // ✅ Check if product data is loaded
  bool isProductLoaded(int productId) {
    return _cachedProducts.containsKey(productId);
  }

  // ✅ Get loading status for a product
  bool needsLoading(int productId) {
    return _favoriteIds.contains(productId) && !_cachedProducts.containsKey(productId);
  }
}