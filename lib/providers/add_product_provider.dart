import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  // Text Controllers
  final TextEditingController proNamecontroller = TextEditingController();
  final TextEditingController proBrandcontroller = TextEditingController();
  final TextEditingController proPricecontroller = TextEditingController();
  final TextEditingController pronStockcontroller = TextEditingController();
  final TextEditingController proDescriptioncontroller = TextEditingController();

  // Error Messages
  String proNameerror = "";
  String proCategoryerror = "";
  String proPriceerror = "";
  String proStockerror = "";
  String proDescriptionerror = "";

  // Image
  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Validate Form
  bool proValidateform(BuildContext context) {
    bool isvalid = true;

    // Clear previous errors
    proNameerror = "";
    proCategoryerror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";

    if (proNamecontroller.text.isEmpty) {
      proNameerror = "Product Name is required";
      isvalid = false;
    }
    if (proBrandcontroller.text.isEmpty) {
      proCategoryerror = "Product Brand is required";
      isvalid = false;
    }
    if (proPricecontroller.text.isEmpty) {
      proPriceerror = "Product Price is required";
      isvalid = false;
    }
    if (pronStockcontroller.text.isEmpty) {
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

  // Pick Image
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      selectedImage = image;
      notifyListeners();
    }
  }

  // Add Product
  Future<bool> addProduct() async {
    try {
      isLoading = true;
      notifyListeners();

      String imageUrl = '';

      // Upload image if provided
      if (selectedImage != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await selectedImage!.readAsBytes();

        await supabase.storage.from('product_images').uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        imageUrl = supabase.storage.from('product_images').getPublicUrl(fileName);
      }

      // Insert product
      await supabase.from('tbl_products').insert({
        'prod_name': proNamecontroller.text,
        'prod_img': imageUrl,
        'prod_brand': proBrandcontroller.text,
        'prod_price': double.tryParse(proPricecontroller.text) ?? 0.0,
        'prod_stock': int.tryParse(pronStockcontroller.text) ?? 0,
        'prod_description': proDescriptioncontroller.text,
      });

      // Clear form after successful submission
      clearForm();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Error: $e');
      return false;
    }
  }

  // Clear Form
  void clearForm() {
    proNamecontroller.clear();
    proBrandcontroller.clear();
    proPricecontroller.clear();
    pronStockcontroller.clear();
    proDescriptioncontroller.clear();
    selectedImage = null;
    
    proNameerror = "";
    proCategoryerror = "";
    proPriceerror = "";
    proStockerror = "";
    proDescriptionerror = "";
    
    notifyListeners();
  }

  @override
  void dispose() {
    proNamecontroller.dispose();
    proBrandcontroller.dispose();
    proPricecontroller.dispose();
    pronStockcontroller.dispose();
    proDescriptioncontroller.dispose();
    super.dispose();
  }
}