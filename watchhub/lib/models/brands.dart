class Brand {
  final dynamic id;          // ✅ ID add ki
  final String name;
  final String imageUrl;

  Brand({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'], // ✅ database se ID fetch
      name: json['brand_name'] ?? '',
      imageUrl: json['brand_img_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,               // ✅ ID bhi map me
      'brand_name': name,
      'brand_img_url': imageUrl,
    };
  }
}
