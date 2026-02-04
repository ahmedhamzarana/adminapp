import 'package:adminapp/providers/brands/add_brand_provider.dart';
import 'package:adminapp/providers/brands/view_brand_provider.dart';
import 'package:adminapp/providers/chats/chat_support_provider.dart';
import 'package:adminapp/providers/dashboard_provider.dart';
import 'package:adminapp/providers/orders/order_view_provider.dart';
import 'package:adminapp/providers/products/add_product_provider.dart';
import 'package:adminapp/providers/home_provider.dart';
import 'package:adminapp/providers/auth/login_provider.dart';
import 'package:adminapp/providers/auth/splash_provider.dart';
import 'package:adminapp/providers/products/edit_product_provider.dart';
import 'package:adminapp/providers/products/view_product_provider.dart';
import 'package:adminapp/providers/reviews/review_provider.dart';
import 'package:adminapp/providers/users/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://euiiocpsflqmdxazktxc.supabase.co',
    anonKey: 'sb_publishable_SgLBnHBK4JPPwQLtpsp0WQ_lKQExzvW',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => AddProductProvider()),
        ChangeNotifierProvider(create: (context) => ViewProductProvider()),
        ChangeNotifierProvider(create: (context) => EditProductProvider()),
        ChangeNotifierProvider(create: (context) => AddBrandProvider()),
        ChangeNotifierProvider(create: (context) => ViewBrandProvider()),
        ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => OrderViewProvider()),
        ChangeNotifierProvider(create: (context) => UsersProvider()),
        ChangeNotifierProvider(create: (context) => ChatSupportProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watcheshub Admin',
      initialRoute: AppRoutes.splashRoute,
      routes: AppRoutes.routes,
    );
  }
}
