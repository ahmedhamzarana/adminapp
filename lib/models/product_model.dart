// lib/models/product_model.dart
class Product {
  final int? id;
  final String prodName;
  final String prodImg;
  final String prodBrand; // Brand name as text
  final double prodPrice;
  final int prodStock;
  final String prodDescription;

  Product({
    this.id,
    required this.prodName,
    required this.prodImg,
    required this.prodBrand,
    required this.prodPrice,
    required this.prodStock,
    required this.prodDescription,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      prodName: json['prod_name'] ?? '',
      prodImg: json['prod_img'] ?? '',
      prodBrand: json['prod_brand'] ?? '',
      prodPrice: (json['prod_price'] ?? 0).toDouble(),
      prodStock: json['prod_stock'] ?? 0,
      prodDescription: json['prod_description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prod_name': prodName,
      'prod_img': prodImg,
      'prod_brand': prodBrand,
      'prod_price': prodPrice,
      'prod_stock': prodStock,
      'prod_description': prodDescription,
    };
  }
}