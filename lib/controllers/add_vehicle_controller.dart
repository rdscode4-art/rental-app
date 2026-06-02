import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../utils/app_theme.dart';

class AddVehicleController extends GetxController {
  final nameController = TextEditingController();
  final numberPlateController = TextEditingController();
  final pricePerHourController = TextEditingController();
  final pricePerDayController = TextEditingController();
  final descriptionController = TextEditingController();
  RxString selectedType = 'Scooty'.obs;
  RxString selectedFuelType = 'Petrol'.obs;
  RxBool isAvailable = true.obs;
  RxBool isLoading = false.obs;

  final List<String> vehicleTypes = ['Scooty', 'Bike', 'Car'];
  final List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'CNG'];
  final ImagePicker _picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final source = await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'Select Image Source',
          style: TextStyle(color: AppTheme.whiteText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryPurple),
              title: const Text(
                'Camera',
                style: TextStyle(color: AppTheme.whiteText),
              ),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.primaryPurple),
              title: const Text(
                'Gallery',
                style: TextStyle(color: AppTheme.whiteText),
              ),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    
    if (source == null) return;
    
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void changeVehicleType(String? type) {
    if (type != null) {
      selectedType.value = type;
    }
  }

  void changeFuelType(String? fuel) {
    if (fuel != null) {
      selectedFuelType.value = fuel;
    }
  }

  void toggleAvailability(bool value) {
    isAvailable.value = value;
  }

  void saveVehicle() {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter vehicle name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (numberPlateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter number plate",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (pricePerHourController.text.isEmpty || pricePerDayController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter pricing details",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.back();
      Get.snackbar(
        "Success",
        "Vehicle added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    numberPlateController.dispose();
    pricePerHourController.dispose();
    pricePerDayController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
