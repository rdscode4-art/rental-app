import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../controllers/vehicle_controller.dart';
import 'add_vehicle_screen.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VehicleController controller = Get.put(VehicleController());

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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingLarge),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Vehicles',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.whiteText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.vehicles.length} vehicles in fleet',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppTheme.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(
                        () => const AddVehicleScreen(),
                      )?.then((_) => controller.refreshVehicles()),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.glowShadow,
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Filter Chips
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingLarge,
                  ),
                  itemCount: controller.filters.length,
                  itemBuilder: (context, index) {
                    final filter = controller.filters[index];
                    return Obx(() {
                      final isSelected =
                          controller.selectedFilter.value == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => controller.changeFilter(filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppTheme.primaryGradient
                                  : null,
                              color: isSelected ? null : AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: isSelected
                                  ? AppTheme.glowShadow
                                  : null,
                            ),
                            child: Text(
                              filter,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.greyText,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Vehicle List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryPurple,
                      ),
                    );
                  }

                  final vehicles = controller.filteredVehicles;

                  if (vehicles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car_rounded,
                            size: 80,
                            color: AppTheme.greyText.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Vehicles Found',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.greyText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first vehicle to get started',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppTheme.darkGreyText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingLarge,
                    ),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vehicle Image
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryPurple.withOpacity(0.3),
                                      AppTheme.primaryBlue.withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: vehicle.imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Image.network(
                                          vehicle.imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    _getVehicleIcon(
                                                      vehicle.type,
                                                    ),
                                                    size: 80,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  ),
                                                );
                                              },
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                );
                                              },
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          _getVehicleIcon(vehicle.type),
                                          size: 80,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                              ),
                              // Vehicle Details
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            vehicle.name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.whiteText,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: vehicle.isAvailable
                                                ? AppTheme.successGreen
                                                      .withOpacity(0.2)
                                                : AppTheme.errorRed.withOpacity(
                                                    0.2,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            vehicle.isAvailable
                                                ? 'Available'
                                                : 'Unavailable',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: vehicle.isAvailable
                                                  ? AppTheme.successGreen
                                                  : AppTheme.errorRed,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.confirmation_number_outlined,
                                          size: 16,
                                          color: AppTheme.greyText,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          vehicle.numberPlate,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: AppTheme.greyText,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.category_outlined,
                                          size: 16,
                                          color: AppTheme.greyText,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          vehicle.type,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: AppTheme.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          size: 16,
                                          color: AppTheme.primaryGreen,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${vehicle.pricePerHour}/hr',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primaryGreen,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 16,
                                          color: AppTheme.primaryBlue,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${vehicle.pricePerDay}/day',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primaryBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.neonGlow,
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.to(
              () => const AddVehicleScreen(),
            )?.then((_) => controller.refreshVehicles());
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Add Vehicle',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getVehicleIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
      case 'sedan':
        return Icons.directions_car_rounded;
      case 'bike':
        return Icons.two_wheeler_rounded;
      case 'suv':
        return Icons.airport_shuttle_rounded;
      case 'ev':
        return Icons.electric_car_rounded;
      case 'auto':
        return Icons.electric_rickshaw_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }
}
