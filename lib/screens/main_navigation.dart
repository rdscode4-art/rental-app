import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../controllers/bottom_nav_controller.dart';
import 'dashboard_screen.dart';
import 'bookings_screen.dart';
import 'vehicles_screen.dart';
import 'earnings_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    final List<Widget> screens = [
      const DashboardScreen(),
      const BookingsScreen(),
      const VehiclesScreen(),
      const EarningsScreen(),
      const ProfileScreen(),
    ];

    final List<NavItem> navItems = [
      NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
      NavItem(icon: Icons.calendar_today_rounded, label: 'Bookings'),
      NavItem(icon: Icons.directions_car_rounded, label: 'Vehicles'),
      NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Earnings'),
      NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Scaffold(
      extendBody: true,
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: screens,
      )),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.cardColor.withOpacity(0.9),
                    AppTheme.cardColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(navItems.length, (index) {
                  final isActive = controller.currentIndex.value == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOut,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: isActive
                                    ? AppTheme.primaryGradient
                                    : null,
                                shape: BoxShape.circle,
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.primaryPurple
                                              .withOpacity(0.5),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                navItems[index].icon,
                                color: isActive
                                    ? Colors.white
                                    : AppTheme.greyText,
                                size: isActive ? 26 : 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOut,
                              style: TextStyle(
                                fontSize: isActive ? 11 : 10,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? AppTheme.whiteText
                                    : AppTheme.greyText,
                              ),
                              child: Text(navItems[index].label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
