import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/components/product_detail.dart';
import 'package:watchhub/models/product.dart';
import 'package:watchhub/provider/browse_products_provider.dart';
import 'package:watchhub/utils/appconstant.dart';

class BrowseProductsScreen extends StatefulWidget {
  const BrowseProductsScreen({super.key});

  @override
  State<BrowseProductsScreen> createState() => _BrowseProductsScreenState();
}

class _BrowseProductsScreenState extends State<BrowseProductsScreen> {
  String? _selectedBrand;
  String? _selectedType;
  String? _selectedCategory;
  String? _selectedColor;
  String? _selectedMaterial;
  String? _selectedGender;
  double _minPrice = 0;
  double _maxPrice = 100000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrowseProductsProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appconstant.appmaincolor,
        title: const Text(
          "Browse Watches",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          Consumer<BrowseProductsProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.sort_rounded, color: Colors.white),
                    onPressed: _showSortDialog,
                  ),
                  if (provider.currentSortOption != SortOption.none)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Appconstant.barcolor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Consumer<BrowseProductsProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
                    onPressed: _showFilterDialog,
                  ),
                  if (provider.activeFilterCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Appconstant.barcolor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${provider.activeFilterCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<BrowseProductsProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Appconstant.appmaincolor,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading watches...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.filteredProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.watch_off_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No watches found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try adjusting your filters",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedBrand = null;
                        _selectedType = null;
                        _selectedCategory = null;
                        _selectedColor = null;
                        _selectedMaterial = null;
                        _selectedGender = null;
                        _minPrice = 0;
                        _maxPrice = 100000;
                      });
                      provider.resetFilters();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appconstant.appmaincolor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Results count banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Appconstant.appmaincolor.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: Appconstant.appmaincolor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.watch_outlined,
                      size: 20,
                      color: Appconstant.appmaincolor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${provider.filteredProducts.length} ${provider.filteredProducts.length == 1 ? 'Watch' : 'Watches'} Found',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Appconstant.appmaincolor,
                      ),
                    ),
                  ],
                ),
              ),
              // Products Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: provider.filteredProducts.length,
                  itemBuilder: (_, i) {
                    final product = provider.filteredProducts[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(id: product.id),
                          ),
                        );
                      },
                      child: _buildProductCard(product, provider),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, BrowseProductsProvider provider) {
    final brandName = provider.allBrands
        .where((b) => b.id == product.brandId)
        .map((b) => b.name)
        .firstOrNull ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.watch_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Price badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Appconstant.barcolor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'PKR ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (brandName.isNotEmpty)
                        Text(
                          brandName.toUpperCase(),
                          style: TextStyle(
                            color: Appconstant.appmaincolor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  // View Details button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Appconstant.appmaincolor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'View Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Appconstant.appmaincolor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSortDialog() async {
    showDialog(
      context: context,
      builder: (_) => Consumer<BrowseProductsProvider>(
        builder: (_, provider, __) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Appconstant.appmaincolor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.sort_rounded,
                        color: Appconstant.appmaincolor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Sort By",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...SortOption.values.map((option) {
                  final isSelected = provider.currentSortOption == option;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appconstant.appmaincolor.withOpacity(0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Appconstant.appmaincolor
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<SortOption>(
                      title: Text(
                        _getSortOptionText(option),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Appconstant.appmaincolor
                              : Colors.black87,
                        ),
                      ),
                      value: option,
                      groupValue: provider.currentSortOption,
                      activeColor: Appconstant.appmaincolor,
                      onChanged: (v) {
                        provider.sortProducts(v!);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.priceLowToHigh:
        return "Price: Low to High";
      case SortOption.priceHighToLow:
        return "Price: High to Low";
      case SortOption.brandAZ:
        return "Brand: A to Z";
      case SortOption.brandZA:
        return "Brand: Z to A";
      case SortOption.none:
        return "Default Order";
    }
  }

  Future<void> _showFilterDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<BrowseProductsProvider>(
              builder: (context, provider, child) {
                return StatefulBuilder(
                  builder: (dialogContext, setDialogState) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Drag Handle
                          Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          // Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Appconstant.appmaincolor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.tune_rounded,
                                    color: Appconstant.appmaincolor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    "Filter Watches",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => Navigator.of(context).pop(),
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey[200]),
                          // Scrollable Filters
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Brand Filter
                                  _buildFilterSection(
                                    'Brand',
                                    Icons.verified_outlined,
                                    _buildDropdown(
                                      label: 'Select Brand',
                                      value: _selectedBrand,
                                      items: provider.allBrands.map((brand) {
                                        return DropdownMenuItem(
                                          value: brand.id.toString(),
                                          child: Text(brand.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setDialogState(() {
                                          _selectedBrand = value;
                                        });
                                      },
                                    ),
                                  ),

                                  // Type Filter
                                  if (provider.uniqueTypes.isNotEmpty)
                                    _buildFilterSection(
                                      'Type',
                                      Icons.category_outlined,
                                      _buildDropdown(
                                        label: 'Select Type',
                                        value: _selectedType,
                                        items: provider.uniqueTypes.map((type) {
                                          return DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            _selectedType = value;
                                          });
                                        },
                                      ),
                                    ),

                                  // Category Filter
                                  if (provider.uniqueCategories.isNotEmpty)
                                    _buildFilterSection(
                                      'Category',
                                      Icons.style_outlined,
                                      _buildDropdown(
                                        label: 'Select Category',
                                        value: _selectedCategory,
                                        items: provider.uniqueCategories.map((cat) {
                                          return DropdownMenuItem(
                                            value: cat,
                                            child: Text(cat),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            _selectedCategory = value;
                                          });
                                        },
                                      ),
                                    ),

                                  // Color Filter
                                  if (provider.uniqueColors.isNotEmpty)
                                    _buildFilterSection(
                                      'Color',
                                      Icons.palette_outlined,
                                      _buildDropdown(
                                        label: 'Select Color',
                                        value: _selectedColor,
                                        items: provider.uniqueColors.map((color) {
                                          return DropdownMenuItem(
                                            value: color,
                                            child: Text(color),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            _selectedColor = value;
                                          });
                                        },
                                      ),
                                    ),

                                  // Material Filter
                                  if (provider.uniqueMaterials.isNotEmpty)
                                    _buildFilterSection(
                                      'Material',
                                      Icons.texture_outlined,
                                      _buildDropdown(
                                        label: 'Select Material',
                                        value: _selectedMaterial,
                                        items: provider.uniqueMaterials.map((mat) {
                                          return DropdownMenuItem(
                                            value: mat,
                                            child: Text(mat),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            _selectedMaterial = value;
                                          });
                                        },
                                      ),
                                    ),

                                  // Gender Filter
                                  if (provider.uniqueGenders.isNotEmpty)
                                    _buildFilterSection(
                                      'Gender',
                                      Icons.wc_outlined,
                                      _buildDropdown(
                                        label: 'Select Gender',
                                        value: _selectedGender,
                                        items: provider.uniqueGenders.map((gender) {
                                          return DropdownMenuItem(
                                            value: gender,
                                            child: Text(gender),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            _selectedGender = value;
                                          });
                                        },
                                      ),
                                    ),

                                  // Price Range
                                  _buildFilterSection(
                                    'Price Range',
                                    Icons.payments_outlined,
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Appconstant.appmaincolor.withOpacity(0.03),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Appconstant.appmaincolor.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildPriceLabel(
                                                'Min',
                                                _minPrice.toStringAsFixed(0),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Appconstant.barcolor.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  'to',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              _buildPriceLabel(
                                                'Max',
                                                _maxPrice.toStringAsFixed(0),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          RangeSlider(
                                            min: 0,
                                            max: 100000,
                                            divisions: 100,
                                            values: RangeValues(_minPrice, _maxPrice),
                                            activeColor: Appconstant.appmaincolor,
                                            inactiveColor: Colors.grey[300],
                                            labels: RangeLabels(
                                              'PKR ${_minPrice.toStringAsFixed(0)}',
                                              'PKR ${_maxPrice.toStringAsFixed(0)}',
                                            ),
                                            onChanged: (values) {
                                              setDialogState(() {
                                                _minPrice = values.start;
                                                _maxPrice = values.end;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Bottom Buttons
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setDialogState(() {
                                        _selectedBrand = null;
                                        _selectedType = null;
                                        _selectedCategory = null;
                                        _selectedColor = null;
                                        _selectedMaterial = null;
                                        _selectedGender = null;
                                        _minPrice = 0;
                                        _maxPrice = 100000;
                                      });
                                      provider.resetFilters();
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.refresh_rounded, size: 20),
                                    label: const Text('Reset'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red, width: 2),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      int? brandId = _selectedBrand != null
                                          ? int.tryParse(_selectedBrand!)
                                          : null;

                                      provider.filterProducts(
                                        brandId: brandId,
                                        type: _selectedType,
                                        category: _selectedCategory,
                                        color: _selectedColor,
                                        material: _selectedMaterial,
                                        gender: _selectedGender,
                                        minPrice: _minPrice,
                                        maxPrice: _maxPrice,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.check_rounded, size: 20),
                                    label: const Text('Apply Filters'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Appconstant.appmaincolor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(String title, IconData icon, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Appconstant.appmaincolor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildPriceLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Appconstant.appmaincolor.withOpacity(0.3)),
          ),
          child: Text(
            'PKR $value',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Appconstant.appmaincolor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Appconstant.appmaincolor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Appconstant.appmaincolor,
      ),
      dropdownColor: Colors.white,
      items: items,
      onChanged: onChanged,
    );
  }
}