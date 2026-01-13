import 'package:adminapp/providers/add_product_provider.dart';
import 'package:adminapp/providers/home_provider.dart';
import 'package:adminapp/providers/login_provider.dart';
import 'package:adminapp/providers/splash_provider.dart';
import 'package:adminapp/providers/view_product_provider.dart';
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
        ChangeNotifierProvider(create: (context) => AddProductProvider()),
        ChangeNotifierProvider(create: (context) => ViewProductProvider()),
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
      title: 'Flutter Demo',
      initialRoute: AppRoutes.splashRoute,
      routes: AppRoutes.routes,
    );
  }
}
