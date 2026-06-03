import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../screens/main_navigation.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';

class NewSignupController extends GetxController {
  final String phoneNumber;
  final String token;
  
  NewSignupController({required this.phoneNumber, required this.token});
  
  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final agencyController = TextEditingController();
  final passwordController = TextEditingController();
  final aadharNumberController = TextEditingController();
  final panNumberController = TextEditingController();
  final streetController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  
  // Observable variables
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  Rx<File?> profileImage = Rx<File?>(null);
  Rx<File?> aadharFrontImage = Rx<File?>(null);
  Rx<File?> aadharBackImage = Rx<File?>(null);
  Rx<File?> panCardImage = Rx<File?>(null);
  
  final ImagePicker _picker = ImagePicker();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> _pickImage(Rx<File?> imageVariable) async {
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
      imageVariable.value = File(image.path);
    }
  }

  Future<void> pickProfileImage() async => _pickImage(profileImage);
  Future<void> pickAadharFrontImage() async => _pickImage(aadharFrontImage);
  Future<void> pickAadharBackImage() async => _pickImage(aadharBackImage);
  Future<void> pickPanCardImage() async => _pickImage(panCardImage);

  bool _validateFields() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter your full name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (emailController.text.trim().isEmpty || !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Please enter a valid email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (passwordController.text.trim().isEmpty || passwordController.text.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (streetController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter street address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (areaController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter area",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter city",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (stateController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter state",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (pincodeController.text.trim().isEmpty || pincodeController.text.length != 6) {
      Get.snackbar("Error", "Please enter valid 6-digit pincode",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (aadharNumberController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter Aadhar number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (aadharFrontImage.value == null) {
      Get.snackbar("Error", "Please upload Aadhar front image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (aadharBackImage.value == null) {
      Get.snackbar("Error", "Please upload Aadhar back image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (panNumberController.text.trim().isEmpty || panNumberController.text.length != 10) {
      Get.snackbar("Error", "Please enter valid 10-character PAN number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    if (panCardImage.value == null) {
      Get.snackbar("Error", "Please upload PAN card image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
      return false;
    }

    return true;
  }

  Future<void> completeProfile() async {
    if (!_validateFields()) return;

    isLoading.value = true;

    try {
      final result = await ApiService.completeProfile(
        token: token,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        agencyName: agencyController.text.trim().isNotEmpty ? agencyController.text.trim() : null,
        aadharNumber: aadharNumberController.text.trim(),
        address: {
          'street': streetController.text.trim(),
          'area': areaController.text.trim(),
          'city': cityController.text.trim(),
          'state': stateController.text.trim(),
          'pincode': pincodeController.text.trim(),
        },
        profilePhoto: profileImage.value,
        aadharFront: aadharFrontImage.value,
        aadharBack: aadharBackImage.value,
        panNumber: panNumberController.text.trim(),
        panCard: panCardImage.value,
      );

      isLoading.value = false;

      // Check for 401 Unauthorized (Token expired/invalid)
      if (result['statusCode'] == 401) {
        print('🔴 TOKEN ERROR: Token is invalid or expired');
        
        Get.dialog(
          AlertDialog(
            backgroundColor: AppTheme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(Icons.lock_clock, color: AppTheme.warningOrange, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Session Expired',
                  style: GoogleFonts.poppins(
                    color: AppTheme.whiteText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Your session has expired. Please verify your phone number again to continue.',
              style: GoogleFonts.poppins(
                color: AppTheme.greyText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.back(); // Go back to verification
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Verify Again',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        return;
      }

      if (result['success']) {
        Get.snackbar(
          "Success",
          result['data']['message'] ?? "Profile completed successfully!",
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
        // Handle field-specific errors
        final responseData = result['data'];
        String errorMessage = '';
        
        print('═══════════════════════════════════');
        print('🔴 COMPLETE ERROR RESPONSE:');
        print('Response Data: $responseData');
        print('Status Code: ${result['statusCode']}');
        print('═══════════════════════════════════');
        
        // Check for validation errors
        if (responseData['errors'] != null) {
          final errors = responseData['errors'];
          print('🔴 Validation Errors Found: $errors');
          print('🔴 Errors Type: ${errors.runtimeType}');
          
          // Create detailed error message
          if (errors is Map) {
            errors.forEach((field, messages) {
              print('  Field: $field');
              print('  Messages: $messages');
              print('  Messages Type: ${messages.runtimeType}');
              
              if (messages is List) {
                for (var msg in messages) {
                  errorMessage += '• $msg\n';
                }
              } else if (messages is String) {
                errorMessage += '• $messages\n';
              } else {
                errorMessage += '• $messages\n';
              }
            });
          } else if (errors is String) {
            errorMessage = errors;
          }
        }
        
        // Check for error field (some APIs use 'error' instead of 'errors')
        if (responseData['error'] != null && errorMessage.isEmpty) {
          print('🔴 Single Error Found: ${responseData['error']}');
          errorMessage = responseData['error'].toString();
        }
        
        // If no specific errors, use generic message
        if (errorMessage.isEmpty) {
          errorMessage = responseData['message'] ?? "Failed to complete profile. Please try again.";
          print('🔴 Using Generic Error Message: $errorMessage');
        }
        
        print('═══════════════════════════════════');
        print('🔴 Final Error Message to Display:');
        print(errorMessage);
        print('═══════════════════════════════════');
        
        // Show error dialog with details
        Get.dialog(
          AlertDialog(
            backgroundColor: AppTheme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.errorRed, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Validation Error',
                  style: GoogleFonts.poppins(
                    color: AppTheme.whiteText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    errorMessage.trim(),
                    style: GoogleFonts.poppins(
                      color: AppTheme.greyText,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.errorRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.errorRed, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Check console for detailed error information',
                            style: GoogleFonts.poppins(
                              color: AppTheme.errorRed,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      print('❌ Exception in completeProfile: $e');
      Get.snackbar(
        "Error",
        "An error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    agencyController.dispose();
    passwordController.dispose();
    aadharNumberController.dispose();
    panNumberController.dispose();
    streetController.dispose();
    areaController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.onClose();
  }
}
