import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/provider/addressprovider.dart';
import 'package:watchhub/provider/brandwise_provider.dart';
import 'package:watchhub/provider/browse_products_provider.dart';
import 'package:watchhub/provider/cartprovider.dart';
import 'package:watchhub/provider/contact_support_provider.dart';
import 'package:watchhub/provider/customer_review_provider.dart';
import 'package:watchhub/provider/favouriteprovider.dart';
import 'package:watchhub/provider/home_provider.dart';
import 'package:watchhub/provider/orderprovider.dart';
import 'package:watchhub/provider/product_detail_provider.dart';
import 'package:watchhub/provider/reviewprovider.dart';
import 'package:watchhub/provider/profileprovider.dart';
import 'package:watchhub/provider/settingprovider.dart';
import 'package:watchhub/provider/signinprovider.dart';
import 'package:watchhub/provider/signupprovider.dart';
import 'package:watchhub/provider/splash_provider.dart';
import 'package:watchhub/utils/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://euiiocpsflqmdxazktxc.supabase.co',
    anonKey: 'sb_publishable_SgLBnHBK4JPPwQLtpsp0WQ_lKQExzvW',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => Signinprovider()),
        ChangeNotifierProvider(create: (_) => Signupprovider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => BrandWiseProvider()),
        ChangeNotifierProvider(create: (_) => BrowseProductsProvider()),
        ChangeNotifierProvider(create: (_)=>ProductDetailProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => ContactSupportProvider()),
                ChangeNotifierProvider(create: (_) => CustomerReviewProvider()),


      ],
        child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final settings = context.watch<SettingsProvider>(); 

    return GetMaterialApp(
      title: 'WatchHub',
      debugShowCheckedModeBanner: false,


      initialRoute: AppRoutes.splashRoute,
      routes: AppRoutes.routes,
    );
  }
}
  