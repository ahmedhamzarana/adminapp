class CartItem {
  final int id;
  final String name;
  final String image;
  final int price;
  int quantity;
  final int stock;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'stock': stock,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      stock: json['stock'] as int,
    );
  }
}
