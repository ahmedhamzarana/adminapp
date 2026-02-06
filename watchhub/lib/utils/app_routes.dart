import 'package:flutter/material.dart';
import 'package:watchhub/screens/auth-ui/CheckoutSummaryScreen.dart';
import 'package:watchhub/screens/auth-ui/add_to_cart_screen.dart';
import 'package:watchhub/screens/auth-ui/browse_products_screen.dart';
import 'package:watchhub/screens/auth-ui/contactSupportscreen.dart';
import 'package:watchhub/screens/auth-ui/favourite_screen.dart';
import 'package:watchhub/screens/auth-ui/order_history_screen.dart';
import 'package:watchhub/screens/auth-ui/profiescreen.dart';
import 'package:watchhub/screens/auth-ui/receiptscreen.dart';
import 'package:watchhub/screens/auth-ui/search_screen.dart';
import 'package:watchhub/screens/auth-ui/shipping_address_screen.dart';
import 'package:watchhub/screens/auth-ui/signupscreen.dart';
import 'package:watchhub/screens/userpanel/home_screen.dart';
import 'package:watchhub/screens/auth-ui/signinscreen.dart';
import 'package:watchhub/screens/auth-ui/splashscreen.dart';
import 'package:watchhub/screens/auth-ui/feedback_review_screen.dart';

class AppRoutes extends ChangeNotifier {
  static const String splashRoute = "/";

  static const String signinRoute = "/signin";
  static const String signupRoute = "/signup";
  static const String homeroute = "/home";
  static const String productviewallroute = "/productview";
  static const String profileroute = "/profile";
  static const String favoriteroute = "/favourite";
  static const String cartroute = "/cart";
  static const String shippingaddressroute = "/shippingaddress";
  static const String contactSupportRoute = "/contactSupportRoute";
  static const String brandwiseshowproductdetailroute =
      "/brandwiseshowproductdetail";
  static const String checkoutsummaryscreenroute = "/checkoutsummary";
  static const String receiptroute = "/receipt";
  static const String orderhistoryroute = "/orderhistory";
  static const String browseproductsroute = "/browseproducts";
  static const String searchroute = "/search";
  static const String reviewlistroute = "/reviewlist";
  static const String feedbackreviewroute = "/feedbackreview";

  static Map<String, WidgetBuilder> routes = {
    splashRoute: (context) => Splashscreen(),

    signinRoute: (context) => Signinscreen(),
    signupRoute: (context) => Signupscreen(),
    homeroute: (context) => HomeScreen(),
    profileroute: (context) => ProfileScreen(),
    favoriteroute: (context) => FavoriteScreen(),
    cartroute: (context) => CartScreen(),
    shippingaddressroute: (context) => ShippingAddressScreen(),
    contactSupportRoute: (context) => ContactSupportScreen(),
    checkoutsummaryscreenroute: (context) => CheckoutSummaryScreen(),
    receiptroute: (context) => ReceiptScreen(
      selectedAddress: null,
      totalAmount: 0.0,
      subtotal: 0.0,
      deliveryCharges: 0.0,
      discount: 0.0,
      grossAmount: 0.0,
      orderItems: [],
    ),
    orderhistoryroute: (context) => const OrderHistoryScreen(),
    browseproductsroute: (context) => const BrowseProductsScreen(),
    searchroute: (context) => const SearchScreen(),
    feedbackreviewroute: (context) => const FeedbackReviewScreen(),
  };
}
