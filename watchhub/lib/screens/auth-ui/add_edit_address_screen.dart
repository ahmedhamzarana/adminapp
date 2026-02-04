import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/models/address_model.dart';
import 'package:watchhub/provider/addressprovider.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  static const Color mainColor = Color(0xFF006039);
  static const Color accentColor = Color(0xFFC1A35F);
  
  late TextEditingController typeController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController zipController;

  String selectedType = 'Home';
  final List<String> addressTypes = ['Home', 'Office', 'Other'];

  @override
  void initState() {
    super.initState();
    selectedType = widget.address?.type ?? 'Home';
    typeController = TextEditingController(text: widget.address?.type ?? '');
    nameController = TextEditingController(text: widget.address?.fullName ?? '');
    phoneController = TextEditingController(text: widget.address?.phone ?? '');
    addressController = TextEditingController(text: widget.address?.address ?? '');
    cityController = TextEditingController(text: widget.address?.city ?? '');
    zipController = TextEditingController(text: widget.address?.zipCode ?? '');
  }

  @override
  void dispose() {
    typeController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: Text(
          widget.address == null ? "Add New Address" : "Edit Address",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Address Type Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address Type",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: addressTypes.map((type) {
                      final isSelected = selectedType == type;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = type;
                                typeController.text = type;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? mainColor
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? mainColor
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    type == 'Home'
                                        ? Icons.home_outlined
                                        : type == 'Office'
                                            ? Icons.business_outlined
                                            : Icons.location_on_outlined,
                                    size: 18,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Personal Information Section
            _buildSectionHeader("Personal Information"),
            const SizedBox(height: 12),
            _buildTextField(
              label: "Full Name",
              hint: "Enter your full name",
              controller: nameController,
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                if (!_isValidName(value)) {
                  return 'Name should contain only letters and spaces';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Phone Number",
              hint: "Enter your phone number",
              controller: phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Address Details Section
            _buildSectionHeader("Address Details"),
            const SizedBox(height: 12),
            _buildTextField(
              label: "Street Address",
              hint: "House no., Building name, Street",
              controller: addressController,
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    label: "City",
                    hint: "Enter city",
                    controller: cityController,
                    icon: Icons.location_city_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter city';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: "Zip Code",
                    hint: "ZIP",
                    controller: zipController,
                    icon: Icons.pin_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Save Button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [mainColor, mainColor.withOpacity(0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.address == null ? "Save Address" : "Update Address",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: mainColor,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            validator: validator,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: accentColor,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              errorStyle: const TextStyle(
                fontSize: 11,
                height: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to validate name contains only letters and spaces
  bool _isValidName(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }

    // Regular expression to check if the string contains only letters and spaces
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(value.trim());
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final newAddress = AddressModel(
        id: widget.address?.id, // Preserve the ID if it's an existing address
        type: selectedType,
        fullName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        zipCode: zipController.text.trim(),
      );

      final addressProvider = Provider.of<AddressProvider>(context, listen: false);

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(widget.address == null ? "Saving address..." : "Updating address..."),
              ],
            ),
          );
        },
      );

      bool success;
      if (widget.address != null && widget.address!.id != null) {
        // Update existing address
        success = await addressProvider.updateAddress(widget.address!.id!, newAddress);
        Navigator.pop(context); // Close loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address updated successfully!'),
              backgroundColor: Color(0xFF006039),
            ),
          );
          Navigator.pop(context, newAddress);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update address. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Insert new address
        success = await addressProvider.insertAddress(newAddress);
        Navigator.pop(context); // Close loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address saved successfully!'),
              backgroundColor: Color(0xFF006039),
            ),
          );
          Navigator.pop(context, newAddress);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save address. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}