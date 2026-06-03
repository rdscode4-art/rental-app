import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final OtpVerificationController controller = Get.put(OtpVerificationController(phoneNumber: phoneNumber));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryGreen.withOpacity(0.1),
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
                const SizedBox(height: 40),
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.glowShadow,
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.primaryGradient.createShader(bounds),
                        child: Text(
                          'Enter OTP',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent a code to',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.greyText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phoneNumber,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // OTP Input
                GlassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45,
                            child: TextField(
                              controller: controller.otpControllers[index],
                              focusNode: controller.focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.whiteText,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyText.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryGreen,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: AppTheme.surfaceColor.withOpacity(0.5),
                              ),
                              onChanged: (value) => controller.onOtpChange(value, index),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 30),
                      // Timer and Resend
                      Obx(() => controller.canResend.value
                          ? TextButton(
                              onPressed: controller.resendOTP,
                              child: Text(
                                'Resend OTP',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            )
                          : Text(
                              'Resend OTP in ${controller.remainingTime.value}s',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppTheme.greyText,
                              ),
                            )),
                      const SizedBox(height: 20),
                      Obx(() => GradientButton(
                        text: controller.isLoading.value ? 'Verifying...' : 'Verify OTP',
                        onPressed: controller.isLoading.value ? () {} : controller.verifyOTP,
                        icon: Icons.check_circle_outline,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
