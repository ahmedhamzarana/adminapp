import 'package:adminapp/models/product_model.dart'; // Import your model
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  dynamic currentProductId; // Changed to dynamic to support int or String IDs
  String? existingImageUrl;

  final TextEditingController proNamecontroller = TextEditingController();
  final TextEditingController proBrandcontroller = TextEditingController();
  final TextEditingController proPricecontroller = TextEditingController();
  final TextEditingController proStockcontroller = TextEditingController();
  final TextEditingController proDescriptioncontroller =
      TextEditingController();

  String proNameerror = "";
  String proBranderror = "";
  String proPriceerror = "";
  String proStockerror = "";
  String proDescriptionerror = "";

  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();

  /// 🔹 NEW: Initialize method to fill the form
  void initializeProduct(Product product) {
    currentProductId = product.id;
    existingImageUrl = product.prodImg;

    proNamecontroller.text = product.prodName;
    proBrandcontroller.text = product.prodBrand;
    proPricecontroller.text = product.prodPrice.toString();
    proStockcontroller.text = product.prodStock.toString();
    proDescriptioncontroller.text = product.prodDescription;

    selectedImage = null; // Reset any previous selection

    // Clear errors when opening a new product
    proNameerror = "";
    proBranderror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";

    notifyListeners();
  }

  bool proValidateform(BuildContext context) {
    bool isvalid = true;
    proNameerror = "";
    proBranderror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";

    if (proNamecontroller.text.isEmpty) {
      proNameerror = "Product Name is required";
      isvalid = false;
    }
    if (proBrandcontroller.text.isEmpty) {
      proBranderror = "Product Brand is required";
      isvalid = false;
    }
    if (proPricecontroller.text.isEmpty) {
      proPriceerror = "Product Price is required";
      isvalid = false;
    }
    if (proStockcontroller.text.isEmpty) {
      proStockerror = "Product Stock is required";
      isvalid = false;
    }
    if (proDescriptioncontroller.text.isEmpty) {
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
      notifyListeners();
    }
  }

  Future<bool> updateProduct() async {
    if (currentProductId == null) {
      debugPrint('Error: No product ID set');
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      String imageUrl = existingImageUrl ?? '';

      if (selectedImage != null) {
        final fileName =
            'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await selectedImage!.readAsBytes();

        await supabase.storage
            .from('product_images')
            .uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        imageUrl = supabase.storage
            .from('product_images')
            .getPublicUrl(fileName);
      }

      await supabase
          .from('tbl_products')
          .update({
            'prod_name': proNamecontroller.text,
            'prod_img': imageUrl,
            'prod_brand': proBrandcontroller.text,
            'prod_price': double.tryParse(proPricecontroller.text) ?? 0.0,
            'prod_stock': int.tryParse(proStockcontroller.text) ?? 0,
            'prod_description': proDescriptioncontroller.text,
          })
          .eq('id', currentProductId!);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error Updating: $e');
      return false;
    }
  }

  void clearForm() {
    proNamecontroller.clear();
    proBrandcontroller.clear();
    proPricecontroller.clear();
    proStockcontroller.clear();
    proDescriptioncontroller.clear();
    selectedImage = null;
    currentProductId = null;
    existingImageUrl = null;
    notifyListeners();
  }

  @override
  void dispose() {
    proNamecontroller.dispose();
    proBrandcontroller.dispose();
    proPricecontroller.dispose();
    proStockcontroller.dispose();
    proDescriptioncontroller.dispose();
    super.dispose();
  }
}
