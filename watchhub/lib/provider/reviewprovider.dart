// ignore_for_file: unnecessary_cast, unnecessary_type_check, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/review.dart';

class ReviewProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Map<int, List<Review>> _reviewsByProduct = {};
  final Map<String, bool> _userHelpfulVotes = {};
  bool _isLoading = false;

  ReviewProvider() {
    _loadCachedData();
  }

  bool get isLoading => _isLoading;
  Map<int, List<Review>> get reviewsByProduct => _reviewsByProduct;

  Future<void> _loadCachedData() async {
    try {
      String? cachedReviews = await _storage.read(key: 'cached_reviews');
      if (cachedReviews != null) {
        await _deserializeReviews(cachedReviews);
      }

      String? cachedVotes = await _storage.read(key: 'cached_helpful_votes');
      if (cachedVotes != null) {
        await _deserializeVotes(cachedVotes);
      }
    } catch (e) {
      print('Error loading cached data: $e');
    }
  }

  Future<void> _cacheData() async {
    try {
      String serializedReviews = _serializeReviews();
      await _storage.write(key: 'cached_reviews', value: serializedReviews);

      String serializedVotes = _serializeVotes();
      await _storage.write(key: 'cached_helpful_votes', value: serializedVotes);
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  String _serializeReviews() {
    Map<String, dynamic> jsonMap = {};
    _reviewsByProduct.forEach((productId, reviews) {
      jsonMap[productId.toString()] = reviews.map((review) => review.toJson()).toList();
    });
    return _encodeJson(jsonMap);
  }

  Future<void> _deserializeReviews(String jsonString) async {
    try {
      Map<String, dynamic>? jsonMap = _decodeJson(jsonString);
      if (jsonMap != null) {
        _reviewsByProduct.clear();
        jsonMap.forEach((key, value) {
          if (value is List) {
            List<Review> reviews = (value as List)
                .map((json) => Review.fromJson(json as Map<String, dynamic>))
                .toList();
            _reviewsByProduct[int.parse(key)] = reviews;
          }
        });
        notifyListeners();
      }
    } catch (e) {
      print('Error deserializing reviews: $e');
    }
  }

  String _serializeVotes() {
    Map<String, dynamic> jsonMap = {};
    _userHelpfulVotes.forEach((key, value) {
      jsonMap[key] = value;
    });
    return _encodeJson(jsonMap);
  }

  Future<void> _deserializeVotes(String jsonString) async {
    try {
      Map<String, dynamic>? jsonMap = _decodeJson(jsonString);
      if (jsonMap != null) {
        _userHelpfulVotes.clear();
        jsonMap.forEach((key, value) {
          if (value is bool) {
            _userHelpfulVotes[key] = value;
          }
        });
      }
    } catch (e) {
      print('Error deserializing votes: $e');
    }
  }

  String _encodeJson(Object obj) {
    return jsonEncode(obj);
  }

  Map<String, dynamic>? _decodeJson(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print('Error decoding JSON: $e');
      return null;
    }
  }

  List<Review> getReviewsForProduct(int productId, {String sortBy = 'date'}) {
    List<Review> reviews = List.from(_reviewsByProduct[productId] ?? []);

    switch (sortBy) {
      case 'helpful':
        reviews.sort((a, b) {
          if (b.helpfulCount != a.helpfulCount) {
            return b.helpfulCount.compareTo(a.helpfulCount);
          }
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'newest':
      case 'date':
        reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        reviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'highest_rating':
        reviews.sort((a, b) {
          if (b.rating != a.rating) {
            return b.rating.compareTo(a.rating);
          }
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'lowest_rating':
        reviews.sort((a, b) {
          if (a.rating != b.rating) {
            return a.rating.compareTo(b.rating);
          }
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      default:
        reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return reviews;
  }

  Future<bool> submitReview({
    required int productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
    bool isVerifiedPurchase = false,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      String actualUserName = userName;
      
      try {
        final userResponse = await supabase
            .from('tbl_users')
            .select('name')
            .eq('user_id', userId)
            .maybeSingle();

        if (userResponse != null) {
          actualUserName = userResponse['name'] ?? userName;
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }

      final newReview = {
        'product_id': productId,
        'user_id': userId,
        'user_name': actualUserName,
        'rating': rating,
        'comment': comment,
        'is_verified_purchase': isVerifiedPurchase,
        'helpful_count': 0,
      };

      final response = await supabase
          .from('tbl_reviews')
          .insert(newReview)
          .select()
          .single();

      final review = Review.fromJson(response);

      if (!_reviewsByProduct.containsKey(productId)) {
        _reviewsByProduct[productId] = [];
      }
      _reviewsByProduct[productId]!.add(review);

      await _cacheData();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      print('Error submitting review: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> hasUserPurchasedProduct(String userId, int productId) async {
    try {
      final response = await supabase
          .from('tbl_orders')
          .select('id')
          .eq('user_id', userId)
          .eq('prod_id', productId)
          .limit(1);

      return response != null && response.isNotEmpty;
    } catch (e) {
      print('Error checking purchase history: $e');
      return false;
    }
  }

  Future<bool> markReviewHelpful(int reviewId, String userId) async {
    try {
      final voteKey = "${userId}_$reviewId";
      
      final isCurrentlyVoted = _userHelpfulVotes[voteKey] ?? false;
      final newVoteState = !isCurrentlyVoted;
      
      if (newVoteState) {
        _userHelpfulVotes[voteKey] = true;
      } else {
        _userHelpfulVotes.remove(voteKey);
      }

      final newHelpfulCount = _calculateHelpfulCount(reviewId);

      await supabase
          .from('tbl_reviews')
          .update({'helpful_count': newHelpfulCount})
          .eq('id', reviewId);

      _updateReviewHelpfulCount(reviewId, newHelpfulCount);

      notifyListeners();
      return true;
    } catch (e) {
      print('Error marking review helpful: $e');
      return false;
    }
  }

  int _calculateHelpfulCount(int reviewId) {
    int count = 0;
    for (final entry in _userHelpfulVotes.entries) {
      final parts = entry.key.split('_');
      if (parts.length == 2) {
        final parsedReviewId = int.tryParse(parts[1]);
        if (parsedReviewId == reviewId && entry.value == true) {
          count++;
        }
      }
    }
    return count;
  }

  void _updateReviewHelpfulCount(int reviewId, int newCount) {
    for (final productReviews in _reviewsByProduct.values) {
      final reviewIndex = productReviews.indexWhere((r) => r.id == reviewId);
      if (reviewIndex != -1) {
        final review = productReviews[reviewIndex];
        final updatedReview = review.copyWith(helpfulCount: newCount);
        productReviews[reviewIndex] = updatedReview;
        break;
      }
    }
  }

  Future<void> fetchReviewsForProduct(int productId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase
          .from('tbl_reviews')
          .select()
          .eq('product_id', productId)
          .order('created_at', ascending: false);

      if (response != null && response is List) {
        final reviews = <Review>[];
        
        for (var reviewJson in response) {
          try {
            final userId = reviewJson['user_id'];
            
            final userResponse = await supabase
                .from('tbl_users')
                .select('name')
                .eq('user_id', userId)
                .maybeSingle();

            if (userResponse != null && userResponse['name'] != null) {
              reviewJson['user_name'] = userResponse['name'];
            } else {
              reviewJson['user_name'] = 'Anonymous';
            }
          } catch (e) {
            print('Error fetching user for review: $e');
            reviewJson['user_name'] = reviewJson['user_name'] ?? 'Anonymous';
          }

          reviews.add(Review.fromJson(reviewJson as Map<String, dynamic>));
        }
        
        _reviewsByProduct[productId] = reviews;
      }

      await _cacheData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching reviews: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  double getProductAverageRating(int productId) {
    final reviews = _reviewsByProduct[productId] ?? [];
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  int getProductTotalReviews(int productId) {
    return _reviewsByProduct[productId]?.length ?? 0;
  }

  List<Review> getReviewsByRating(int productId, int rating) {
    final allReviews = _reviewsByProduct[productId] ?? [];
    return allReviews.where((review) => review.rating == rating).toList();
  }
  
  bool hasUserVoted(int reviewId, String userId) {
    final voteKey = "${userId}_$reviewId";
    return _userHelpfulVotes[voteKey] ?? false;
  }
}