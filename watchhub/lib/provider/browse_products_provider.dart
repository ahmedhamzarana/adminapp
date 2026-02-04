import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/brands.dart';
import 'package:watchhub/models/product.dart';

enum SortOption { none, priceLowToHigh, priceHighToLow, brandAZ, brandZA }

class BrowseProductsProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Brand> _allBrands = [];

  List<String> _uniqueTypes = [];
  List<String> _uniqueCategories = [];
  List<String> _uniqueColors = [];
  List<String> _uniqueMaterials = [];
  List<String> _uniqueGenders = [];

  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Brand> get allBrands => _allBrands;

  List<String> get uniqueTypes => _uniqueTypes;
  List<String> get uniqueCategories => _uniqueCategories;
  List<String> get uniqueColors => _uniqueColors;
  List<String> get uniqueMaterials => _uniqueMaterials;
  List<String> get uniqueGenders => _uniqueGenders;

  bool isLoading = false;
  String errorMessage = '';

  SortOption _currentSortOption = SortOption.none;
  SortOption get currentSortOption => _currentSortOption;

  // Store current filter values
  int? _currentBrandId;
  String? _currentType;
  String? _currentCategory;
  String? _currentColor;
  String? _currentMaterial;
  String? _currentGender;
  double? _currentMinPrice;
  double? _currentMaxPrice;

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchAllProducts(),
      fetchAllBrands(),
    ]);

    _extractUniqueValues();
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllBrands() async {
    try {
      final response = await supabase
          .from('tbl_brand')
          .select('*')
          .order('created_at', ascending: false);

      _allBrands = (response as List)
          .map((e) => Brand.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('Error fetching brands: $e');
      errorMessage = 'Failed to load brands';
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      final response = await supabase
          .from('tbl_products')
          .select('*')
          .order('created_at', ascending: false);

      _allProducts =
          (response as List).map((e) => Product.fromJson(e)).toList();

      _filteredProducts = [..._allProducts];
    } catch (e) {
      debugPrint('Error fetching products: $e');
      errorMessage = 'Failed to load products';
    }
  }

  void _extractUniqueValues() {
    _uniqueTypes = _allProducts
        .where((p) => p.type != null && p.type!.trim().isNotEmpty)
        .map((p) => p.type!.trim())
        .toSet()
        .toList()
      ..sort();

    _uniqueCategories = _allProducts
        .where((p) => p.category != null && p.category!.trim().isNotEmpty)
        .map((p) => p.category!.trim())
        .toSet()
        .toList()
      ..sort();

    _uniqueColors = _allProducts
        .where((p) => p.color != null && p.color!.trim().isNotEmpty)
        .map((p) => p.color!.trim())
        .toSet()
        .toList()
      ..sort();

    _uniqueMaterials = _allProducts
        .where((p) => p.material != null && p.material!.trim().isNotEmpty)
        .map((p) => p.material!.trim())
        .toSet()
        .toList()
      ..sort();

    _uniqueGenders = _allProducts
        .where((p) => p.gender != null && p.gender!.trim().isNotEmpty)
        .map((p) => p.gender!.trim())
        .toSet()
        .toList()
      ..sort();
  }

  /// Filter products based on multiple criteria
  void filterProducts({
    int? brandId,
    String? type,
    String? category,
    String? color,
    String? material,
    String? gender,
    double? minPrice,
    double? maxPrice,
  }) {
    // Store current filter values
    _currentBrandId = brandId;
    _currentType = type;
    _currentCategory = category;
    _currentColor = color;
    _currentMaterial = material;
    _currentGender = gender;
    _currentMinPrice = minPrice;
    _currentMaxPrice = maxPrice;

    _filteredProducts = _allProducts.where((product) {
      // Brand filter
      if (brandId != null && product.brandId != brandId) {
        return false;
      }

      // Type filter
      if (type != null && type.isNotEmpty) {
        if (product.type == null || 
            product.type!.trim().toLowerCase() != type.trim().toLowerCase()) {
          return false;
        }
      }

      // Category filter
      if (category != null && category.isNotEmpty) {
        if (product.category == null || 
            product.category!.trim().toLowerCase() != category.trim().toLowerCase()) {
          return false;
        }
      }

      // Color filter
      if (color != null && color.isNotEmpty) {
        if (product.color == null || 
            product.color!.trim().toLowerCase() != color.trim().toLowerCase()) {
          return false;
        }
      }

      // Material filter
      if (material != null && material.isNotEmpty) {
        if (product.material == null || 
            product.material!.trim().toLowerCase() != material.trim().toLowerCase()) {
          return false;
        }
      }

      // Gender filter
      if (gender != null && gender.isNotEmpty) {
        if (product.gender == null || 
            product.gender!.trim().toLowerCase() != gender.trim().toLowerCase()) {
          return false;
        }
      }

      // Price range filter
      if (minPrice != null && product.price < minPrice) {
        return false;
      }
      if (maxPrice != null && product.price > maxPrice) {
        return false;
      }

      return true;
    }).toList();

    // Reapply current sort
    _applySorting();
    
    notifyListeners();
  }

  void resetFilters() {
    _currentBrandId = null;
    _currentType = null;
    _currentCategory = null;
    _currentColor = null;
    _currentMaterial = null;
    _currentGender = null;
    _currentMinPrice = null;
    _currentMaxPrice = null;
    _currentSortOption = SortOption.none;
    
    _filteredProducts = [..._allProducts];
    notifyListeners();
  }

  void sortProducts(SortOption option) {
    _currentSortOption = option;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    switch (_currentSortOption) {
      case SortOption.priceLowToHigh:
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.brandAZ:
        _filteredProducts.sort((a, b) {
          final nameA = _getBrandName(a.brandId).toLowerCase();
          final nameB = _getBrandName(b.brandId).toLowerCase();
          return nameA.compareTo(nameB);
        });
        break;
      case SortOption.brandZA:
        _filteredProducts.sort((a, b) {
          final nameA = _getBrandName(a.brandId).toLowerCase();
          final nameB = _getBrandName(b.brandId).toLowerCase();
          return nameB.compareTo(nameA);
        });
        break;
      case SortOption.none:
        // Keep original order from database
        break;
    }
  }

  String _getBrandName(int? id) {
    if (id == null) return '';
    try {
      final brand = _allBrands.firstWhere(
        (b) => b.id == id,
        orElse: () => Brand(id: 0, name: '', imageUrl: ''),
      );
      return brand.name;
    } catch (e) {
      return '';
    }
  }

  // Helper method to get active filter count
  int get activeFilterCount {
    int count = 0;
    if (_currentBrandId != null) count++;
    if (_currentType != null) count++;
    if (_currentCategory != null) count++;
    if (_currentColor != null) count++;
    if (_currentMaterial != null) count++;
    if (_currentGender != null) count++;
    if (_currentMinPrice != null && _currentMinPrice! > 0) count++;
    if (_currentMaxPrice != null && _currentMaxPrice! < 100000) count++;
    return count;
  }
}