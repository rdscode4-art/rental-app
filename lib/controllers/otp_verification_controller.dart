import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../screens/new_signup_screen.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class OtpVerificationController extends GetxController {
  final String phoneNumber;
  
  OtpVerificationController({required this.phoneNumber});
  
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  
  RxBool isLoading = false.obs;
  RxBool canResend = false.obs;
  RxInt remainingTime = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    canResend.value = false;
    remainingTime.value = 30;
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String getOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOTP() async {
    String otp = getOTP();
    
    if (otp.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter complete 6-digit OTP",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    // Call API service
    final result = await ApiService.verifyOtp(phoneNumber, otp);
    
    isLoading.value = false;

    if (result['success']) {
      // Extract token from response - check multiple possible keys
      final responseData = result['data'];
      String token = '';
      
      // Try different token field names
      if (responseData['tempToken'] != null) {
        token = responseData['tempToken'];
      } else if (responseData['token'] != null) {
        token = responseData['token'];
      } else if (responseData['accessToken'] != null) {
        token = responseData['accessToken'];
      } else if (responseData['data'] != null && responseData['data']['token'] != null) {
        token = responseData['data']['token'];
      } else if (responseData['data'] != null && responseData['data']['accessToken'] != null) {
        token = responseData['data']['accessToken'];
      } else if (responseData['data'] != null && responseData['data']['tempToken'] != null) {
        token = responseData['data']['tempToken'];
      }
      
      print('═══════════════════════════════════');
      print('✅ OTP VERIFIED SUCCESSFULLY');
      print('═══════════════════════════════════');
      print('Full Response: $responseData');
      print('Extracted Token: $token');
      print('Token Length: ${token.length}');
      print('Token is Empty: ${token.isEmpty}');
      print('═══════════════════════════════════');
      
      if (token.isEmpty) {
        Get.snackbar(
          "Error",
          "Authentication token not received. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.errorRed,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }
      
      // Save token and phone number to storage
      StorageService.saveToken(token);
      StorageService.savePhoneNumber(phoneNumber);
      
      Get.snackbar(
        "Success",
        result['data']['message'] ?? "OTP verified successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to signup screen
      Get.off(
        () => const NewSignupScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Invalid OTP. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> resendOTP() async {
    // Call API service
    final result = await ApiService.sendOtp(phoneNumber);

    if (result['success']) {
      Get.snackbar(
        "Success",
        "OTP resent successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      // Clear OTP fields
      for (var controller in otpControllers) {
        controller.clear();
      }
      focusNodes[0].requestFocus();
      
      // Restart timer
      startTimer();
    } else {
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Failed to resend OTP. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
