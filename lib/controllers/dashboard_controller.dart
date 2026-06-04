import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class DashboardController extends GetxController {
  RxString vendorName = 'Loading...'.obs;
  RxString location = 'Goa, India'.obs;
  
  RxInt totalVehicles = 0.obs;
  RxInt activeBookings = 0.obs;
  RxInt todayEarnings = 0.obs;
  RxInt monthlyRevenue = 0.obs;
  RxInt weeklyEarnings = 0.obs;

  // Revenue chart data (Last 7 days)
  final List<double> revenueData = [
    8000,
    12000,
    10000,
    15000,
    13000,
    17000,
    18000,
  ];

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Recent Booking Requests
  RxList<Map<String, dynamic>> recentBookings = <Map<String, dynamic>>[
    {
      'id': '1',
      'customerName': 'Rahul Sharma',
      'customerImage': '👨',
      'vehicle': 'Hyundai Creta',
      'pickup': 'Baga Beach',
      'drop': 'Panjim',
      'duration': '8 Hours',
      'amount': 2499,
      'date': 'Today, 2:30 PM',
      'status': 'pending',
    },
    {
      'id': '2',
      'customerName': 'Priya Patel',
      'customerImage': '👩',
      'vehicle': 'Royal Enfield Classic',
      'pickup': 'Calangute',
      'drop': 'Anjuna',
      'duration': '4 Hours',
      'amount': 1199,
      'date': 'Today, 3:15 PM',
      'status': 'pending',
    },
    {
      'id': '3',
      'customerName': 'Amit Kumar',
      'customerImage': '👨‍💼',
      'vehicle': 'Honda Activa 6G',
      'pickup': 'Candolim',
      'drop': 'Mapusa',
      'duration': '6 Hours',
      'amount': 899,
      'date': 'Today, 4:00 PM',
      'status': 'pending',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final token = StorageService.getToken();
    
    if (token == null || token.isEmpty) {
      vendorName.value = 'Guest';
      return;
    }

    final result = await ApiService.getProfile(token);

    if (result['success']) {
      Map<String, dynamic> data = {};
      
      if (result['data']['data'] != null) {
        data = result['data']['data'];
      } else if (result['data']['owner'] != null) {
        data = result['data']['owner'];
      } else if (result['data']['user'] != null) {
        data = result['data']['user'];
      } else {
        data = result['data'];
      }
      
      vendorName.value = data['name']?.toString() ?? 'User';
      
      // Update location from address
      if (data['address'] != null) {
        final address = data['address'];
        location.value = '${address['city'] ?? 'Goa'}, ${address['state'] ?? 'India'}';
      }
      
      // Update stats if available
      totalVehicles.value = data['totalVehicles'] ?? 0;
      activeBookings.value = data['totalBookings'] ?? 0;
      
      print('✅ Dashboard profile loaded: ${vendorName.value}');
    } else {
      vendorName.value = 'User';
    }
  }

  void acceptBooking(String bookingId) {
    final index = recentBookings.indexWhere((b) => b['id'] == bookingId);
    if (index != -1) {
      recentBookings[index]['status'] = 'accepted';
      recentBookings.refresh();
      Get.snackbar(
        "Booking Accepted",
        "You have accepted the booking request",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
      );
    }
  }

  void rejectBooking(String bookingId) {
    final index = recentBookings.indexWhere((b) => b['id'] == bookingId);
    if (index != -1) {
      recentBookings.removeAt(index);
      Get.snackbar(
        "Booking Rejected",
        "You have rejected the booking request",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
      );
    }
  }

  void refreshDashboard() {
    loadUserProfile();
    Get.snackbar(
      "Refreshed",
      "Dashboard data updated",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
