import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../controllers/earnings_controller.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EarningsController controller = Get.put(EarningsController());

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earnings',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.whiteText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Track your revenue',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppTheme.greyText,
                          ),
                        ),
                      ],
                    ),
                  
                  ],
                ),
                const SizedBox(height: 30),
                // Wallet Balance
                Obx(() => GlassCard(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Wallet Balance',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '₹${controller.walletBalance.value}',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Available to withdraw',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.withdrawMoney,
                              borderRadius: BorderRadius.circular(12),
                              child: Center(
                                child: Text(
                                  'Withdraw',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryPurple,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                // Earnings Stats
                Obx(() => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildEarningCard(
                            'Today',
                            '₹${controller.todayEarnings.value}',
                            Icons.today_rounded,
                            AppTheme.successGreen,
                            '+8.5%',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildEarningCard(
                            'This Week',
                            '₹${controller.weeklyEarnings.value}',
                            Icons.calendar_view_week_rounded,
                            AppTheme.infoBlue,
                            '+12.3%',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildEarningCard(
                            'This Month',
                            '₹${controller.monthlyEarnings.value}',
                            Icons.calendar_month_rounded,
                            AppTheme.primaryPurple,
                            '+15.7%',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildEarningCard(
                            'Total',
                            '₹${controller.totalEarnings.value}',
                            Icons.trending_up_rounded,
                            AppTheme.warningOrange,
                            '+22.1%',
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEarningCard(
    String title,
    String amount,
    IconData icon,
    Color color,
    String percentage,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentage,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.greyText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.whiteText,
            ),
          ),
        ],
      ),
    );
  }
}
