class Product {
  final int id;
  final String prodName;
  final String prodImg;
  final int prodBrandId;
  final String prodBrandName;
  final double prodPrice;
  final int prodStock;
  final String prodDescription;

  Product({
    required this.id,
    required this.prodName,
    required this.prodImg,
    required this.prodBrandId,
    required this.prodBrandName,
    required this.prodPrice,
    required this.prodStock,
    required this.prodDescription,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      prodName: json['prod_name'],
      prodImg: json['prod_img'] ?? '',
      prodBrandId: json['tbl_brand']['id'],
      prodBrandName: json['tbl_brand']['brand_name'],
      prodPrice: (json['prod_price'] as num).toDouble(),
      prodStock: json['prod_stock'],
      prodDescription: json['prod_description'],
    );
  }
}
