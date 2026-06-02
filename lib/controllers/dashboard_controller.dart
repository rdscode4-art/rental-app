import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class DashboardController extends GetxController {
  RxString vendorName = 'Alex Morgan'.obs;
  RxString location = 'Goa, India'.obs;
  RxString greeting = 'Good Morning 👋'.obs;
  
  RxInt totalVehicles = 12.obs;
  RxInt activeBookings = 8.obs;
  RxInt todayEarnings = 12450.obs;
  RxInt monthlyRevenue = 124000.obs;
  RxInt weeklyEarnings = 68000.obs;

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
    updateGreeting();
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning 👋';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon 👋';
    } else {
      greeting.value = 'Good Evening 👋';
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
    // Simulate data refresh
    Get.snackbar(
      "Refreshed",
      "Dashboard data updated",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
