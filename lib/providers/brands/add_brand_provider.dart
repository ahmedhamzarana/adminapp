// lib/providers/brands/add_brand_provider.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBrandProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

  String nameError = "";
  String imageError = "";

  bool validateBrandForm() {
    bool isValid = true;
    nameError = "";
    imageError = "";

    if (nameController.text.trim().isEmpty) {
      nameError = "Brand Name is required";
      isValid = false;
    }

    if (selectedImage == null && imageUrl == null) {
      imageError = "Brand Image is required";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = image;
      imageError = "";
      notifyListeners();
    }
  }

  Future<bool> addBrand() async {
    try {
      isLoading = true;
      notifyListeners();

      String newImageUrl = '';

      if (selectedImage != null) {
        final fileName = 'brand_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await selectedImage!.readAsBytes();

        await supabase.storage.from('brand_images').uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        newImageUrl = supabase.storage.from('brand_images').getPublicUrl(fileName);
      }

      await supabase.from('tbl_brand').insert({
        'brand_name': nameController.text.trim(),
        'brand_img_url': newImageUrl,
      });

      clearForm();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error adding brand: $e');
      return false;
    }
  }

  void setEditData(int id, String name, String imgUrl) {
    nameController.text = name;
    imageUrl = imgUrl;
    notifyListeners();
  }

  Future<bool> updateBrand(int brandId) async {
    try {
      isLoading = true;
      notifyListeners();

      String newImageUrl = imageUrl ?? '';

      if (selectedImage != null) {
        final fileName = 'brand_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await selectedImage!.readAsBytes();

        await supabase.storage.from('brand_images').uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        newImageUrl = supabase.storage.from('brand_images').getPublicUrl(fileName);
      }

      await supabase.from('tbl_brand').update({
        'brand_name': nameController.text.trim(),
        'brand_img_url': newImageUrl,
      }).eq('id', brandId);

      clearForm();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error updating brand: $e');
      return false;
    }
  }

  void clearForm() {
    nameController.clear();
    selectedImage = null;
    imageUrl = null;
    nameError = "";
    imageError = "";
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}