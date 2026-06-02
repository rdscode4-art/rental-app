import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';
import '../controllers/add_vehicle_controller.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddVehicleController controller = Get.put(AddVehicleController());
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
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.whiteText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add New Vehicle',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.whiteText,
                      ),
                    ),
                  ],
                ),
              ),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingLarge,
                  ),
                  child: Column(
                    children: [
                      // Image Upload Section
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Obx(
                          () => Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: controller.selectedImage.value != null
                                    ? AppTheme.primaryPurple
                                    : AppTheme.greyText.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: controller.selectedImage.value != null
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.file(
                                          controller.selectedImage.value!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () => controller.selectedImage.value = null,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
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
                                          size: 40,
                                          color: AppTheme.primaryPurple,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Upload Vehicle Image',
                                          style: GoogleFonts.poppins(
                                            color: AppTheme.whiteText,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Tap to select from camera or gallery',
                                          style: GoogleFonts.poppins(
                                            color: AppTheme.greyText,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Vehicle Details
                      GlassCard(
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: controller.nameController,
                              label: 'Vehicle Name',
                              hint: 'e.g., Honda Activa 6G',
                              prefixIcon: Icons.directions_car_rounded,
                            ),
                            const SizedBox(height: 20),
                            // Vehicle Type Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vehicle Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.whiteText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Obx(() => Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceColor.withOpacity(0.5),
                                    borderRadius: AppTheme.inputRadius,
                                    border: Border.all(
                                      color: AppTheme.greyText.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: controller.selectedType.value,
                                    dropdownColor: AppTheme.cardColor,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.category_outlined,
                                        color: AppTheme.greyText,
                                        size: 22,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: AppTheme.whiteText,
                                    ),
                                    items: controller.vehicleTypes.map((type) {
                                      return DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      );
                                    }).toList(),
                                    onChanged: controller.changeVehicleType,
                                  ),
                                )),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.numberPlateController,
                              label: 'Number Plate',
                              hint: 'e.g., GA 01 AB 1234',
                              prefixIcon: Icons.confirmation_number_outlined,
                            ),
                            const SizedBox(height: 20),
                            // Fuel Type Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fuel Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.whiteText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Obx(() => Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceColor.withOpacity(0.5),
                                    borderRadius: AppTheme.inputRadius,
                                    border: Border.all(
                                      color: AppTheme.greyText.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: controller.selectedFuelType.value,
                                    dropdownColor: AppTheme.cardColor,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.local_gas_station_outlined,
                                        color: AppTheme.greyText,
                                        size: 22,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: AppTheme.whiteText,
                                    ),
                                    items: controller.fuelTypes.map((fuel) {
                                      return DropdownMenuItem(
                                        value: fuel,
                                        child: Text(fuel),
                                      );
                                    }).toList(),
                                    onChanged: controller.changeFuelType,
                                  ),
                                )),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.pricePerHourController,
                                    label: 'Price per Hour',
                                    hint: '₹149',
                                    prefixIcon: Icons.currency_rupee,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.pricePerDayController,
                                    label: 'Price per Day',
                                    hint: '₹799',
                                    prefixIcon: Icons.currency_rupee,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.descriptionController,
                              label: 'Description',
                              hint: 'Enter vehicle description',
                              prefixIcon: Icons.description_outlined,
                              maxLines: 4,
                            ),
                            const SizedBox(height: 20),
                            // Availability Toggle
                            Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Availability',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.whiteText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.isAvailable.value ? 'Available for rent' : 'Not available',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppTheme.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: controller.isAvailable.value,
                                  onChanged: controller.toggleAvailability,
                                  activeColor: AppTheme.primaryPurple,
                                  activeTrackColor: AppTheme.primaryPurple.withOpacity(0.5),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Save Button
                      Obx(() => GradientButton(
                        text: controller.isLoading.value ? 'Saving...' : 'Save Vehicle',
                        onPressed: controller.isLoading.value ? () {} : controller.saveVehicle,
                        icon: Icons.check_circle_outline,
                      )),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
