// lib/providers/products/edit_product_provider.dart
import 'package:adminapp/models/brand_model.dart';
import 'package:adminapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  dynamic currentProductId;
  String? existingImageUrl;

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

  void initializeProduct(Product product) async {
    currentProductId = product.id;
    existingImageUrl = product.prodImg;

    proNamecontroller.text = product.prodName;
    proPricecontroller.text = product.prodPrice.toString();
    proStockcontroller.text = product.prodStock.toString();
    proDescriptioncontroller.text = product.prodDescription;

    await fetchBrands();

    // Find brand by name
    selectedBrand = brandList.firstWhere(
      (b) => b.brandName == product.prodBrand,
      orElse: () => brandList.isNotEmpty ? brandList.first : Brand(brandName: '', brandImgUrl: ''),
    );

    selectedImage = null;
    _clearErrors();
    notifyListeners();
  }

  void _clearErrors() {
    proNameerror = "";
    proBranderror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";
  }

  bool proValidateform() {
    bool isvalid = true;
    _clearErrors();

    if (proNamecontroller.text.trim().isEmpty) {
      proNameerror = "Product Name is required";
      isvalid = false;
    }
    if (selectedBrand == null) {
      proBranderror = "Brand is required";
      isvalid = false;
    }
    if (proPricecontroller.text.trim().isEmpty) {
      proPriceerror = "Price is required";
      isvalid = false;
    }
    if (proStockcontroller.text.trim().isEmpty) {
      proStockerror = "Stock is required";
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
      notifyListeners();
    }
  }

  Future<bool> updateProduct() async {
    try {
      isLoading = true;
      notifyListeners();

      String imageUrl = existingImageUrl ?? '';

      if (selectedImage != null) {
        final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await selectedImage!.readAsBytes();
        await supabase.storage.from('product_images').uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        imageUrl = supabase.storage.from('product_images').getPublicUrl(fileName);
      }

      await supabase.from('tbl_products').update({
        'prod_name': proNamecontroller.text.trim(),
        'prod_img': imageUrl,
        'prod_brand': selectedBrand!.brandName, // Store brand name as text
        'prod_price': double.tryParse(proPricecontroller.text) ?? 0.0,
        'prod_stock': int.tryParse(proStockcontroller.text) ?? 0,
        'prod_description': proDescriptioncontroller.text.trim(),
      }).eq('id', currentProductId!);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error updating product: $e');
      return false;
    }
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