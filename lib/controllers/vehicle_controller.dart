import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';

class VehicleController extends GetxController {
  RxList<Vehicle> vehicles = <Vehicle>[].obs;
  RxString selectedFilter = 'All'.obs;
  RxBool isLoading = false.obs;

  final List<String> filters = [
    'All',
    'Bike',
    'Car',
    'SUV',
    'Sedan',
    'EV',
    'Auto',
    'HMV',
    'Non-Vehicle',
  ];

  @override
  void onInit() {
    super.onInit();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    isLoading.value = true;

    final token = StorageService.getToken();

    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Please login again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
      return;
    }

    final result = await ApiService.getVehicles(token);

    isLoading.value = false;

    if (result['success']) {
      final vehiclesData = _extractVehicles(result['data']);

      print('✅ Found ${vehiclesData.length} vehicles');

      // Convert to Vehicle objects
      vehicles.value = vehiclesData.map((json) {
        return Vehicle(
          id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
          name: json['model']?.toString() ?? 'Unknown Vehicle',
          type: _capitalizeFirst(json['type']?.toString() ?? 'Car'),
          numberPlate: json['numberPlate']?.toString() ?? '',
          pricePerHour: _parseInt(
            json['pricing']?['hourlyRate'] ?? json['hourlyRate'],
          ),
          pricePerDay: _parseInt(
            json['pricing']?['dailyRate'] ?? json['dailyRate'],
          ),
          rating: 0.0, // API doesn't have this field
          isAvailable: json['isAvailable'] ?? json['available'] ?? true,
          imageUrl: _getImageUrl(
            json['images'] ?? json['image'] ?? json['imageUrl'],
          ),
        );
      }).toList();

      print('✅ Loaded ${vehicles.length} vehicles successfully');
    } else {
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Failed to load vehicles",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
    }
  }

  String _getImageUrl(dynamic images) {
    if (images == null) return '';

    String imagePath = '';

    if (images is List && images.isNotEmpty) {
      final firstImage = images[0];
      if (firstImage is Map) {
        imagePath =
            firstImage['url']?.toString() ??
            firstImage['path']?.toString() ??
            firstImage['image']?.toString() ??
            '';
      } else {
        imagePath = firstImage.toString();
      }
    } else if (images is Map) {
      imagePath =
          images['url']?.toString() ??
          images['path']?.toString() ??
          images['image']?.toString() ??
          '';
    } else if (images is String) {
      imagePath = images;
    }

    // Convert relative path to full URL
    if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      return 'https://backend.ridealmobility.com$imagePath';
    }

    return imagePath;
  }

  List<dynamic> _extractVehicles(dynamic data) {
    if (data is List) return data;
    if (data is! Map) return [];

    final vehicles = data['vehicles'];
    if (vehicles is List) return vehicles;

    final nestedData = data['data'];
    if (nestedData is List) return nestedData;
    if (nestedData is Map && nestedData['vehicles'] is List) {
      return nestedData['vehicles'] as List;
    }

    final result = data['result'];
    if (result is List) return result;
    if (result is Map && result['vehicles'] is List) {
      return result['vehicles'] as List;
    }

    return [];
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value.toString()) ?? 0;
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  List<Vehicle> get filteredVehicles {
    if (selectedFilter.value == 'All') {
      return vehicles;
    }
    return vehicles
        .where(
          (v) => v.type.toLowerCase() == selectedFilter.value.toLowerCase(),
        )
        .toList();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void toggleAvailability(String vehicleId) {
    final index = vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      final vehicle = vehicles[index];
      vehicles[index] = Vehicle(
        id: vehicle.id,
        name: vehicle.name,
        type: vehicle.type,
        numberPlate: vehicle.numberPlate,
        pricePerHour: vehicle.pricePerHour,
        pricePerDay: vehicle.pricePerDay,
        rating: vehicle.rating,
        isAvailable: !vehicle.isAvailable,
        imageUrl: vehicle.imageUrl,
      );
      vehicles.refresh();
      Get.snackbar(
        "Success",
        "Vehicle availability updated",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
      );
    }
  }

  void deleteVehicle(String vehicleId) {
    vehicles.removeWhere((v) => v.id == vehicleId);
    Get.snackbar(
      "Success",
      "Vehicle deleted successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.successGreen,
      colorText: Colors.white,
    );
  }

  Future<void> refreshVehicles() async {
    await loadVehicles();
  }
}
