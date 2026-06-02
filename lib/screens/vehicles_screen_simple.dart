import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../controllers/vehicle_controller.dart';

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
                    Obx(() => Column(
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
                    )),
                    // Container(
                    //   padding: const EdgeInsets.all(12),
                    //   decoration: BoxDecoration(
                    //     gradient: AppTheme.primaryGradient,
                    //     shape: BoxShape.circle,
                    //     boxShadow: AppTheme.glowShadow,
                    //   ),
                    //   child: const Icon(
                    //     Icons.filter_list_rounded,
                    //     color: Colors.white,
                    //     size: 24,
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Filter Chips
              // SizedBox(
              //   height: 50,
              //   child: Obx(() => ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingLarge),
              //     itemCount: controller.filters.length,
              //     itemBuilder: (context, index) {
              //       final filter = controller.filters[index];
              //       final isSelected = controller.selectedFilter.value == filter;
              //       return Padding(
              //         padding: const EdgeInsets.only(right: 12),
              //         child: GestureDetector(
              //           onTap: () => controller.changeFilter(filter),
              //           child: Container(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 24,
              //               vertical: 12,
              //             ),
              //             decoration: BoxDecoration(
              //               gradient: isSelected ? AppTheme.primaryGradient : null,
              //               color: isSelected ? null : AppTheme.cardColor,
              //               borderRadius: BorderRadius.circular(25),
              //               boxShadow: isSelected ? AppTheme.glowShadow : null,
              //             ),
              //             child: Text(
              //               filter,
              //               style: GoogleFonts.poppins(
              //                 fontSize: 14,
              //                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              //                 color: isSelected ? Colors.white : AppTheme.greyText,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   )),
              // ),
              const SizedBox(height: 16),
              // Vehicle List
              Expanded(
                child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingLarge),
                  itemCount: controller.filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = controller.filteredVehicles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Vehicle Image Placeholder
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
                              child: Center(
                                child: Icon(
                                  vehicle.type == 'Car'
                                      ? Icons.directions_car_rounded
                                      : vehicle.type == 'Bike'
                                          ? Icons.two_wheeler_rounded
                                          : Icons.moped_rounded,
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: AppTheme.warningOrange,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            vehicle.rating.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.whiteText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    vehicle.numberPlate,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: AppTheme.greyText,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Per Hour',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: AppTheme.greyText,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${vehicle.pricePerHour}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryPurple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Per Day',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: AppTheme.greyText,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${vehicle.pricePerDay}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryBlue,
                                              ),
                                            ),
                                          ],
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
                )),
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
            Get.snackbar(
              "Info",
              "Add vehicle feature coming soon",
              snackPosition: SnackPosition.BOTTOM,
            );
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
}
