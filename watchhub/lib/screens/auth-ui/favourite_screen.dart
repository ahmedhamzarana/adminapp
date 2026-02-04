import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/provider/favouriteprovider.dart';
import 'package:watchhub/provider/cartprovider.dart';
import 'package:watchhub/models/cartitem.dart';
import 'package:watchhub/models/product.dart';
import 'package:watchhub/utils/appconstant.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      
      print('Loading favorites... Count: ${favoriteProvider.favoriteIds.length}');
      
      await favoriteProvider.prefetchAllFavorites();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading favorites: $e');
      print('Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load favorites. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final favoriteIds = favoriteProvider.favoriteIds;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Appconstant.appmaincolor,
            leading: IconButton(
              icon: const Icon(
                CupertinoIcons.back,
                color: Appconstant.barcolor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "My Wishlist",
              style: TextStyle(
                color: Appconstant.barcolor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              if (favoriteIds.isNotEmpty && !_isLoading)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      color: Appconstant.barcolor,
                    ),
                    onPressed: () {
                      _showClearAllDialog(context);
                    },
                  ),
                ),
            ],
          ),
          body: _buildBody(favoriteProvider, favoriteIds),
        );
      },
    );
  }

  Widget _buildBody(FavoriteProvider favoriteProvider, List<int> favoriteIds) {
    // Show error message if there's an error
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadFavorites,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Appconstant.appmaincolor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    // Show loading indicator
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Appconstant.appmaincolor,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              "Loading your favorites...",
              style: TextStyle(
                fontSize: 14,
                color: Appconstant.appmaincolor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (favoriteIds.isEmpty) {
      return _buildEmptyState();
    }

    // Show favorites list
    return Column(
      children: [
        // Header with count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Appconstant.barcolor.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Appconstant.barcolor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${favoriteIds.length} ${favoriteIds.length == 1 ? 'Item' : 'Items'}',
                      style: const TextStyle(
                        color: Appconstant.barcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Favorites List
        Expanded(
          child: RefreshIndicator(
            color: Appconstant.appmaincolor,
            onRefresh: _loadFavorites,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: favoriteIds.length,
              itemBuilder: (context, index) {
                final productId = favoriteIds[index];
                return _buildFavoriteCard(
                  productId,
                  favoriteProvider,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ================= EMPTY STATE =================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withAlpha(15),
            ),
            child: Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "No Favorites Yet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Start adding watches to your favorites and they'll appear here!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            label: const Text(
              "Browse Watches",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Appconstant.barcolor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FAVORITE CARD =================
  Widget _buildFavoriteCard(int productId, FavoriteProvider favoriteProvider) {
    final cachedProduct = favoriteProvider.getProductById(productId);

    if (cachedProduct == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Appconstant.appmaincolor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Watch Image
              Container(
                width: 120,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: Image.network(
                    cachedProduct.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: Appconstant.appmaincolor,
                          strokeWidth: 2,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.watch,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),

              // Watch Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Brand Badge
                      if (cachedProduct.brandId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Appconstant.appmaincolor.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            favoriteProvider.getBrandNameById(
                                  cachedProduct.brandId!,
                                ) ?? 'Brand',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Appconstant.appmaincolor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Appconstant.appmaincolor.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Unknown Brand',
                            style: TextStyle(
                              fontSize: 11,
                              color: Appconstant.appmaincolor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Watch Name
                      Text(
                        cachedProduct.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Price
                      Row(
                        children: [
                          const Text(
                            'PKR ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Appconstant.barcolor,
                            ),
                          ),
                          Text(
                            cachedProduct.price.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Appconstant.barcolor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Action Buttons (Top Right)
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Move to Cart Button
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.green,
                      size: 20,
                    ),
                    onPressed: () {
                      _moveToCart(
                        context,
                        cachedProduct,
                        favoriteProvider,
                      );
                    },
                  ),
                ),
                // Remove from Favorites Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () {
                      _showRemoveDialog(
                        context,
                        cachedProduct.name,
                        cachedProduct.id,
                        favoriteProvider,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= MOVE TO CART FUNCTION =================
  void _moveToCart(
    BuildContext context,
    Product cachedProduct,
    FavoriteProvider favoriteProvider,
  ) {
    // Add the product to cart
    final cartItem = CartItem(
      id: cachedProduct.id,
      name: cachedProduct.name,
      image: cachedProduct.image,
      price: cachedProduct.price.toInt(),
      quantity: 1, // Default quantity is 1
      stock: cachedProduct.stock,
    );

    // Access the cart provider and add the item
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(cartItem);

    // Show success snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Added to cart successfully!",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ================= REMOVE CONFIRMATION DIALOG =================
  void _showRemoveDialog(
    BuildContext context,
    String watchName,
    int productId,
    FavoriteProvider favoriteProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.favorite_border, color: Colors.red),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Remove Favorite?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "Do you want to remove '$watchName' from your favorites?",
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                await favoriteProvider.removeFromFavorites(productId);
                Navigator.pop(dialogContext);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text("Removed from favorites"),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red[400],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "Remove",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= CLEAR ALL DIALOG =================
  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.delete_sweep, color: Colors.red, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Clear All Favorites?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: const Text(
                "This will remove all watches from your favorites list. This action cannot be undone.",
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    await favoriteProvider.clearAllFavorites();
                    Navigator.pop(dialogContext);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Text("All favorites cleared"),
                            ],
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Clear All",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}