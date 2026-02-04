import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/address_model.dart';
import 'package:watchhub/provider/addressprovider.dart';
import 'package:watchhub/utils/appconstant.dart';
import 'add_edit_address_screen.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  List<AddressModel> addresses = [];
  int selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      debugPrint("Current user in shipping screen: $user");
      if (user == null) {
        debugPrint("No user authenticated in shipping screen");
        setState(() => isLoading = false);
        return;
      }

      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);

      debugPrint("About to fetch addresses from provider...");
      final fetchedAddresses = await addressProvider.getUserAddresses();
      debugPrint("Received addresses from provider: $fetchedAddresses");

      setState(() {
        addresses = fetchedAddresses; // ✅ FIXED
        debugPrint("Set addresses in state: $addresses");
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Load address error: $e");
      setState(() {
        addresses = [];
        isLoading = false;
      });
    }
  }

  Future<void> _refreshAddresses() async {
    setState(() => isLoading = true);
    await _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        foregroundColor: Colors.white,
        title: const Text(
          "Shipping Address",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
              ? _emptyView()
              : RefreshIndicator(
                  onRefresh: _refreshAddresses,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: addresses.length,
                    itemBuilder: (_, index) {
                      final address = addresses[index];
                      final isSelected = selectedIndex == index;

                      return _addressCard(address, index, isSelected);
                    },
                  ),
                ),
      floatingActionButton: _fab(),
    );
  }

  // ---------------- UI PARTS (UNCHANGED) ----------------

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined,
              size: 80, color: Appconstant.appmaincolor),
          const SizedBox(height: 24),
          const Text(
            "No Address Added",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Appconstant.appmaincolor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add your shipping address to continue",
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditAddressScreen(),
                ),
              );
              if (result != null) _refreshAddresses();
            },
            icon: const Icon(Icons.add_location_alt_outlined),
            label: const Text("Add Your First Address"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Appconstant.appmaincolor,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addressCard(AddressModel address, int index, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isSelected ? Appconstant.barcolor : Colors.grey.shade300,
          width: isSelected ? 2.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => selectedIndex = index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.fullName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Appconstant.appmaincolor,
              ),
            ),
            const SizedBox(height: 6),
            Text(address.phone),
            const SizedBox(height: 6),
            Text(
              "${address.address}, ${address.city}, ${address.zipCode}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton.extended(
      backgroundColor: Appconstant.appmaincolor,
      icon: const Icon(Icons.add_location_alt_outlined),
      label: const Text("Add New"),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddEditAddressScreen(),
          ),
        );
        if (result != null) _refreshAddresses();
      },
    );
  }
}
