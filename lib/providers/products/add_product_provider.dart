import 'package:adminapp/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class AddProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  final TextEditingController proNamecontroller = TextEditingController();
  final TextEditingController proPricecontroller = TextEditingController();
  final TextEditingController proStockcontroller = TextEditingController();
  final TextEditingController proDescriptioncontroller = TextEditingController();

  String proNameerror = "";
  String proBranderror = "";
  String proPriceerror = "";
  String proStockerror = "";
  String proDescriptionerror = "";
  String proImageerror = ""; // Image validation error

  XFile? selectedImage;
  Uint8List? selectedImageBytes; 
  final ImagePicker _picker = ImagePicker();

  List<Brand> brandList = [];
  Brand? selectedBrand;
  bool isFetchingBrands = false;

  Future<void> fetchBrands() async {
    try {
      isFetchingBrands = true;
      notifyListeners();
      final data = await supabase
          .from('tbl_brand')
          .select('id, brand_name, brand_img_url')
          .order('brand_name', ascending: true);
      brandList = (data as List).map((item) => Brand.fromJson(item)).toList();
      isFetchingBrands = false;
      notifyListeners();
    } catch (e) {
      isFetchingBrands = false;
      notifyListeners();
    }
  }

  void setSelectedBrand(Brand? brand) {
    selectedBrand = brand;
    proBranderror = "";
    notifyListeners();
  }

  // --- Validation Logic ---
  bool proValidateform() {
    bool isvalid = true;

    // Reset Errors
    proNameerror = "";
    proBranderror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";
    proImageerror = "";

    // 1. Image Validation
    if (selectedImage == null) {
      proImageerror = "Product image is required";
      isvalid = false;
    }

    // 2. Name Validation (Letters only, No numbers)
    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    if (proNamecontroller.text.trim().isEmpty) {
      proNameerror = "Product Name is required";
      isvalid = false;
    } else if (!nameRegExp.hasMatch(proNamecontroller.text.trim())) {
      proNameerror = "Numbers/Symbols not allowed in name";
      isvalid = false;
    }

    // 3. Brand Validation
    if (selectedBrand == null) {
      proBranderror = "Please select a brand";
      isvalid = false;
    }

    // 4. Price Validation (No Negative)
    double? price = double.tryParse(proPricecontroller.text.trim());
    if (proPricecontroller.text.isEmpty) {
      proPriceerror = "Price is required";
      isvalid = false;
    } else if (price == null || price <= 0) {
      proPriceerror = "Price must be greater than 0";
      isvalid = false;
    }

    // 5. Stock Validation (No Negative)
    int? stock = int.tryParse(proStockcontroller.text.trim());
    if (proStockcontroller.text.isEmpty) {
      proStockerror = "Stock is required";
      isvalid = false;
    } else if (stock == null || stock < 0) {
      proStockerror = "Stock cannot be negative";
      isvalid = false;
    }

    if (proDescriptioncontroller.text.trim().isEmpty) {
      proDescriptionerror = "Description is required";
      isvalid = false;
    }

    notifyListeners();
    return isvalid;
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = image;
      selectedImageBytes = await image.readAsBytes();
      proImageerror = ""; // Clear error when image picked
      notifyListeners();
    }
  }

  Future<bool> addProduct() async {
    try {
      isLoading = true;
      notifyListeners();
      String imageUrl = '';
      if (selectedImage != null) {
        final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage.from('product_images').uploadBinary(
              fileName,
              selectedImageBytes!,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        imageUrl = supabase.storage.from('product_images').getPublicUrl(fileName);
      }
      await supabase.from('tbl_products').insert({
        'prod_name': proNamecontroller.text.trim(),
        'prod_img': imageUrl,
        'prod_brand': selectedBrand!.id,
        'prod_price': double.tryParse(proPricecontroller.text) ?? 0.0,
        'prod_stock': int.tryParse(proStockcontroller.text) ?? 0,
        'prod_description': proDescriptioncontroller.text.trim(),
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    proNamecontroller.clear();
    proPricecontroller.clear();
    proStockcontroller.clear();
    proDescriptioncontroller.clear();
    selectedImage = null;
    selectedImageBytes = null;
    selectedBrand = null;
    proNameerror = proBranderror = proPriceerror = proStockerror = proDescriptionerror = proImageerror = "";
    notifyListeners();
  }

  @override
  void dispose() {
    proNamecontroller.dispose();
    proPricecontroller.dispose();
    proStockcontroller.dispose();
    proDescriptioncontroller.dispose();
    super.dispose();
  }
}