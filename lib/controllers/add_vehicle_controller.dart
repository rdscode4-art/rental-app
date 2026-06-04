import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AddVehicleController extends GetxController {
  final modelController = TextEditingController();
  final numberPlateController = TextEditingController();
  final colorController = TextEditingController();
  final seatingCapacityController = TextEditingController();
  final registrationDateController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final dailyRateController = TextEditingController();
  
  RxString selectedType = 'bike'.obs;
  RxString selectedFuelType = 'petrol'.obs;
  RxBool isLoading = false.obs;

  final List<String> vehicleTypes = ['bike', 'sedan', 'suv', 'ev', 'car', 'auto', 'non-vehicle', 'HMV'];
  final List<String> fuelTypes = ['petrol', 'diesel', 'electric', 'cng'];
  final ImagePicker _picker = ImagePicker();

  // Multiple vehicle images
  RxList<File> vehicleImages = <File>[].obs;
  
  // Document files
  Rx<File?> rcDocument = Rx<File?>(null);
  Rx<File?> insuranceDocument = Rx<File?>(null);
  Rx<File?> pollutionDocument = Rx<File?>(null);
  Rx<File?> fitnessDocument = Rx<File?>(null);
  Rx<File?> permitDocument = Rx<File?>(null);

  Future<void> pickVehicleImages() async {
    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 70,
    );

    if (images.isNotEmpty) {
      vehicleImages.clear();
      for (var image in images) {
        vehicleImages.add(File(image.path));
      }
      Get.snackbar(
        "Success",
        "${images.length} images selected",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> pickDocument(String docType) async {
    final source = await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(
          'Select $docType Source',
          style: const TextStyle(color: AppTheme.whiteText),
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
      switch (docType) {
        case 'RC':
          rcDocument.value = File(image.path);
          break;
        case 'Insurance':
          insuranceDocument.value = File(image.path);
          break;
        case 'Pollution':
          pollutionDocument.value = File(image.path);
          break;
        case 'Fitness':
          fitnessDocument.value = File(image.path);
          break;
        case 'Permit':
          permitDocument.value = File(image.path);
          break;
      }
      Get.snackbar(
        "Success",
        "$docType document selected",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void removeVehicleImage(int index) {
    vehicleImages.removeAt(index);
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

  Future<void> selectRegistrationDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryPurple,
              surface: AppTheme.cardColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      registrationDateController.text = picked.toString().split(' ')[0];
    }
  }

  Future<void> saveVehicle() async {
    // Validation
    if (modelController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter vehicle model",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    if (numberPlateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter number plate",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    if (registrationDateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select registration date",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    if (colorController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter vehicle color",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    if (seatingCapacityController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter seating capacity",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    if (hourlyRateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter hourly rate",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    if (dailyRateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter day rate",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    if (vehicleImages.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select at least one vehicle image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    final token = StorageService.getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        "Error",
        "Please login again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final result = await ApiService.addVehicle(
      token: token,
      model: modelController.text.trim(),
      numberPlate: numberPlateController.text.trim().toUpperCase(),
      type: selectedType.value,
      registrationDate: registrationDateController.text,
      color: colorController.text.trim(),
      seatingCapacity: seatingCapacityController.text.trim(),
      fuelType: selectedFuelType.value,
      hourlyRate: hourlyRateController.text.trim(),
      dailyRate: dailyRateController.text.trim(),
      images: vehicleImages,
      rc: rcDocument.value,
      insurance: insuranceDocument.value,
      pollution: pollutionDocument.value,
      fitness: fitnessDocument.value,
      permit: permitDocument.value,
    );

    isLoading.value = false;

    if (result['success']) {
      Get.back();
      Get.snackbar(
        "Success",
        "Vehicle added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      // Show error
      String errorMessage = 'Failed to add vehicle. Please try again.';
      
      if (result['data']['message'] != null) {
        errorMessage = result['data']['message'];
      } else if (result['data']['error'] != null) {
        errorMessage = result['data']['error'];
      } else if (result['data']['errors'] != null) {
        // Handle validation errors
        final errors = result['data']['errors'];
        if (errors is Map) {
          errorMessage = errors.values.first.toString();
        }
      }
      
      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void onClose() {
    modelController.dispose();
    numberPlateController.dispose();
    colorController.dispose();
    seatingCapacityController.dispose();
    registrationDateController.dispose();
    hourlyRateController.dispose();
    dailyRateController.dispose();
    super.onClose();
  }
}
