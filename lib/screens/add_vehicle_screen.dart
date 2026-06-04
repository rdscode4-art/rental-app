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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Images Section (Multiple)
                      Text(
                        'Vehicle Images',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.whiteText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: controller.pickVehicleImages,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryPurple.withOpacity(0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 32,
                                  color: AppTheme.primaryPurple,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Select Multiple Images',
                                  style: GoogleFonts.poppins(
                                    color: AppTheme.whiteText,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Display selected images
                      Obx(() => controller.vehicleImages.isNotEmpty
                          ? SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.vehicleImages.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme.primaryPurple,
                                        width: 2,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.file(
                                            controller.vehicleImages[index],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () => controller.removeVehicleImage(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox()),
                      const SizedBox(height: 24),
                      
                      // Vehicle Details
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle Details',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.whiteText,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.modelController,
                              label: 'Vehicle Model',
                              hint: 'e.g., Toyota Innova',
                              prefixIcon: Icons.directions_car_rounded,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.numberPlateController,
                              label: 'Number Plate',
                              hint: 'e.g., DL01AB1234',
                              prefixIcon: Icons.confirmation_number_outlined,
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
                                        child: Text(type.capitalize!),
                                      );
                                    }).toList(),
                                    onChanged: controller.changeVehicleType,
                                  ),
                                )),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Registration Date
                            GestureDetector(
                              onTap: controller.selectRegistrationDate,
                              child: AbsorbPointer(
                                child: CustomTextField(
                                  controller: controller.registrationDateController,
                                  label: 'Registration Date',
                                  hint: 'Select date',
                                  prefixIcon: Icons.calendar_today,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.colorController,
                              label: 'Color',
                              hint: 'e.g., White',
                              prefixIcon: Icons.color_lens_outlined,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.seatingCapacityController,
                              label: 'Seating Capacity',
                              hint: 'e.g., 7',
                              prefixIcon: Icons.airline_seat_recline_normal,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.hourlyRateController,
                              label: 'Hourly Rate',
                              hint: 'e.g., 150',
                              prefixIcon: Icons.currency_rupee,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: controller.dailyRateController,
                              label: 'Day Rate',
                              hint: 'e.g., 1200',
                              prefixIcon: Icons.payments_outlined,
                              keyboardType: TextInputType.number,
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
                                        child: Text(fuel.capitalize!),
                                      );
                                    }).toList(),
                                    onChanged: controller.changeFuelType,
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Documents Section
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle Documents',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.whiteText,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDocumentPicker(controller, 'RC', controller.rcDocument),
                            const SizedBox(height: 16),
                            _buildDocumentPicker(controller, 'Insurance', controller.insuranceDocument),
                            const SizedBox(height: 16),
                            _buildDocumentPicker(controller, 'Pollution', controller.pollutionDocument),
                            const SizedBox(height: 16),
                            _buildDocumentPicker(controller, 'Fitness', controller.fitnessDocument),
                            const SizedBox(height: 16),
                            _buildDocumentPicker(controller, 'Permit', controller.permitDocument),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Save Button
                      Obx(() => GradientButton(
                        text: controller.isLoading.value ? 'Adding Vehicle...' : 'Add Vehicle',
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

  Widget _buildDocumentPicker(AddVehicleController controller, String docType, Rx<File?> document) {
    return Obx(() => GestureDetector(
      onTap: () => controller.pickDocument(docType),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: document.value != null 
                ? AppTheme.primaryGreen 
                : AppTheme.greyText.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: document.value != null 
                    ? AppTheme.primaryGreen.withOpacity(0.2)
                    : AppTheme.greyText.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                document.value != null ? Icons.check_circle : Icons.upload_file,
                color: document.value != null ? AppTheme.primaryGreen : AppTheme.greyText,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$docType Document',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.whiteText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    document.value != null ? 'Document selected' : 'Tap to upload',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: document.value != null ? AppTheme.primaryGreen : AppTheme.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.greyText,
            ),
          ],
        ),
      ),
    ));
  }
}
