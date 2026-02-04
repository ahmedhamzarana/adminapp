import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/provider/reviewprovider.dart';
import 'package:watchhub/utils/appconstant.dart';

class ReviewSubmission extends StatefulWidget {
  final int productId;
  final String productName;
  final String userId;
  final String userName;

  const ReviewSubmission({
    Key? key,
    required this.productId,
    required this.productName,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<ReviewSubmission> createState() => _ReviewSubmissionState();
}

class _ReviewSubmissionState extends State<ReviewSubmission> {
  final _formKey = GlobalKey<FormState>();
  int _selectedRating = 0;
  String _comment = '';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Write a Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appconstant.appmaincolor,
                ),
              ),
              const SizedBox(height: 16),

              // Rating selection
              Text(
                'Rate this product:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = index + 1),
                    child: Icon(
                      index < _selectedRating
                          ? Icons.star
                          : index < _selectedRating + 0.5
                          ? Icons.star_half
                          : Icons.star_border,
                      color: index < _selectedRating
                          ? Colors.amber
                          : Colors.grey,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Comment field
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Your review',
                  hintText: 'Share your experience with this product...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  if (value.length < 10) {
                    return 'Review should be at least 10 characters';
                  }
                  return null;
                },
                onChanged: (value) => _comment = value,
              ),
              const SizedBox(height: 16),

              // Submit button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _selectedRating > 0 && !_isSubmitting
                      ? _submitReview
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appconstant.barcolor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Submitting...'),
                          ],
                        )
                      : const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final success = await context.read<ReviewProvider>().submitReview(
        productId: widget.productId,
        userId: widget.userId,
        userName: widget.userName,
        rating: _selectedRating,
        comment: _comment,
      );

      if (success) {
        setState(() {
          _selectedRating = 0;
          _comment = '';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Thank you for your review!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to submit review. Please try again.'),
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
        setState(() => _isSubmitting = false);
      }
    }
  }
}
