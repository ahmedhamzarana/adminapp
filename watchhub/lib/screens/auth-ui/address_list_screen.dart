import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watchhub/models/address_model.dart';
import 'package:watchhub/provider/addressprovider.dart';
import 'package:watchhub/utils/appconstant.dart';
import 'add_edit_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
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
      debugPrint("Current user in address list screen: $user");
      if (user == null) {
        debugPrint("No user authenticated in address list screen");
        if (mounted) {
          setState(() => isLoading = false);
        }
        return;
      }

      // Use WidgetsBinding to ensure the widget is mounted before accessing provider
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final addressProvider = Provider.of<AddressProvider>(context, listen: false);

          debugPrint("About to fetch addresses from provider...");
          addressProvider.getUserAddresses().then((fetchedAddresses) {
            debugPrint("Received addresses from provider: $fetchedAddresses");

            if (mounted) {
              setState(() {
                addresses = fetchedAddresses;
                debugPrint("Set addresses in state: $addresses");
                isLoading = false;
              });
            }
          }).catchError((error) {
            debugPrint("Error fetching addresses: $error");
            if (mounted) {
              setState(() {
                addresses = [];
                isLoading = false;
              });
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Load address error: $e");
      if (mounted) {
        setState(() {
          addresses = [];
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshAddresses() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
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
          "My Addresses",
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
              if (result != null && mounted) {
                _refreshAddresses();
              }
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
          color: isSelected ? Appconstant.barcolor : Colors.grey.shade300,
          width: isSelected ? 2.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Appconstant.appmaincolor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Appconstant.barcolor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                  ),
                  color: Appconstant.barcolor,
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditAddressScreen(
                          address: address,
                        ),
                      ),
                    );
                    if (result != null && mounted) _refreshAddresses();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    _showDeleteDialog(context, index);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: Appconstant.barcolor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      address.phone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Appconstant.barcolor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${address.address}, ${address.city}, ${address.zipCode}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        if (result != null && mounted) _refreshAddresses();
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Delete Address",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete this address? This action cannot be undone.",
          style: TextStyle(
            fontSize: 15,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final addressProvider = Provider.of<AddressProvider>(context, listen: false);
              final addressToDelete = addresses[index];

              if (addressToDelete.id != null) {
                bool success = await addressProvider.deleteAddress(addressToDelete.id!);

                if (success) {
                  // Store the context reference before Navigator.pop()
                  final snackBarContext = context;
                  setState(() => addresses.removeAt(index));
                  Navigator.pop(context);

                  // Add a small delay to ensure the dialog is dismissed before showing snackbar
                  await Future.delayed(const Duration(milliseconds: 100));

                  if (snackBarContext.mounted) {
                    ScaffoldMessenger.of(snackBarContext).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text("Address deleted successfully"),
                          ],
                        ),
                        backgroundColor: Appconstant.appmaincolor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                  _refreshAddresses(); // Refresh the list after deletion
                } else {
                  // Store the context reference before Navigator.pop()
                  final snackBarContext = context;
                  Navigator.pop(context);

                  // Add a small delay to ensure the dialog is dismissed before showing snackbar
                  await Future.delayed(const Duration(milliseconds: 100));

                  if (snackBarContext.mounted) {
                    ScaffoldMessenger.of(snackBarContext).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to delete address. Please try again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Delete",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}