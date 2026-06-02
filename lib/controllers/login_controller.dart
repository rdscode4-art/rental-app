import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rentalvender/screens/main_navigation.dart';
import '../utils/app_theme.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController(text: 'vendor@rideal.com');
  final passwordController = TextEditingController(text: '123456');
  RxBool isPasswordVisible = false.obs;
  RxBool remember = false.obs;
  RxBool isLoading = false.obs;
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    remember.value = value ?? false;
  }

  void login() async {
    // Set loading
    isLoading.value = true;
    
    // Simulate API call with minimal delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Reset loading
    isLoading.value = false;
    
    // Fast navigation
    Get.offAll(
      () => const MainNavigation(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    
    // Show success message
    Get.snackbar(
      "Success",
      "Welcome back!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.successGreen,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void signInWithGoogle() async {
    // Show loading
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
              ),
              SizedBox(height: 16),
              Text(
                'Signing in with Google...',
                style: TextStyle(
                  color: AppTheme.whiteText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    
    // Simulate Google Sign-In process
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Close loading dialog
    Get.back();
    
    // Fast navigation
    Get.offAll(
      () => const MainNavigation(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    
    // Show success message
    Get.snackbar(
      "Success",
      "Signed in with Google successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.successGreen,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
