import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rentalvender/screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';
import '../screens/documents_screen.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Map<String, dynamic>> profileData = Rx<Map<String, dynamic>>({});
  
  // Observable variables with defaults
  RxString vendorName = 'Loading...'.obs;
  RxString agencyName = ''.obs;
  RxString mobile = ''.obs;
  RxString email = ''.obs;
  RxString city = ''.obs;
  RxString profilePhotoUrl = ''.obs;
  RxBool isVerified = true.obs;

  RxInt totalVehicles = 0.obs;
  RxInt totalBookings = 0.obs;
  RxDouble rating = 0.0.obs;

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
      vendorName.value = 'Guest';
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
      
      profileData.value = data;
      
      // Update observable variables
      vendorName.value = data['name']?.toString() ?? 'User';
      agencyName.value = data['agencyName']?.toString() ?? '';
      mobile.value = data['phone']?.toString() ?? '';
      email.value = data['email']?.toString() ?? '';
      
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
      
      print('📸 Profile Photo URL: ${profilePhotoUrl.value}');
      print('📸 Is URL Empty: ${profilePhotoUrl.value.isEmpty}');
      
      // Address
      if (data['address'] != null) {
        final address = data['address'];
        city.value = '${address['city'] ?? ''}, ${address['state'] ?? ''}'.trim();
      }
      
      // Stats
      totalVehicles.value = data['totalVehicles'] ?? 0;
      totalBookings.value = data['totalBookings'] ?? 0;
      rating.value = (data['rating'] ?? 0.0).toDouble();
      
      // Save to storage
      StorageService.saveUserData(data);
      
      print('✅ Profile loaded successfully');
      print('Profile Data: $data');
    } else {
      vendorName.value = 'Error loading profile';
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Failed to load profile",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
    }
  }

  void editProfile() {
    Get.to(() => EditProfileScreen());
  }

  void viewDocuments() {
    Get.to(() => const DocumentsScreen());
  }

  // void manageNotifications() {
  //   Get.snackbar(
  //     "Info",
  //     "Notification settings coming soon",
  //     snackPosition: SnackPosition.BOTTOM,
  //   );
  // }

  // void privacySettings() {
  //   Get.snackbar(
  //     "Info",
  //     "Privacy settings coming soon",
  //     snackPosition: SnackPosition.BOTTOM,
  //   );
  // }

  void helpSupport() {
    Get.defaultDialog(
      title: "Help & Support",
      middleText:
          "For assistance, contact us:\n\n📧 support@rideal.com\n📞 +91 98765 43210",
      textConfirm: "OK",
      onConfirm: () => Get.back(),
    );
  }

  void aboutApp() {
    Get.defaultDialog(
      title: "About RiDeal Rental Vendor",
      middleText: "Version 1.0.0\n\nPremium Vehicle Rental Management App",
      textConfirm: "OK",
      onConfirm: () => Get.back(),
    );
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        logout();
      },
    );
  }

  void logout() {
    // Clear storage
    StorageService.clearAll();
    
    Get.offAll(() => const LoginScreen());
    Get.snackbar(
      "Success",
      "Logged out successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.successGreen,
      colorText: Colors.white,
    );
  }
}
