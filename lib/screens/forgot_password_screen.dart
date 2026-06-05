import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/forgot_password_controller.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(
      ForgotPasswordController(),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryGreen.withOpacity(0.05),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.whiteText,
                  ),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.glowShadow,
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Reset Password',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.whiteText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Verify your registered mobile number and create a new password.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppTheme.greyText,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Obx(
                  () => GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepper(controller.currentStep.value),
                        const SizedBox(height: 28),
                        _buildStepContent(controller),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Back to Login',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(ForgotPasswordStep step) {
    final currentIndex = ForgotPasswordStep.values.indexOf(step).clamp(0, 2);
    final labels = ['Phone', 'OTP', 'Reset'];

    return Row(
      children: List.generate(labels.length, (index) {
        final isActive = index <= currentIndex;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryGreen
                      : AppTheme.surfaceColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? AppTheme.primaryGreen
                        : AppTheme.greyText.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.whiteText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  labels[index],
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppTheme.whiteText : AppTheme.greyText,
                  ),
                ),
              ),
              if (index != labels.length - 1)
                Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: isActive
                        ? AppTheme.primaryGreen.withOpacity(0.8)
                        : AppTheme.greyText.withOpacity(0.2),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepContent(ForgotPasswordController controller) {
    switch (controller.currentStep.value) {
      case ForgotPasswordStep.phone:
        return _buildPhoneStep(controller);
      case ForgotPasswordStep.otp:
        return _buildOtpStep(controller);
      case ForgotPasswordStep.reset:
        return _buildResetStep(controller);
      case ForgotPasswordStep.done:
        return _buildSuccessStep();
    }
  }

  Widget _buildPhoneStep(ForgotPasswordController controller) {
    return Column(
      children: [
        CustomTextField(
          controller: controller.phoneController,
          label: 'Mobile Number',
          hint: 'Enter registered mobile number',
          prefixIcon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          maxLength: 10,
        ),
        const SizedBox(height: 28),
        Obx(
          () => GradientButton(
            text: controller.isLoading.value ? 'Sending...' : 'Send OTP',
            icon: Icons.sms_rounded,
            onPressed: controller.isLoading.value ? () {} : controller.sendOtp,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep(ForgotPasswordController controller) {
    return Column(
      children: [
        CustomTextField(
          controller: controller.otpController,
          label: 'OTP',
          hint: 'Enter 6 digit OTP',
          prefixIcon: Icons.password_rounded,
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.backToPhoneStep,
            child: Text(
              'Change Number',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => GradientButton(
            text: controller.isLoading.value ? 'Verifying...' : 'Verify OTP',
            icon: Icons.verified_user_rounded,
            onPressed: controller.isLoading.value
                ? () {}
                : controller.verifyOtp,
          ),
        ),
      ],
    );
  }

  Widget _buildResetStep(ForgotPasswordController controller) {
    return Column(
      children: [
        Obx(
          () => CustomTextField(
            controller: controller.newPasswordController,
            label: 'New Password',
            hint: 'Create new password',
            prefixIcon: Icons.lock_outline,
            obscureText: !controller.isNewPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isNewPasswordVisible.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppTheme.greyText,
              ),
              onPressed: controller.toggleNewPasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => CustomTextField(
            controller: controller.confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Confirm new password',
            prefixIcon: Icons.lock_reset_rounded,
            obscureText: !controller.isConfirmPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppTheme.greyText,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Obx(
          () => GradientButton(
            text: controller.isLoading.value ? 'Updating...' : 'Reset Password',
            icon: Icons.done_rounded,
            onPressed: controller.isLoading.value
                ? () {}
                : controller.resetPassword,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.18),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            size: 56,
            color: AppTheme.successGreen,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Password Updated',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.whiteText,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'You can now login with your new password.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppTheme.greyText,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
