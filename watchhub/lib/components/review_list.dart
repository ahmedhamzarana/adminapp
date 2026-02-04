import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/components/review_card.dart';
import 'package:watchhub/provider/reviewprovider.dart';
import 'package:watchhub/utils/appconstant.dart';

class ReviewList extends StatefulWidget {
  final int productId;
  final int currentUserId;
  final String productName;

  const ReviewList({
    Key? key,
    required this.productId,
    required this.currentUserId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  String _sortBy = 'newest';
  int? _filterByRating;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    await context.read<ReviewProvider>().fetchReviewsForProduct(
      widget.productId,
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        final reviews = reviewProvider.getReviewsForProduct(
          widget.productId,
          sortBy: _sortBy,
        );
        final filteredReviews = _filterByRating != null
            ? reviews
                  .where((review) => review.rating == _filterByRating)
                  .toList()
            : reviews;

        final averageRating = reviewProvider.getProductAverageRating(
          widget.productId,
        );
        final totalReviews = reviewProvider.getProductTotalReviews(
          widget.productId,
        );

        return Column(
          children: [
            _buildReviewsHeader(averageRating, totalReviews),
            _buildControls(),
            const SizedBox(height: 16),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(color: Appconstant.barcolor),
                ),
              )
            else if (filteredReviews.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.reviews_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reviews yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to review this product!',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadReviews,
                  color: Appconstant.barcolor,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      return ReviewCard(
                        review: filteredReviews[index],
                        currentUserId: widget.currentUserId,
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildReviewsHeader(double averageRating, int totalReviews) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Appconstant.appmaincolor,
                ),
              ),
              const Spacer(),
              Text(
                '$totalReviews Reviews',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ...List.generate(5, (index) {
                    return Icon(
                      index < averageRating.floor()
                          ? Icons.star
                          : index < averageRating
                          ? Icons.star_half
                          : Icons.star_border,
                      color: index < averageRating ? Colors.amber : Colors.grey,
                      size: 16,
                    );
                  }),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                '($totalReviews)',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(
                labelText: 'Sort by',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'newest', child: Text('Newest First')),
                DropdownMenuItem(value: 'helpful', child: Text('Most Helpful')),
                DropdownMenuItem(value: 'oldest', child: Text('Oldest')),
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
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<int?>(
              value: _filterByRating,
              decoration: const InputDecoration(
                labelText: 'Filter',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Ratings')),
                ...List.generate(5, (index) {
                  return DropdownMenuItem(
                    value: 5 - index,
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
                            size: 14,
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
        ],
      ),
    );
  }
}
