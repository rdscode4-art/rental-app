import 'package:get/get.dart';
import '../models/vehicle_model.dart';

class VehicleController extends GetxController {
  RxList<Vehicle> vehicles = <Vehicle>[].obs;
  RxString selectedFilter = 'All'.obs;
  RxBool isLoading = false.obs;

  final List<String> filters = ['All', 'Scooty', 'Bike', 'Car'];

  @override
  void onInit() {
    super.onInit();
    loadVehicles();
  }

  void loadVehicles() {
    vehicles.value = [
      Vehicle(
        id: '1',
        name: 'Honda Activa 6G',
        type: 'Scooty',
        numberPlate: 'GA 01 AB 1234',
        pricePerHour: 149,
        pricePerDay: 799,
        rating: 4.8,
        isAvailable: true,
        imageUrl: 'https://via.placeholder.com/300x200/8B5CF6/FFFFFF?text=Honda+Activa',
      ),
      Vehicle(
        id: '2',
        name: 'Royal Enfield Classic 350',
        type: 'Bike',
        numberPlate: 'GA 02 CD 5678',
        pricePerHour: 299,
        pricePerDay: 1499,
        rating: 4.9,
        isAvailable: true,
        imageUrl: 'https://via.placeholder.com/300x200/6366F1/FFFFFF?text=Royal+Enfield',
      ),
      Vehicle(
        id: '3',
        name: 'Hyundai Creta',
        type: 'Car',
        numberPlate: 'GA 03 EF 9012',
        pricePerHour: 599,
        pricePerDay: 2999,
        rating: 4.7,
        isAvailable: true,
        imageUrl: 'https://via.placeholder.com/300x200/EC4899/FFFFFF?text=Hyundai+Creta',
      ),
      Vehicle(
        id: '4',
        name: 'TVS Jupiter',
        type: 'Scooty',
        numberPlate: 'GA 04 GH 3456',
        pricePerHour: 139,
        pricePerDay: 749,
        rating: 4.6,
        isAvailable: false,
        imageUrl: 'https://via.placeholder.com/300x200/8B5CF6/FFFFFF?text=TVS+Jupiter',
      ),
      Vehicle(
        id: '5',
        name: 'KTM Duke 390',
        type: 'Bike',
        numberPlate: 'GA 05 IJ 7890',
        pricePerHour: 399,
        pricePerDay: 1999,
        rating: 4.9,
        isAvailable: true,
        imageUrl: 'https://via.placeholder.com/300x200/6366F1/FFFFFF?text=KTM+Duke',
      ),
      Vehicle(
        id: '6',
        name: 'Maruti Swift',
        type: 'Car',
        numberPlate: 'GA 06 KL 2345',
        pricePerHour: 499,
        pricePerDay: 2499,
        rating: 4.8,
        isAvailable: true,
        imageUrl: 'https://via.placeholder.com/300x200/EC4899/FFFFFF?text=Maruti+Swift',
      ),
    ];
  }

  List<Vehicle> get filteredVehicles {
    if (selectedFilter.value == 'All') {
      return vehicles;
    }
    return vehicles.where((v) => v.type == selectedFilter.value).toList();
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
      );
    }
  }

  void deleteVehicle(String vehicleId) {
    vehicles.removeWhere((v) => v.id == vehicleId);
    Get.snackbar(
      "Success",
      "Vehicle deleted successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void addVehicle(Vehicle vehicle) {
    vehicles.add(vehicle);
    Get.snackbar(
      "Success",
      "Vehicle added successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
