import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProductProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  String? currentProductId;
  String? existingImageUrl;

  final TextEditingController proNamecontroller = TextEditingController();
  final TextEditingController proBrandcontroller = TextEditingController();
  final TextEditingController proPricecontroller = TextEditingController();
  final TextEditingController pronStockcontroller = TextEditingController();
  final TextEditingController proDescriptioncontroller = TextEditingController();

  String proNameerror = "";
  String proCategoryerror = "";
  String proPriceerror = "";
  String proStockerror = "";
  String proDescriptionerror = "";

  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();

  void loadProductData(Map<String, dynamic> product) {
    // ID ko properly set karo - different field names try karo
    currentProductId =
        product['id']?.toString() ??
        product['prod_id']?.toString() ??
        product['product_id']?.toString();

    debugPrint('🔍 Loading product data:');
    debugPrint('Product Map: $product');
    debugPrint('Product ID: $currentProductId');

    proNamecontroller.text = product['prod_name'] ?? '';
    proBrandcontroller.text = product['prod_brand'] ?? '';
    proPricecontroller.text = product['prod_price']?.toString() ?? '';
    pronStockcontroller.text = product['prod_stock']?.toString() ?? '';
    proDescriptioncontroller.text = product['prod_description'] ?? '';
    existingImageUrl = product['prod_img'];
    selectedImage = null;

    notifyListeners();
  }

  bool proValidateform(BuildContext context) {
    bool isvalid = true;

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

      // Agar naya image select kiya hai toh upload karo
      if (selectedImage != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
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

      // Product update karo with .eq() clause
      await supabase
          .from('tbl_products')
          .update({
            'prod_name': proNamecontroller.text,
            'prod_img': imageUrl,
            'prod_brand': proBrandcontroller.text,
            'prod_price': double.tryParse(proPricecontroller.text) ?? 0.0,
            'prod_stock': int.tryParse(pronStockcontroller.text) ?? 0,
            'prod_description': proDescriptioncontroller.text,
          })
          .eq('id', currentProductId!);

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
    pronStockcontroller.clear();
    proDescriptioncontroller.clear();
    selectedImage = null;
    currentProductId = null;
    existingImageUrl = null;

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
