import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rentalvender/screens/main_navigation.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

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
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    
    // Validation
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    // Call API
    final result = await ApiService.login(email, password);

    isLoading.value = false;

    if (result['success']) {
      final responseData = result['data'];
      
      // Extract token
      String token = '';
      if (responseData['token'] != null) {
        token = responseData['token'];
      } else if (responseData['accessToken'] != null) {
        token = responseData['accessToken'];
      } else if (responseData['data'] != null && responseData['data']['token'] != null) {
        token = responseData['data']['token'];
      }
      
      print('═══════════════════════════════════');
      print('✅ LOGIN SUCCESSFUL');
      print('🔑 Token: ${token.isNotEmpty ? "${token.substring(0, 30)}..." : "NOT FOUND"}');
      print('═══════════════════════════════════');
      
      // Save token to storage
      if (token.isNotEmpty) {
        StorageService.saveToken(token);
      }
      
      // Save user data if available
      if (responseData['user'] != null || responseData['data'] != null) {
        StorageService.saveUserData(responseData['user'] ?? responseData['data'] ?? {});
      }
      
      Get.snackbar(
        "Success",
        responseData['message'] ?? "Welcome back!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to main screen
      Get.offAll(
        () => const MainNavigation(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Invalid credentials. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
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
