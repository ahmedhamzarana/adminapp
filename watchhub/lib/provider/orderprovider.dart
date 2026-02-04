import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/order.dart';
import 'package:watchhub/provider/cartprovider.dart';

class OrderProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  List<Order> _orders = [];

  // Debouncing variables to prevent rapid API calls
  Timer? _debounceTimer;

  List<Order> get orders => _orders;

  OrderProvider() {
    // Automatically initialize when the provider is created
    initialize();
  }

  // Get count of all orders for the current user
  int get allOrdersCount => _orders.length;

  // Get count of running orders for the current user
  int get runningOrdersCount {
    return _orders.where((order) {
      final normalizedStatus = order.status.toLowerCase().trim();
      return normalizedStatus == 'pending' ||
             normalizedStatus == 'confirmed' ||
             normalizedStatus == 'shipped' ||
             normalizedStatus == 'processing' ||
             normalizedStatus == 'in_transit' ||
             normalizedStatus.contains('pend') ||
             normalizedStatus.contains('confir') ||
             normalizedStatus.contains('ship');
    }).length;
  }

  // Initialize and fetch orders when the provider is created
  void initialize() {
    fetchOrders();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Debounced fetch method to prevent multiple rapid calls
  void fetchOrdersDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _fetchOrdersInternal();
    });
  }

  // Internal fetch method
  Future<void> _fetchOrdersInternal() async {
    // Don't fetch if already loading to prevent multiple calls
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        debugPrint('Fetching orders for user ID: $userId');

        // Fetch orders with product details using JOIN
        final response = await supabase
            .from('tbl_orders')
            .select('''
              id,
              created_at,
              prod_id,
              total_item,
              total_amount,
              status,
              address_id,
              user_id,
              tbl_products!tbl_orders_prod_id_fkey(
                prod_name,
                prod_img
              )
            ''')
            .eq('user_id', userId)
            .order('created_at', ascending: false);

        debugPrint('Supabase response count: ${response.length}');

        // Map the order data with product details
        _orders = (response as List).map((orderJson) {
          final productData = orderJson['tbl_products'];
          
          return Order(
            id: orderJson['id'],
            prodId: orderJson['prod_id'],
            totalItem: orderJson['total_item'],
            totalAmount: (orderJson['total_amount'] as num).toDouble(),
            status: orderJson['status'] ?? 'pending',
            addressId: orderJson['address_id'],
            orderDate: orderJson['created_at'],
            productName: productData?['prod_name'],
            productImage: productData?['prod_img'],
          );
        }).toList();

        debugPrint('Mapped ${_orders.length} orders for user $userId');
        _orders.forEach((order) {
          debugPrint('Order ID: ${order.id}, Status: ${order.status}, Product: ${order.productName}');
        });
      } else {
        // If user is not logged in, fetch no orders
        _orders = [];
        debugPrint('No user logged in, returning empty orders list');
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      _orders = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Public method that uses debouncing
  Future<void> fetchOrders() async {
    fetchOrdersDebounced();
  }

  // Fetch all orders from tbl_orders for admin (without filtering by user)
  Future<void> fetchAllOrders() async {
    // Don't fetch if already loading to prevent multiple calls
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      // Fetch all orders with product details using JOIN
      final response = await supabase
          .from('tbl_orders')
          .select('''
            id,
            created_at,
            prod_id,
            total_item,
            total_amount,
            status,
            address_id,
            user_id,
            tbl_products!tbl_orders_prod_id_fkey(
              prod_name,
              prod_img
            )
          ''')
          .order('created_at', ascending: false);

      debugPrint('fetchAllOrders - Total records found: ${response.length}');

      // Map the order data with product details
      _orders = (response as List).map((orderJson) {
        final productData = orderJson['tbl_products'];
        
        debugPrint('DB Order - ID: ${orderJson['id']}, Status: ${orderJson['status']}, UserID: ${orderJson['user_id']}');
        
        return Order(
          id: orderJson['id'],
          prodId: orderJson['prod_id'],
          totalItem: orderJson['total_item'],
          totalAmount: (orderJson['total_amount'] as num).toDouble(),
          status: orderJson['status'] ?? 'pending',
          addressId: orderJson['address_id'],
          orderDate: orderJson['created_at'],
          productName: productData?['prod_name'],
          productImage: productData?['prod_img'],
        );
      }).toList();

      debugPrint('Mapped ${_orders.length} orders');
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
      _orders = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Place order and reduce stock
  Future<bool> placeOrder(List<dynamic> orderItems, int addressId, double totalAmount) async {
    isLoading = true;
    notifyListeners();

    try {
      // Calculate total items with safety check
      int totalItems = 0;
      for (var item in orderItems) {
        int quantity = item['quantity'] ?? 0;
        totalItems += quantity;
      }

      // Validate stock BEFORE any updates
      for (var item in orderItems) {
        int? productId = item['id'] as int?;
        int? orderedQuantity = item['quantity'] as int?;

        if (productId == null || orderedQuantity == null) {
          throw Exception('Invalid order item data');
        }

        // Check stock availability
        final response = await supabase
            .from('tbl_products')
            .select('prod_stock')
            .eq('id', productId)
            .single();

        int currentStock = response['prod_stock'] ?? 0;

        if (currentStock < orderedQuantity) {
          String itemName = item['name'] ?? 'Unknown Product';
          throw Exception('Insufficient stock for $itemName. Available: $currentStock, Requested: $orderedQuantity');
        }
      }

      // Now update stock after validation
      for (var item in orderItems) {
        int? productId = item['id'] as int?;
        int? orderedQuantity = item['quantity'] as int?;

        if (productId == null || orderedQuantity == null) {
          throw Exception('Invalid order item data');
        }

        final response = await supabase
            .from('tbl_products')
            .select('prod_stock')
            .eq('id', productId)
            .single();

        int currentStock = response['prod_stock'] ?? 0;
        int newStock = currentStock - orderedQuantity;

        // Update the stock in the database
        await supabase
            .from('tbl_products')
            .update({'prod_stock': newStock})
            .eq('id', productId);
      }

      // Determine the primary product ID
      int primaryProductId = 0;
      if (orderItems.isNotEmpty) {
        int? firstProductId = orderItems.first['id'] as int?;
        primaryProductId = firstProductId ?? 0;
      }

      // Get current user ID for the order
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create order record with the required fields
      await supabase
          .from('tbl_orders')
          .insert([
            {
              'prod_id': primaryProductId,
              'total_item': totalItems,
              'total_amount': totalAmount,
              'status': 'pending',
              'address_id': addressId,
              'user_id': userId,
            }
          ]);

      // Refresh the orders list after placing a new order
      await fetchOrders();

      return true;
    } catch (e) {
      debugPrint('Error placing order: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Alternative method if there's no orders table, just reduce stock directly
  Future<bool> reduceStockForOrder(CartProvider cartProvider) async {
    isLoading = true;
    notifyListeners();

    try {
      // Validate all stock first
      for (var item in cartProvider.cartItems) {
        final response = await supabase
            .from('tbl_products')
            .select('prod_stock')
            .eq('id', item.id)
            .single();

        int currentStock = response['prod_stock'] ?? 0;

        if (currentStock < item.quantity) {
          throw Exception('Insufficient stock for ${item.name}. Available: $currentStock, Requested: ${item.quantity}');
        }
      }

      // Then update stock
      for (var item in cartProvider.cartItems) {
        final response = await supabase
            .from('tbl_products')
            .select('prod_stock')
            .eq('id', item.id)
            .single();

        int currentStock = response['prod_stock'] ?? 0;
        int newStock = currentStock - item.quantity;

        await supabase
            .from('tbl_products')
            .update({'prod_stock': newStock})
            .eq('id', item.id);
      }

      return true;
    } catch (e) {
      debugPrint('Error reducing stock: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}