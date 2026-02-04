class Review {
  final int id;
  final int productId;
  final String userId; // Assuming there's a user ID
  final String userName;
  final int rating; // Rating out of 5
  final String comment;
  final DateTime createdAt;
  final int helpfulCount; // Number of users who found the review helpful
  final bool isVerifiedPurchase; // Whether the user actually purchased the product

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'helpful_count': helpfulCount,
      'is_verified_purchase': isVerifiedPurchase,
    };
  }

 factory Review.fromJson(Map<String, dynamic> json) {
  return Review(
    id: json['id'] is int
        ? json['id']
        : int.parse(json['id'].toString()),

    productId: json['product_id'] is int
        ? json['product_id']
        : int.parse(json['product_id'].toString()),

    userId: json['user_id'].toString(), // UUID → always string

    userName: json['user_name']?.toString() ?? '',

    rating: (json['rating'] as num).toInt(),

    comment: json['comment']?.toString() ?? '',

    createdAt: json['created_at'] is String
        ? DateTime.parse(json['created_at'])
        : json['created_at'] as DateTime,

    helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,

    isVerifiedPurchase: json['is_verified_purchase'] == true ||
        json['is_verified_purchase'] == 1,
  );
}


  Review copyWith({
    int? id,
    int? productId,
    String? userId,
    String? userName,
    int? rating,
    String? comment,
    DateTime? createdAt,
    int? helpfulCount,
    bool? isVerifiedPurchase,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
    );
  }
}