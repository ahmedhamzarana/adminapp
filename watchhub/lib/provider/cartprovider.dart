import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:watchhub/models/cartitem.dart';
import 'dart:convert';


class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<CartItem> get cartItems => _cartItems;

  CartProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final cartJson = await _secureStorage.read(key: 'cart_items');
      if (cartJson != null) {
        final List<dynamic> cartList = json.decode(cartJson) as List<dynamic>;
        _cartItems.clear();
        for (var itemMap in cartList) {
          _cartItems.add(CartItem.fromJson(itemMap as Map<String, dynamic>));
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart from storage: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final cartJson = json.encode(_cartItems.map((item) => item.toJson()).toList());
      await _secureStorage.write(key: 'cart_items', value: cartJson);
    } catch (e) {
      print('Error saving cart to storage: $e');
    }
  }

  void addToCart(CartItem item) {
    final index = _cartItems.indexWhere((e) => e.id == item.id);

    if (index >= 0) {
      // Check if adding more quantity would exceed stock
      if (_cartItems[index].quantity + item.quantity <= _cartItems[index].stock) {
        _cartItems[index].quantity += item.quantity;
      }
    } else {
      // Only add if quantity doesn't exceed stock
      if (item.quantity <= item.stock) {
        _cartItems.add(item);
      }
    }
    _saveToStorage();
    notifyListeners();
  }

  void removeItem(int id) {
    _cartItems.removeWhere((item) => item.id == id);
    _saveToStorage();
    notifyListeners();
  }

  void increaseQty(int id) {
    final index = _cartItems.indexWhere((e) => e.id == id);
    if (index >= 0 && _cartItems[index].quantity < _cartItems[index].stock) {
      _cartItems[index].quantity++;
      _saveToStorage();
      notifyListeners();
    }
  }

  void decreaseQty(int id) {
    final index = _cartItems.indexWhere((e) => e.id == id);
    if (index >= 0 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      _saveToStorage();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _saveToStorage();
    notifyListeners();
  }

  int get totalItems =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
}
