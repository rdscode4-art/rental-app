import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryPurple.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.whiteText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.glowShadow,
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Profile Card
                Obx(() => GlassCard(
                  child: Column(
                    children: [
                      // Profile Image
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.primaryGradient,
                          boxShadow: AppTheme.glowShadow,
                        ),
                        child: const Center(
                          child: Text(
                            'AM',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.vendorName.value,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.whiteText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.agencyName.value,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppTheme.greyText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Verified Vendor',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            controller.totalVehicles.value.toString(),
                            'Vehicles',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppTheme.greyText.withOpacity(0.3),
                          ),
                          _buildStatItem(
                            controller.totalBookings.value.toString(),
                            'Bookings',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppTheme.greyText.withOpacity(0.3),
                          ),
                          _buildStatItem(
                            controller.rating.value.toString(),
                            'Rating',
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                // Menu Options
                _buildMenuOption(
                  Icons.edit_rounded,
                  'Edit Profile',
                  'Update your personal information',
                  controller.editProfile,
                ),
                const SizedBox(height: 12),
                _buildMenuOption(
                  Icons.description_outlined,
                  'Documents',
                  'Manage your documents',
                  controller.viewDocuments,
                ),
                const SizedBox(height: 12),
                // _buildMenuOption(
                //   Icons.notifications_outlined,
                //   'Notifications',
                //   'Manage notification preferences',
                //   controller.manageNotifications,
                // ),
                const SizedBox(height: 12),
                _buildMenuOption(
                  Icons.help_outline_rounded,
                  'Help & Support',
                  'Get help and contact support',
                  controller.helpSupport,
                ),
                const SizedBox(height: 12),
                _buildMenuOption(
                  Icons.info_outline_rounded,
                  'About',
                  'App version and information',
                  controller.aboutApp,
                ),
                const SizedBox(height: 24),
                // Logout Button
                GlassCard(
                  child: InkWell(
                    onTap: controller.showLogoutDialog,
                    borderRadius: AppTheme.cardRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.errorRed.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: AppTheme.errorRed,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Logout',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.errorRed,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sign out from your account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppTheme.greyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppTheme.errorRed,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Rideal Renatl v1.0.0',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.darkGreyText,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.whiteText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppTheme.greyText,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GlassCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.cardRadius,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryPurple, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.whiteText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppTheme.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.greyText,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
