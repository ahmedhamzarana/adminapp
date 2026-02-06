// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = false;

  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  /// 🔹 FETCH USER ADDRESSES
  Future<List<AddressModel>> getUserAddresses() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        debugPrint("No user is authenticated");
        return [];
      }

      debugPrint("Fetching addresses for user: ${user.id}");

      final response = await supabase
          .from('tbl_address')
          .select()
          .eq('user_id', user.id)
          .order('id', ascending: false);

      debugPrint("Raw response from Supabase: $response");
      debugPrint("Number of records returned: ${response.length}");

      _addresses = response.map<AddressModel>((e) {
        debugPrint("Processing address data: $e");
        return AddressModel.fromJson(e as Map<String, dynamic>);
      }).toList();

      debugPrint("Final addresses list: $_addresses");

      notifyListeners();
      return _addresses;
    } catch (e) {
      debugPrint("Fetch address error: $e");
      return [];
    }
  }

  /// 🔹 INSERT ADDRESS
  Future<bool> insertAddress(AddressModel address) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      await supabase.from('tbl_address').insert({
        'user_id': user.id,
        'address_type': address.type,
        'full_name': address.fullName,
        'phone_number': address.phone,
        'address_details': address.address,
        'city': address.city,
        'zip_code': address.zipCode,
      });

      await getUserAddresses(); // 🔥 refresh
      return true;
    } catch (e) {
      debugPrint("Insert error: $e");
      return false;
    }
  }

  /// 🔹 UPDATE ADDRESS
  Future<bool> updateAddress(int id, AddressModel address) async {
    try {
      await supabase.from('tbl_address').update({
        'address_type': address.type,
        'full_name': address.fullName,
        'phone_number': address.phone,
        'address_details': address.address,
        'city': address.city,
        'zip_code': address.zipCode,
      }).eq('id', id);

      await getUserAddresses(); // 🔥 refresh
      return true;
    } catch (e) {
      debugPrint("Update error: $e");
      return false;
    }
  }

  /// 🔹 DELETE ADDRESS
  Future<bool> deleteAddress(int id) async {
    try {
      await supabase.from('tbl_address').delete().eq('id', id);
      await getUserAddresses(); // 🔥 refresh
      return true;
    } catch (e) {
      debugPrint("Delete error: $e");
      return false;
    }
  }
}
