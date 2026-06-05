import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class BookingController extends GetxController {
  RxList<Booking> upcomingBookings = <Booking>[].obs;
  RxList<Booking> activeBookings = <Booking>[].obs;
  RxList<Booking> completedBookings = <Booking>[].obs;
  RxList<Booking> cancelledBookings = <Booking>[].obs;

  RxInt currentTabIndex = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final token = StorageService.getToken();

    if (token == null || token.isEmpty) {
      _clearBookings();
      Get.snackbar(
        "Error",
        "Please login again to view bookings",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    final result = await ApiService.getOwnerBookingRequests(token);

    isLoading.value = false;

    if (!result['success']) {
      _clearBookings();
      Get.snackbar(
        "Error",
        result['data']['message'] ?? "Unable to load bookings",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final responseData = result['data'];
    final bookingList = responseData['bookings'] is List
        ? responseData['bookings'] as List
        : <dynamic>[];
    final bookings = bookingList
        .whereType<Map>()
        .map((booking) => Booking.fromJson(Map<String, dynamic>.from(booking)))
        .toList();

    upcomingBookings.value = bookings
        .where((booking) => booking.status == 'Pending')
        .toList();
    activeBookings.value = bookings
        .where((booking) => booking.status == 'Active')
        .toList();
    completedBookings.value = bookings
        .where((booking) => booking.status == 'Completed')
        .toList();
    cancelledBookings.value = bookings
        .where((booking) => booking.status == 'Cancelled')
        .toList();
  }

  void _clearBookings() {
    upcomingBookings.clear();
    activeBookings.clear();
    completedBookings.clear();
    cancelledBookings.clear();
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void acceptBooking(String bookingId) {
    final booking = upcomingBookings.firstWhere((b) => b.id == bookingId);
    upcomingBookings.removeWhere((b) => b.id == bookingId);

    activeBookings.add(
      Booking(
        id: booking.id,
        customerName: booking.customerName,
        customerImage: booking.customerImage,
        vehicleName: booking.vehicleName,
        vehicleType: booking.vehicleType,
        pickup: booking.pickup,
        drop: booking.drop,
        duration: booking.duration,
        amount: booking.amount,
        status: 'Active',
        bookingDate: booking.bookingDate,
      ),
    );

    Get.snackbar(
      "Success",
      "Booking accepted successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rejectBooking(String bookingId) {
    final booking = upcomingBookings.firstWhere((b) => b.id == bookingId);
    upcomingBookings.removeWhere((b) => b.id == bookingId);

    cancelledBookings.add(
      Booking(
        id: booking.id,
        customerName: booking.customerName,
        customerImage: booking.customerImage,
        vehicleName: booking.vehicleName,
        vehicleType: booking.vehicleType,
        pickup: booking.pickup,
        drop: booking.drop,
        duration: booking.duration,
        amount: booking.amount,
        status: 'Cancelled',
        bookingDate: booking.bookingDate,
      ),
    );

    Get.snackbar(
      "Success",
      "Booking rejected",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void completeBooking(String bookingId) {
    final booking = activeBookings.firstWhere((b) => b.id == bookingId);
    activeBookings.removeWhere((b) => b.id == bookingId);

    completedBookings.add(
      Booking(
        id: booking.id,
        customerName: booking.customerName,
        customerImage: booking.customerImage,
        vehicleName: booking.vehicleName,
        vehicleType: booking.vehicleType,
        pickup: booking.pickup,
        drop: booking.drop,
        duration: booking.duration,
        amount: booking.amount,
        status: 'Completed',
        bookingDate: booking.bookingDate,
      ),
    );

    Get.snackbar(
      "Success",
      "Booking completed",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
