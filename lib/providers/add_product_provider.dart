import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductProvider extends ChangeNotifier {
  final TextEditingController proNamecontroller = TextEditingController();
  final TextEditingController proCategorycontroller = TextEditingController();
  final TextEditingController proPricecontroller = TextEditingController();
  final TextEditingController pronStockcontroller = TextEditingController();
  final TextEditingController proDescriptioncontroller = TextEditingController();

  String proNameerror = "";
  String proCategoryerror = "";
  String proPriceerror = "";
  String proStockerror = "";
  String proDescriptionerror = "";

  bool proValidateform(BuildContext context) {
    bool isvalid = true;

    if (proNamecontroller.text.isEmpty) {
      proNameerror = "Product Name is required";
      isvalid = false;
    } if (proCategorycontroller.text.isEmpty) {
      proCategoryerror = "Product Category is required";
      isvalid = false;
    } if (proPricecontroller.text.isEmpty) {
      proPriceerror = "Product Price is required";
      isvalid = false;
    } if (pronStockcontroller.text.isEmpty) {
      proStockerror = "Product Stock is required";
      isvalid = false;
    } if (proDescriptioncontroller.text.isEmpty) {
      proDescriptionerror = "Product Description is required";
      isvalid = false;
    }
    notifyListeners();
    return isvalid;
  }

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      selectedImage = File(image.path);
      notifyListeners(); 
    }
  }

  
}
