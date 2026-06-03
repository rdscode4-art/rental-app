import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/app_theme.dart';

class EditProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  
  final nameController = TextEditingController(text: 'Alex Morgan');
  final agencyController = TextEditingController(text: 'Goa Rentals');
  final mobileController = TextEditingController(text: '+91 98765 43210');
  final emailController = TextEditingController(text: 'vendor@rideal.com');
  final cityController = TextEditingController(text: 'Goa');
  
  Rx<File?> profileImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxString selectedCity = 'Goa'.obs;
List<String> cities = ['Goa', 'Delhi', 'Mumbai', 'Bangalore'];

void changeCity(String? city) {
  if (city != null) selectedCity.value = city;
}


  Future<void> pickProfileImage() async {
    try {
      final source = await Get.dialog<ImageSource>(
        AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: Text('Select Image Source', style: TextStyle(color: AppTheme.whiteText)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppTheme.primaryGreen),
                title: Text('Camera', style: TextStyle(color: AppTheme.whiteText)),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppTheme.primaryGreen),
                title: Text('Gallery', style: TextStyle(color: AppTheme.whiteText)),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        Get.snackbar("Success", "Profile image updated",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.successGreen, colorText: Colors.white, duration: const Duration(seconds: 1));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
    }
  }

  void saveProfile() {
    if (nameController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your name",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
      return;
    }

    if (mobileController.text.isEmpty) {
      Get.snackbar("Error", "Please enter mobile number",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar("Success", "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.successGreen, colorText: Colors.white, duration: const Duration(seconds: 2));
      
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    agencyController.dispose();
    mobileController.dispose();
    emailController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
