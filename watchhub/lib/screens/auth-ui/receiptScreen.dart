// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/provider/cartprovider.dart';
import 'package:watchhub/screens/userpanel/home_screen.dart';
import 'package:watchhub/utils/appconstant.dart';


class ReceiptScreen extends StatelessWidget {
  final dynamic selectedAddress;
  final double totalAmount;
  final double subtotal;
  final double deliveryCharges;
  final double discount;
  final double grossAmount;
  final List<dynamic> orderItems;

  const ReceiptScreen({
    super.key,
    this.selectedAddress,
    required this.totalAmount,
    required this.subtotal,
    required this.deliveryCharges,
    required this.discount,
    required this.grossAmount,
    this.orderItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    // If orderItems is passed, use it; otherwise use cart items
    final itemsToShow = orderItems.isNotEmpty ? orderItems : cart.cartItems;

    // Calculate subtotal from items if not provided
    final double calculatedSubtotal = itemsToShow.fold<double>(0, (sum, item) {
      final itemTotal = item.price * item.quantity;
      return sum + itemTotal.toDouble();
    });
    final double effectiveSubtotal = subtotal != 0.0 ? subtotal : calculatedSubtotal;

    return WillPopScope(
      onWillPop: () async {
  
        cart.clearCart();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        return false; // prevent default back action
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false, // disable AppBar back button
          backgroundColor: Appconstant.appmaincolor,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "Order Receipt",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // SUCCESS ANIMATION CONTAINER
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Appconstant.appmaincolor,
                      Appconstant.appmaincolor.withAlpha(204),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Appconstant.appmaincolor.withAlpha(76),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Order Placed Successfully!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Thank you for shopping with WatchHub",
                      style: TextStyle(
                        color: Colors.white.withAlpha(229),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Estimated Delivery: 3-5 Days",
                            style: TextStyle(
                              color: Colors.white.withAlpha(242),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ORDER DETAILS CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Appconstant.barcolor.withAlpha(38),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Appconstant.barcolor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Order Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Appconstant.appmaincolor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Order ID & Date
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                            Icons.shopping_bag_outlined,
                            "Order ID",
                            "#WH${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}",
                          ),
                          const SizedBox(height: 12),
                          _infoRow(
                            Icons.calendar_today_outlined,
                            "Date",
                            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Items Section
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Appconstant.barcolor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Items Ordered",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Appconstant.appmaincolor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ...itemsToShow.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Appconstant.appmaincolor
                                          .withAlpha(25),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.watch,
                                      size: 18,
                                      color: Appconstant.appmaincolor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Qty: ${item.quantity}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Rs ${item.price * item.quantity}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Appconstant.barcolor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[300], thickness: 1),
                    const SizedBox(height: 16),

                    // Customer Information Section
                    if (selectedAddress != null) ...[
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Appconstant.barcolor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Customer Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Appconstant.appmaincolor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(Icons.person, "Name", selectedAddress.fullName ?? ""),
                            const SizedBox(height: 8),
                            _infoRow(Icons.phone, "Phone", selectedAddress.phone ?? ""),
                            const SizedBox(height: 8),
                            _infoRow(Icons.location_on, "Address",
                              "${selectedAddress.address}, ${selectedAddress.city}, ${selectedAddress.zipCode}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Price Breakdown
                  
                    _priceRow("Delivery Charges", deliveryCharges,
                        icon: Icons.local_shipping_outlined),
                    if (deliveryCharges == 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "FREE DELIVERY",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _priceRow("Discount", discount,
                        isDiscount: true, icon: Icons.discount_outlined),
                    if (discount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "SAVINGS",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Gross Total (before discount)
              
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Appconstant.barcolor.withAlpha(38),
                            Appconstant.barcolor.withAlpha(13),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Appconstant.barcolor.withAlpha(76),
                          width: 1.5,
                        ),
                      ),
                      child: _priceRow(
                        "Total Paid",
                        totalAmount,
                        isTotal: true,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // BACK TO HOME BUTTON
              GestureDetector(
                onTap: () {
                  cart.clearCart();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Appconstant.appmaincolor,
                        Appconstant.appmaincolor.withAlpha(216),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Appconstant.appmaincolor.withAlpha(102),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Back to Home",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Appconstant.barcolor,
        ),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Appconstant.appmaincolor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String title, double value,
      {bool isTotal = false, bool isDiscount = false, IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isDiscount ? Colors.green : Appconstant.barcolor,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: isTotal ? 17 : 14,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
                color: isTotal ? Appconstant.appmaincolor : Colors.black87,
              ),
            ),
          ],
        ),
        Text(
          "${isDiscount && value > 0 ? '- ' : ''}Rs ${value.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: FontWeight.w700,
            color: isDiscount
                ? Colors.green
                : isTotal
                    ? Appconstant.barcolor
                    : Colors.black87,
          ),
        ),
      ],
    );
  }
}