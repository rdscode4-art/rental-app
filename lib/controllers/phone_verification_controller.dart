import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../screens/otp_verification_screen.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';

class PhoneVerificationController extends GetxController {
  final phoneController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> sendOTP() async {
    String phone = phoneController.text.trim();
    
    // Validation
    if (phone.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter mobile number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (phone.length != 10) {
      Get.snackbar(
        "Error",
        "Please enter valid 10 digit mobile number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    // Call API service
    final result = await ApiService.sendOtp(phone);
    
    isLoading.value = false;

    if (result['success']) {
      Get.snackbar(
        "Success",
        result['data']['message'] ?? "OTP sent successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to OTP screen
      Get.to(
        () => OtpVerificationScreen(phoneNumber: phone),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Failed to send OTP",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
