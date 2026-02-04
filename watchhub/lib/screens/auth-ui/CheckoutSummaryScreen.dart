import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/models/address_model.dart';
import 'package:watchhub/provider/cartprovider.dart';
import 'package:watchhub/provider/orderprovider.dart';
import 'package:watchhub/provider/addressprovider.dart';
import 'package:watchhub/screens/auth-ui/receiptScreen.dart';
import 'package:watchhub/screens/userpanel/home_screen.dart';
import 'package:watchhub/utils/appconstant.dart';

class CheckoutSummaryScreen extends StatefulWidget {
  const CheckoutSummaryScreen({super.key});

  @override
  State<CheckoutSummaryScreen> createState() => _CheckoutSummaryScreenState();
}

class _CheckoutSummaryScreenState extends State<CheckoutSummaryScreen> with WidgetsBindingObserver {
  int _selectedAddressIndex = 0; // Default to first address

  @override
  void initState() {
    super.initState();
    // Fetch addresses when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      addressProvider.getUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    double deliveryCharges = cart.totalPrice > 5000 ? 0 : 250;
    double discount = cart.totalPrice > 7000 ? 500 : 0;
    double totalPayable = cart.totalPrice + deliveryCharges - discount;

    // Check if user has any saved addresses
    bool hasAddress = addressProvider.addresses.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appconstant.appmaincolor,
        foregroundColor: Colors.white,
        title: const Text(
          "Order Summary",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ================= HEADER GRADIENT =================
          Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Appconstant.appmaincolor,
                  Appconstant.appmaincolor.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // ================= BODY =================
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await addressProvider.getUserAddresses();
                // Reset selection if addresses changed
                if (addressProvider.addresses.isNotEmpty) {
                  setState(() {
                    _selectedAddressIndex = 0;
                  });
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Items Summary Card
                  _enhancedCard(
                    "Items Summary",
                    Icons.shopping_bag_outlined,
                    Column(
                      children: cart.cartItems.isEmpty
                          ? [
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "No items in cart",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            ]
                          : cart.cartItems.map((item) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Quantity: ${item.quantity}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Appconstant.barcolor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Rs ${item.price * item.quantity}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Appconstant.barcolor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address Selection Card
                  if (hasAddress)
                    _enhancedCard(
                      "Select Delivery Address",
                      Icons.location_on_outlined,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose an address for delivery:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...addressProvider.addresses.asMap().entries.map((entry) {
                            int index = entry.key;
                            AddressModel address = entry.value;
                            bool isSelected = _selectedAddressIndex == index;
                            return _addressSelectionTile(address, index, isSelected);
                          }).toList(),
                        ],
                      ),
                    ),

                  // Address Validation Message
                  if (!hasAddress && cart.cartItems.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No Address Found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Please add an address before placing your order.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Price Details Card
                  _enhancedCard(
                    "Price Details",
                    Icons.receipt_long_outlined,
                    Column(
                      children: [
                        _enhancedPriceRow(
                          "Subtotal",
                          cart.totalPrice.toDouble(),
                          Icons.shopping_cart_outlined,
                        ),
                        const SizedBox(height: 8),
                        _enhancedPriceRow(
                          "Delivery Charges",
                          deliveryCharges,
                          Icons.local_shipping_outlined,
                        ),
                        const SizedBox(height: 8),
                        if (discount > 0)
                          _enhancedPriceRow(
                            "Discount",
                            -discount,
                            Icons.discount_outlined,
                            isDiscount: true,
                          ),
                        if (discount > 0) const SizedBox(height: 8),

                        // Savings Badge
                        if (deliveryCharges == 0)
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Appconstant.appmaincolor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Appconstant.appmaincolor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Appconstant.appmaincolor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    "Free Delivery Applied",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Appconstant.appmaincolor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const Divider(height: 30, thickness: 1.5),

                        _enhancedPriceRow(
                          "Total Payable",
                          totalPayable,
                          Icons.payments_outlined,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ================= PLACE ORDER BUTTON =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: cart.cartItems.isEmpty || !hasAddress
                      ? null
                      : () async {
                          debugPrint("===== PLACE ORDER CLICKED =====");
                          debugPrint("SELECTED ADDRESS INDEX: $_selectedAddressIndex");
                          debugPrint("TOTAL ITEMS   : ${cart.totalItems}");
                          debugPrint("TOTAL AMOUNT  : $totalPayable");
                          debugPrint("STATUS        : pending");

                          for (var item in cart.cartItems) {
                            debugPrint("------------------------------");
                            debugPrint("prod_id   : ${item.id}");
                            debugPrint("name      : ${item.name}");
                            debugPrint("qty       : ${item.quantity}");
                            debugPrint("price     : ${item.price}");
                            debugPrint(
                                "itemTotal : ${item.price * item.quantity}");
                          }

                          debugPrint("===== ORDER PRINTED =====");

                          // Get the OrderProvider and place the order
                          final orderProvider = Provider.of<OrderProvider>(context, listen: false);

                          // Get the selected address for the order
                          final selectedAddress = addressProvider.addresses[_selectedAddressIndex];

                          // Convert cart items to the expected format for the order
                          List<Map<String, dynamic>> orderItems = cart.cartItems.map((item) => {
                            'id': item.id,
                            'name': item.name,
                            'quantity': item.quantity,
                            'price': item.price,
                          }).toList();

                          // Place the order with all required data
                          bool success = await orderProvider.placeOrder(orderItems, selectedAddress.id!, totalPayable);

                          if (success) {
                            // Clear the cart after successful order
                            cart.clearCart();

                            // Get the selected address for the order
                            final selectedAddress = addressProvider.addresses[_selectedAddressIndex];

                            // Navigate to receipt screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReceiptScreen(
                                  selectedAddress: selectedAddress,
                                  totalAmount: totalPayable,
                                  subtotal: cart.totalPrice.toDouble(),
                                  deliveryCharges: deliveryCharges,
                                  discount: discount,
                                  grossAmount: (cart.totalPrice + deliveryCharges).toDouble(),
                                  orderItems: cart.cartItems,
                                ),
                              ),
                            );
                          } else {
                            // Show error if order placement failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to place order"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: cart.cartItems.isEmpty || !hasAddress
                          ? null
                          : const LinearGradient(
                              colors: [
                                Appconstant.barcolor,
                                Color(0xFFD4B976),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                      color: cart.cartItems.isEmpty || !hasAddress
                          ? Colors.grey.shade300
                          : null,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: cart.cartItems.isEmpty || !hasAddress
                          ? null
                          : [
                              BoxShadow(
                                color: Appconstant.barcolor.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                cart.cartItems.isEmpty || !hasAddress
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outline,
                                color: cart.cartItems.isEmpty || !hasAddress
                                    ? Colors.grey.shade600
                                    : Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                cart.cartItems.isEmpty
                                    ? "Cart is Empty"
                                    : !hasAddress
                                        ? "Add Address First"
                                        : "Place Order",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: cart.cartItems.isEmpty || !hasAddress
                                      ? Colors.grey.shade600
                                      : Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          if (!hasAddress && !cart.cartItems.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Please add an address before placing your order",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressSelectionTile(AddressModel address, int index, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? Appconstant.appmaincolor.withOpacity(0.08)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Appconstant.appmaincolor
              : Colors.grey.shade300,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: RadioListTile<int>(
        value: index,
        groupValue: _selectedAddressIndex,
        onChanged: (int? value) {
          if (value != null) {
            setState(() {
              _selectedAddressIndex = value;
            });
          }
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Appconstant.appmaincolor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        address.type == 'Home'
                            ? Icons.home_outlined
                            : address.type == 'Office'
                                ? Icons.business_outlined
                                : Icons.location_on_outlined,
                        size: 14,
                        color: Appconstant.appmaincolor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        address.type,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Appconstant.appmaincolor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Appconstant.barcolor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Selected",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.fullName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              address.phone,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${address.address}, ${address.city}, ${address.zipCode}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        dense: true,
      ),
    );
  }

  // ================= ENHANCED CARD =================
  Widget _enhancedCard(String title, IconData icon, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Appconstant.appmaincolor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Appconstant.appmaincolor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // ================= ENHANCED PRICE ROW =================
  Widget _enhancedPriceRow(
    String title,
    double value,
    IconData icon, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isTotal
            ? Appconstant.barcolor.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isTotal ? 20 : 18,
                color: isTotal
                    ? Appconstant.barcolor
                    : Colors.grey.shade600,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                  color: isTotal ? const Color(0xFF1A1A1A) : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Text(
            "${value < 0 ? '-' : ''}Rs ${value.abs().toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: FontWeight.bold,
              color: isDiscount
                  ? Appconstant.appmaincolor
                  : isTotal
                      ? Appconstant.barcolor
                      : const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

  