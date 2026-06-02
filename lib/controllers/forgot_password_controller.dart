import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool emailSent = false.obs;

  void sendResetLink() {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      emailSent.value = true;
      
      Get.snackbar(
        "Email Sent",
        "Password reset link has been sent to ${emailController.text}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // Navigate back after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        Get.back();
      });
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
