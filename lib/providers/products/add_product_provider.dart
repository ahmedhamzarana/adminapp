import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  final TextEditingController proNamecontroller = TextEditingController();
  final TextEditingController proBrandcontroller = TextEditingController();
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

  Future<bool> addProduct() async {
    try {
      isLoading = true;
      notifyListeners();

      String imageUrl = '';

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
        'prod_stock': int.tryParse(proStockcontroller.text) ?? 0,
        'prod_description': proDescriptioncontroller.text,
      });

      clearForm();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error: $e');
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
    proBrandcontroller.dispose();
    proPricecontroller.dispose();
    proStockcontroller.dispose();
    proDescriptioncontroller.dispose();
    super.dispose();
  }
}