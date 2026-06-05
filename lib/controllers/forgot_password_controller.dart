import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../utils/app_theme.dart';

enum ForgotPasswordStep { phone, otp, reset, done }

class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final Rx<ForgotPasswordStep> currentStep = ForgotPasswordStep.phone.obs;

  String _resetToken = '';

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _showError('Please enter a valid 10 digit phone number');
      return;
    }

    isLoading.value = true;
    final result = await ApiService.sendForgotPasswordOtp(phone);
    isLoading.value = false;

    if (result['success'] == true) {
      currentStep.value = ForgotPasswordStep.otp;
      _showSuccess(_messageFrom(result, 'OTP sent successfully'));
      return;
    }

    _showError(_messageFrom(result, 'Unable to send OTP'));
  }

  Future<void> verifyOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _showError('Please enter the 6 digit OTP');
      return;
    }

    isLoading.value = true;
    final result = await ApiService.verifyForgotPasswordOtp(phone, otp);
    isLoading.value = false;

    if (result['success'] == true) {
      _resetToken = _extractResetToken(result['data']);

      if (_resetToken.isEmpty) {
        _showError('Reset token not received. Please try again.');
        return;
      }

      currentStep.value = ForgotPasswordStep.reset;
      _showSuccess(_messageFrom(result, 'OTP verified successfully'));
      return;
    }

    _showError(_messageFrom(result, 'Invalid OTP'));
  }

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    if (_resetToken.isEmpty) {
      _showError('Session expired. Please verify OTP again.');
      currentStep.value = ForgotPasswordStep.otp;
      return;
    }

    isLoading.value = true;
    final result = await ApiService.resetForgotPassword(
      resetToken: _resetToken,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      currentStep.value = ForgotPasswordStep.done;
      _showSuccess(_messageFrom(result, 'Password reset successfully'));
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
      return;
    }

    _showError(_messageFrom(result, 'Unable to reset password'));
  }

  void backToPhoneStep() {
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    _resetToken = '';
    currentStep.value = ForgotPasswordStep.phone;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String _extractResetToken(dynamic data) {
    if (data is! Map) return '';

    final token = data['resetToken'] ?? data['token'];
    if (token is String && token.isNotEmpty) return token;

    final nestedData = data['data'];
    if (nestedData is Map) {
      final nestedToken = nestedData['resetToken'] ?? nestedData['token'];
      if (nestedToken is String && nestedToken.isNotEmpty) {
        return nestedToken;
      }
    }

    return '';
  }

  String _messageFrom(Map<String, dynamic> result, String fallback) {
    final data = result['data'];
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return fallback;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.errorRed,
      colorText: Colors.white,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.successGreen,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
