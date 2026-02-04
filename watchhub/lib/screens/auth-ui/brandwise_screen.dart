import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/components/product_detail.dart';
import 'package:watchhub/models/product.dart';
import 'package:watchhub/provider/brandwise_provider.dart';
import 'package:watchhub/utils/appconstant.dart';

class BrandWiseScreen extends StatefulWidget {
  final int brandId;
  final String brandName;
  final String brandLogo;

  const BrandWiseScreen({
    super.key,
    required this.brandId,
    required this.brandName,
    required this.brandLogo,
  });

  @override
  State<BrandWiseScreen> createState() => _BrandWiseScreenState();
}

class _BrandWiseScreenState extends State<BrandWiseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<BrandWiseProvider>()
          .fetchBrandProducts(widget.brandId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandWiseProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Appconstant.barcolor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.brandName,
          style: const TextStyle(
            color: Appconstant.barcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildBrandHeader(),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  // ================= BRAND HEADER =================
  Widget _buildBrandHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[100],
            backgroundImage: NetworkImage(widget.brandLogo),
          ),
          const SizedBox(height: 12),
          Text(
            widget.brandName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ================= BODY =================
  Widget _buildBody(BrandWiseProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () =>
                  provider.fetchBrandProducts(widget.brandId),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Appconstant.barcolor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (provider.products.isEmpty) {
      return Center(
        child: Text(
          "No products found",
          style:
              TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return GridView.builder(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        return _buildProductCard(product);
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
          builder: (_) =>
              ProductDetailScreen(id: product.id),
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
                        color: Appconstant.barcolor,
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
}
