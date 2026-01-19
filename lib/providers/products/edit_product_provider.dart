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
  final TextEditingController proBrandcontroller = TextEditingController();
  final TextEditingController proPricecontroller = TextEditingController();
  final TextEditingController proStockcontroller = TextEditingController();
  final TextEditingController proDescriptioncontroller = TextEditingController();

  // Error strings (These will be displayed in the UI)
  String proNameerror = "";
  String proBranderror = "";
  String proPriceerror = "";
  String proStockerror = "";
  String proDescriptionerror = "";

  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();

  void initializeProduct(Product product) {
    currentProductId = product.id;
    existingImageUrl = product.prodImg;

    proNamecontroller.text = product.prodName;
    proBrandcontroller.text = product.prodBrand;
    proPricecontroller.text = product.prodPrice.toString();
    proStockcontroller.text = product.prodStock.toString();
    proDescriptioncontroller.text = product.prodDescription;

    selectedImage = null; 
    _clearErrors(); // Reset errors when opening
    notifyListeners();
  }

  void _clearErrors() {
    proNameerror = "";
    proBranderror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";
  }

  // 🔹 VALIDATION LOGIC
  bool proValidateform() {
    bool isvalid = true;
    _clearErrors(); // Clear old errors first

    if (proNamecontroller.text.isEmpty) {
      proNameerror = "Product Name is required";
      isvalid = false;
    }
    if (proBrandcontroller.text.isEmpty) {
      proBranderror = "Brand is required";
      isvalid = false;
    }
    if (proPricecontroller.text.isEmpty) {
      proPriceerror = "Price is required";
      isvalid = false;
    }
    if (proStockcontroller.text.isEmpty) {
      proStockerror = "Stock is required";
      isvalid = false;
    }
    if (proDescriptioncontroller.text.isEmpty) {
      proDescriptionerror = "Description is required";
      isvalid = false;
    }

    notifyListeners(); // Update UI to show error text
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
        final fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await selectedImage!.readAsBytes();
        await supabase.storage.from('product_images').uploadBinary(
              fileName, bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        imageUrl = supabase.storage.from('product_images').getPublicUrl(fileName);
      }

      await supabase.from('tbl_products').update({
        'prod_name': proNamecontroller.text,
        'prod_img': imageUrl,
        'prod_brand': proBrandcontroller.text,
        'prod_price': double.tryParse(proPricecontroller.text) ?? 0.0,
        'prod_stock': int.tryParse(proStockcontroller.text) ?? 0,
        'prod_description': proDescriptioncontroller.text,
      }).eq('id', currentProductId!);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}