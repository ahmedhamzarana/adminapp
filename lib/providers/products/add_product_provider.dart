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

  XFile? selectedImage;
  Uint8List? selectedImageBytes; // For web preview
  final ImagePicker _picker = ImagePicker();

  // Brand dropdown
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
      debugPrint('Error fetching brands: $e');
      notifyListeners();
    }
  }

  void setSelectedBrand(Brand? brand) {
    selectedBrand = brand;
    proBranderror = "";
    notifyListeners();
  }

  bool proValidateform() {
    bool isvalid = true;

    proNameerror = "";
    proBranderror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";

    if (proNamecontroller.text.trim().isEmpty) {
      proNameerror = "Product Name is required";
      isvalid = false;
    }
    if (selectedBrand == null) {
      proBranderror = "Please select a brand";
      isvalid = false;
    }
    if (proPricecontroller.text.trim().isEmpty) {
      proPriceerror = "Product Price is required";
      isvalid = false;
    }
    if (proStockcontroller.text.trim().isEmpty) {
      proStockerror = "Product Stock is required";
      isvalid = false;
    }
    if (proDescriptioncontroller.text.trim().isEmpty) {
      proDescriptionerror = "Product Description is required";
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
        'prod_brand': selectedBrand!.id, // Store brand ID (bigint)
        'prod_price': double.tryParse(proPricecontroller.text) ?? 0.0,
        'prod_stock': int.tryParse(proStockcontroller.text) ?? 0,
        'prod_description': proDescriptioncontroller.text.trim(),
      });

      clearForm();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error adding product: $e');
      return false;
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

    proNameerror = "";
    proBranderror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";

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
