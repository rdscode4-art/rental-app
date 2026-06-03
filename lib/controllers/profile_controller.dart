import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rentalvender/screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';
import '../screens/documents_screen.dart';

class ProfileController extends GetxController {
  RxString vendorName = 'Alex Morgan'.obs;
  RxString agencyName = 'Goa Rentals'.obs;
  RxString mobile = '+91 98765 43210'.obs;
  RxString email = 'vendor@rideal.com'.obs;
  RxString city = 'Goa, India'.obs;
  RxBool isVerified = true.obs;

  RxInt totalVehicles = 12.obs;
  RxInt totalBookings = 248.obs;
  RxDouble rating = 4.8.obs;

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
    Get.offAll(() => const LoginScreen());
    Get.snackbar(
      "Success",
      "Logged out successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
