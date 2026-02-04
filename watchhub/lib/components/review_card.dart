import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/models/review.dart';
import 'package:watchhub/provider/reviewprovider.dart';
import 'package:watchhub/utils/appconstant.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  final int currentUserId;

  const ReviewCard({
    Key? key,
    required this.review,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _isHelpfulVote = false;
  bool _isProcessingVote = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          widget.review.userName.substring(0, 1).toUpperCase(),
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
                              widget.review.userName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (widget.review.isVerifiedPurchase)
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
                      index < widget.review.rating
                          ? Icons.star
                          : index < widget.review.rating + 0.5
                          ? Icons.star_half
                          : Icons.star_border,
                      color: index < widget.review.rating
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
              widget.review.comment,
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
                  _formatDate(widget.review.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _isProcessingVote
                          ? null
                          : () => _toggleHelpfulVote(),
                      icon: Icon(
                        Icons.thumb_up,
                        size: 16,
                        color: _isHelpfulVote
                            ? Colors.blue[600]
                            : Colors.grey[600],
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32),
                    ),
                    Text(
                      widget.review.helpfulCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _isHelpfulVote
                            ? Colors.blue[600]
                            : Colors.grey[600],
                        fontWeight: _isHelpfulVote ? FontWeight.bold : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'helpful',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Future<void> _toggleHelpfulVote() async {
    if (widget.currentUserId == widget.review.userId) {
      // User cannot vote on their own review
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('You cannot vote on your own review'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      return;
    }

    setState(() => _isProcessingVote = true);

    try {
      final success = await context.read<ReviewProvider>().markReviewHelpful(
        widget.review.id,
        widget.currentUserId as String,
      );

      if (success) {
        setState(() {
          _isHelpfulVote = !_isHelpfulVote;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to update helpful vote'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingVote = false);
      }
    }
  }
}
