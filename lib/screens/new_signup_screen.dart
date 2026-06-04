import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';
import '../controllers/new_signup_controller.dart';

class NewSignupScreen extends StatelessWidget {
  const NewSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewSignupController controller = Get.put(NewSignupController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryPurple.withOpacity(0.1),
              AppTheme.primaryBlue.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios, color: AppTheme.whiteText),
                ),
                const SizedBox(height: 20),
                // Header
                Center(
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.primaryGradient.createShader(bounds),
                        child: Text(
                          'Complete Profile',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in your details to get started',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Profile Photo
                Center(
                  child: GestureDetector(
                    onTap: controller.pickProfileImage,
                    child: Obx(
                      () => Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.cardColor,
                              border: Border.all(
                                color: AppTheme.primaryPurple,
                                width: 2,
                              ),
                            ),
                            child: controller.profileImage.value != null
                                ? ClipOval(
                                    child: Image.file(
                                      controller.profileImage.value!,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppTheme.greyText,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: AppTheme.glowShadow,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Basic Information
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Information',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.whiteText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.nameController,
                        label: 'Full Name *',
                        hint: 'Enter your full name',
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.emailController,
                        label: 'Email *',
                        hint: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.agencyController,
                        label: 'Agency Name (Optional)',
                        hint: 'Enter your agency name',
                        prefixIcon: Icons.business_outlined,
                      ),
                      const SizedBox(height: 20),
                      Obx(() => CustomTextField(
                        controller: controller.passwordController,
                        label: 'Password *',
                        hint: 'Create a password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !controller.isPasswordVisible.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            !controller.isPasswordVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppTheme.greyText,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Address Information
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address Information',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.whiteText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.streetController,
                        label: 'Street *',
                        hint: 'e.g., 12, MG Road',
                        prefixIcon: Icons.signpost_outlined,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.areaController,
                        label: 'Area *',
                        hint: 'e.g., Koramangala',
                        prefixIcon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: controller.cityController,
                              label: 'City *',
                              hint: 'e.g., Bengaluru',
                              prefixIcon: Icons.location_city_outlined,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: controller.stateController,
                              label: 'State *',
                              hint: 'e.g., Karnataka',
                              prefixIcon: Icons.map_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.pincodeController,
                        label: 'Pincode *',
                        hint: 'e.g., 560034',
                        prefixIcon: Icons.pin_outlined,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Aadhar Information
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aadhar Card Details',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.whiteText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.aadharNumberController,
                        label: 'Aadhar Number *',
                        hint: '1234 5678 9012',
                        prefixIcon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        maxLength: 14,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildImageUpload(
                              controller,
                              'Aadhar Front *',
                              controller.aadharFrontImage,
                              controller.pickAadharFrontImage,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildImageUpload(
                              controller,
                              'Aadhar Back *',
                              controller.aadharBackImage,
                              controller.pickAadharBackImage,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // PAN Information
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PAN Card Details',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.whiteText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.panNumberController,
                        label: 'PAN Number *',
                        hint: 'e.g., LQMPK6752N',
                        prefixIcon: Icons.badge_outlined,
                        maxLength: 10,
                      ),
                      const SizedBox(height: 20),
                      _buildImageUpload(
                        controller,
                        'PAN Card Image *',
                        controller.panCardImage,
                        controller.pickPanCardImage,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Submit Button
                Obx(() => GradientButton(
                  text: controller.isLoading.value ? 'Submitting...' : 'Complete Profile',
                  onPressed: controller.isLoading.value ? () {} : controller.completeProfile,
                  icon: Icons.check_circle_outline,
                )),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUpload(
    NewSignupController controller,
    String label,
    Rx<File?> imageValue,
    Function onTap,
  ) {
    return Obx(() {
      final file = imageValue.value;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.greyText,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => onTap(),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: file != null
                    ? AppTheme.primaryGreen.withOpacity(0.1)
                    : AppTheme.surfaceColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: file != null
                      ? AppTheme.primaryGreen
                      : AppTheme.greyText.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: file != null
                  ? Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              file,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => imageValue.value = null,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.errorRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 32,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Upload",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppTheme.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }
}
