// ignore_for_file: use_build_context_synchronously

import 'package:adminapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeProvider extends ChangeNotifier {

  void logout(BuildContext context) async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
  }
}
