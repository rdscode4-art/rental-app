import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class EditProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  
  final nameController = TextEditingController();
  final agencyController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  
  Rx<File?> profileImage = Rx<File?>(null);
  RxString profilePhotoUrl = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;

    final token = StorageService.getToken();
    
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Please login again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    final result = await ApiService.getProfile(token);

    isLoading.value = false;

    if (result['success']) {
      // Extract profile data
      Map<String, dynamic> data = {};
      
      if (result['data']['data'] != null) {
        data = result['data']['data'];
      } else if (result['data']['owner'] != null) {
        data = result['data']['owner'];
      } else if (result['data']['user'] != null) {
        data = result['data']['user'];
      } else {
        data = result['data'];
      }
      
      // Populate fields
      nameController.text = data['name']?.toString() ?? '';
      agencyController.text = data['agencyName']?.toString() ?? '';
      mobileController.text = data['phone']?.toString() ?? '';
      emailController.text = data['email']?.toString() ?? '';
      
      // Check multiple possible field names for profile photo
      String photoPath = data['profilePhoto']?.toString() ?? 
                         data['profilePicture']?.toString() ?? 
                         data['avatar']?.toString() ?? 
                         data['photo']?.toString() ?? 
                         data['image']?.toString() ?? '';
      
      // Convert relative path to full URL
      if (photoPath.isNotEmpty && !photoPath.startsWith('http')) {
        profilePhotoUrl.value = 'https://backend.ridealmobility.com$photoPath';
      } else {
        profilePhotoUrl.value = photoPath;
      }
      
      print('📸 Edit Profile - Photo URL: ${profilePhotoUrl.value}');
      print('📸 Edit Profile - Is URL Empty: ${profilePhotoUrl.value.isEmpty}');
      
      // Address
      if (data['address'] != null) {
        final address = data['address'];
        cityController.text = address['city']?.toString() ?? '';
      }
      
      print('✅ Profile loaded in edit screen');
    } else {
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Failed to load profile",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
    }
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
