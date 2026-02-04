import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/models/review.dart';
import 'package:watchhub/provider/reviewprovider.dart';
import 'package:watchhub/utils/appconstant.dart';

class ReviewListScreen extends StatefulWidget {
  final int productId;
  final String productName;

  const ReviewListScreen({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  String _sortBy = 'date'; // Default sort by date
  int? _filterByRating; // Optional rating filter

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().fetchReviewsForProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Appconstant.barcolor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reviews for ${widget.productName}',
          style: TextStyle(
            color: Appconstant.barcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          final reviews = reviewProvider.getReviewsForProduct(widget.productId, sortBy: _sortBy);
          final filteredReviews = _filterByRating != null
              ? reviews.where((review) => review.rating == _filterByRating).toList()
              : reviews;

          final averageRating = reviewProvider.getProductAverageRating(widget.productId);
          final totalReviews = reviewProvider.getProductTotalReviews(widget.productId);

          return Column(
            children: [
              // Stats header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Appconstant.barcolor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < averageRating.floor()
                                    ? Icons.star
                                    : index < averageRating
                                        ? Icons.star_half
                                        : Icons.star_border,
                                color: index < averageRating ? Colors.amber : Colors.grey,
                                size: 14,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$totalReviews Reviews',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'for ${widget.productName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Controls for sorting and filtering
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Sort by dropdown
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _sortBy,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text('Sort by'),
                          items: const [
                            DropdownMenuItem(
                              value: 'date',
                              child: Text('Newest First'),
                            ),
                            DropdownMenuItem(
                              value: 'helpful',
                              child: Text('Most Helpful'),
                            ),
                            DropdownMenuItem(
                              value: 'newest',
                              child: Text('Newest'),
                            ),
                            DropdownMenuItem(
                              value: 'oldest',
                              child: Text('Oldest'),
                            ),
                            DropdownMenuItem(
                              value: 'highest_rating',
                              child: Text('Highest Rating'),
                            ),
                            DropdownMenuItem(
                              value: 'lowest_rating',
                              child: Text('Lowest Rating'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _sortBy = value);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Filter by rating dropdown
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<int?>(
                          value: _filterByRating,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text('Filter'),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('All Ratings'),
                            ),
                            ...List.generate(5, (index) {
                              return DropdownMenuItem(
                                value: 5 - index, // Show 5 stars first
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < 5 - index
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: starIndex < 5 - index
                                            ? Colors.amber
                                            : Colors.grey,
                                        size: 12,
                                      );
                                    }),
                                    const SizedBox(width: 4),
                                    Text('${5 - index}★'),
                                  ],
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() => _filterByRating = value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Reviews list
              Expanded(
                child: filteredReviews.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.reviews_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No reviews yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Be the first to review this product!',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => reviewProvider.fetchReviewsForProduct(widget.productId),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredReviews.length,
                          itemBuilder: (context, index) {
                            final review = filteredReviews[index];
                            return _buildReviewCard(review);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Appconstant.appmaincolor,
                        child: Text(
                          review.userName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (review.isVerifiedPurchase)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 12,
                                    color: Colors.green[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified Purchase',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green[600],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating stars
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating
                          ? Icons.star
                          : index < review.rating + 0.5
                              ? Icons.star_half
                              : Icons.star_border,
                      color: index < review.rating
                          ? Colors.amber
                          : Colors.grey,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Review comment
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),

            // Date and helpful section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(review.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review.helpfulCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}