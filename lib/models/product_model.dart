class Product {
  final int? id;
  final String prodName;
  final String prodImg;
  final String prodBrand;
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

  // Supabase se data ko Product object me convert karna
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      prodName: json['prod_name'] ?? '',
      prodImg: json['prod_img'] ?? '',
      prodBrand: json['prod_brand'] ?? '',
      prodPrice: (json['prod_price'] ?? 0.0).toDouble(),
      prodStock: json['prod_stock'] ?? 0,
      prodDescription: json['prod_description'] ?? '',
    );
  }

  // Product object ko Supabase ke liye JSON me convert karna
  Map<String, dynamic> toJson() {
    return {
      'prod_name': prodName,
      'prod_img': prodImg,
      'prod_brand': prodBrand,
      'prod_price': prodPrice,
      'prod_stock': prodStock,
      'prod_description': prodDescription,
    };
  }
}