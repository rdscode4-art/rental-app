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
  RxBool isLoadingRequests = false.obs;

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

  RxList<Map<String, dynamic>> recentBookings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadRecentBookingRequests();
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

      if (data['address'] != null) {
        final address = data['address'];
        location.value =
            '${address['city'] ?? 'Goa'}, ${address['state'] ?? 'India'}';
      }

      totalVehicles.value = data['totalVehicles'] ?? 0;
      activeBookings.value = data['totalBookings'] ?? 0;
    } else {
      vendorName.value = 'User';
    }
  }

  Future<void> loadRecentBookingRequests() async {
    final token = StorageService.getToken();

    if (token == null || token.isEmpty) {
      recentBookings.clear();
      return;
    }

    isLoadingRequests.value = true;

    final result = await ApiService.getOwnerBookingRequests(token);

    isLoadingRequests.value = false;

    if (!result['success']) {
      recentBookings.clear();
      return;
    }

    final responseData = result['data'];
    final bookingList = responseData['bookings'] is List
        ? responseData['bookings'] as List
        : <dynamic>[];
    final bookings = bookingList
        .whereType<Map>()
        .map((booking) => Map<String, dynamic>.from(booking))
        .where(
          (booking) => booking['status']?.toString().toLowerCase() == 'pending',
        )
        .map(_bookingRequestToMap)
        .take(3)
        .toList();

    recentBookings.value = bookings;
  }

  Map<String, dynamic> _bookingRequestToMap(Map<String, dynamic> booking) {
    final vehicle = _asMap(booking['vehicleId']);
    final rider = _asMap(booking['riderId']);
    final customerName = rider['name']?.toString().trim();

    return {
      'id': booking['_id']?.toString() ?? booking['id']?.toString() ?? '',
      'customerName': customerName?.isNotEmpty == true
          ? customerName
          : 'Customer',
      'customerImage': _customerInitial(customerName),
      'vehicle': vehicle['model']?.toString() ?? 'Vehicle',
      'pickup': _formatBookingPeriod(booking),
      'drop': '',
      'duration': _formatDuration(booking),
      'amount': _asInt(booking['estimatedFare']),
      'date': _formatCreatedAt(booking['createdAt']?.toString()),
      'status': booking['status']?.toString() ?? 'pending',
    };
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _customerInitial(String? name) {
    final trimmedName = name?.trim() ?? '';
    return trimmedName.isEmpty ? 'C' : trimmedName[0].toUpperCase();
  }

  String _formatDuration(Map<String, dynamic> booking) {
    final bookingType = booking['bookingType']?.toString().toLowerCase();
    final totalDays = booking['totalDays'];
    final totalHours = booking['totalHours'];

    if (bookingType == 'daily' && totalDays != null) {
      return '$totalDays ${totalDays == 1 ? 'Day' : 'Days'}';
    }

    if (totalHours != null) {
      return '$totalHours ${totalHours == 1 ? 'Hour' : 'Hours'}';
    }

    return bookingType == null || bookingType.isEmpty ? '' : bookingType;
  }

  String _formatBookingPeriod(Map<String, dynamic> booking) {
    final startDate = DateTime.tryParse(booking['startDate']?.toString() ?? '');
    final endDate = DateTime.tryParse(booking['endDate']?.toString() ?? '');

    if (startDate == null) return 'Pickup date not available';
    if (endDate == null) return 'Starts ${_formatDate(startDate)}';

    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  String _formatCreatedAt(String? value) {
    final date = DateTime.tryParse(value ?? '');
    if (date == null) return '';
    return _formatDate(date);
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
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
    loadRecentBookingRequests();
    Get.snackbar(
      "Refreshed",
      "Dashboard data updated",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
