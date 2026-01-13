// ignore_for_file: use_build_context_synchronously

import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeProvider extends ChangeNotifier {
  void logout(BuildContext context) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    final supabase = Supabase.instance.client;
    storage.delete(key: "useremail");
    await supabase.auth.signOut();
    Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
  }
}
