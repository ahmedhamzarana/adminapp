// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/models/product.dart';
import 'package:watchhub/provider/home_provider.dart';
import 'package:watchhub/components/product_detail.dart';
import 'package:watchhub/utils/appconstant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with empty search
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch('');
    });
  }

  void _performSearch(String query) {
    final homeProvider = context.read<HomeProvider>();
    homeProvider.searchProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final searchResults = homeProvider.searchResults;
        final isSearching = homeProvider.currentSearchQuery.isNotEmpty;
        final hasResults = searchResults.isNotEmpty;
        final hasNoResults = isSearching && !hasResults;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Appconstant.appmaincolor,
            title: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search watches...",
                border: InputBorder.none,
                hintStyle: TextStyle(color:  Appconstant.barcolor),
              ),
              style: const TextStyle(color: Appconstant.barcolor),
              onChanged: _performSearch,
              autofocus: true,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
            ],
          ),
          body: hasNoResults
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No watches found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Try adjusting your search term',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : !isSearching
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Search for watches',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Type something to begin searching',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        // Refresh the search if there was a query
                        if (homeProvider.currentSearchQuery.isNotEmpty) {
                          _performSearch(homeProvider.currentSearchQuery);
                        } else {
                          // Refresh all products
                          await context.read<HomeProvider>().fetchAllProducts();
                        }
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final product = searchResults[index];
                          return _buildProductCard(product);
                        },
                      ),
                    ),
        );
      },
    );
  }

  // ================= PRODUCT CARD =================
  Widget _buildProductCard(Product product) {
    final isOutOfStock = product.stock <= 0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(id: product.id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                product.image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(Icons.watch,
                      size: 40, color: Colors.grey[400]),
                ),
              ),
            ),

            // DETAILS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "Rs ${_formatPrice(product.price)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700] ?? Colors.deepOrange,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // STOCK BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.stock <= 0
                            ? Colors.red
                            : product.stock <= 5
                                ? Colors.orange // Red alert for low stock
                                : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.stock <= 0
                            ? "Out of Stock"
                            : product.stock <= 5
                                ? "Low Stock (${product.stock})"
                                : "Stock: ${product.stock}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FORMAT PRICE =================
  String _formatPrice(dynamic price) {
    final value = price.toString().split('.')[0];
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}