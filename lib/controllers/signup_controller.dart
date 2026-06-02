import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../screens/main_navigation.dart';
import '../utils/app_theme.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final agencyController = TextEditingController();
  
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool acceptTerms = false.obs;
  RxBool isLoading = false.obs;
  RxString selectedCity = 'Goa'.obs;
  Rx<File?> profileImage = Rx<File?>(null);
  
  final ImagePicker _picker = ImagePicker();

  final List<String> cities = [
    'Goa',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Jaipur',
    'Udaipur',
    'Manali',
    'Kerala',
  ];

  Future<void> pickProfileImage() async {
    final source = await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'Select Image Source',
          style: TextStyle(color: AppTheme.whiteText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryPurple),
              title: const Text(
                'Camera',
                style: TextStyle(color: AppTheme.whiteText),
              ),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.primaryPurple),
              title: const Text(
                'Gallery',
                style: TextStyle(color: AppTheme.whiteText),
              ),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    
    if (source == null) return;
    
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleAcceptTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }

  void changeCity(String? city) {
    if (city != null) {
      selectedCity.value = city;
    }
  }

  void signup() {
    if (!acceptTerms.value) {
      Get.snackbar(
        "Error",
        "Please accept terms and conditions",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;
    
    // Fast navigation - reduced delay
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
      Get.offAll(() => const MainNavigation(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 300));
      Get.snackbar(
        "Success",
        "Registration Successful",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    agencyController.dispose();
    super.onClose();
  }
}
