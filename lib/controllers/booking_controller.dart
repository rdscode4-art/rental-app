import 'package:get/get.dart';
import '../models/booking_model.dart';

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

  void loadBookings() {
    upcomingBookings.value = [
      Booking(
        id: '1',
        customerName: 'Rahul Sharma',
        customerImage: 'https://via.placeholder.com/100',
        vehicleName: 'Hyundai Creta',
        vehicleType: 'Car',
        pickup: 'Baga Beach',
        drop: 'Panjim',
        duration: '8 Hours',
        amount: 2499,
        status: 'Pending',
        bookingDate: DateTime.now().add(const Duration(days: 1)),
      ),
      Booking(
        id: '2',
        customerName: 'Priya Patel',
        customerImage: 'https://via.placeholder.com/100',
        vehicleName: 'Royal Enfield Classic 350',
        vehicleType: 'Bike',
        pickup: 'Calangute',
        drop: 'Anjuna',
        duration: '4 Hours',
        amount: 1196,
        status: 'Pending',
        bookingDate: DateTime.now().add(const Duration(hours: 6)),
      ),
    ];

    activeBookings.value = [
      Booking(
        id: '3',
        customerName: 'Amit Kumar',
        customerImage: 'https://via.placeholder.com/100',
        vehicleName: 'Honda Activa 6G',
        vehicleType: 'Scooty',
        pickup: 'Candolim',
        drop: 'Candolim',
        duration: '1 Day',
        amount: 799,
        status: 'Active',
        bookingDate: DateTime.now(),
      ),
      Booking(
        id: '4',
        customerName: 'Sneha Reddy',
        customerImage: 'https://via.placeholder.com/100',
        vehicleName: 'Maruti Swift',
        vehicleType: 'Car',
        pickup: 'Panjim',
        drop: 'Panjim',
        duration: '2 Days',
        amount: 4998,
        status: 'Active',
        bookingDate: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];

    completedBookings.value = [
      Booking(
        id: '5',
        customerName: 'Vikram Singh',
        customerImage: 'https://via.placeholder.com/100',
        vehicleName: 'KTM Duke 390',
        vehicleType: 'Bike',
        pickup: 'Mapusa',
        drop: 'Mapusa',
        duration: '6 Hours',
        amount: 2394,
        status: 'Completed',
        bookingDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    cancelledBookings.value = [
      Booking(
        id: '6',
        customerName: 'Neha Gupta',
        customerImage: 'https://via.placeholder.com/100',
        vehicleName: 'TVS Jupiter',
        vehicleType: 'Scooty',
        pickup: 'Margao',
        drop: 'Colva',
        duration: '3 Hours',
        amount: 417,
        status: 'Cancelled',
        bookingDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void acceptBooking(String bookingId) {
    final booking = upcomingBookings.firstWhere((b) => b.id == bookingId);
    upcomingBookings.removeWhere((b) => b.id == bookingId);
    
    activeBookings.add(Booking(
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
    ));

    Get.snackbar(
      "Success",
      "Booking accepted successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rejectBooking(String bookingId) {
    final booking = upcomingBookings.firstWhere((b) => b.id == bookingId);
    upcomingBookings.removeWhere((b) => b.id == bookingId);
    
    cancelledBookings.add(Booking(
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
    ));

    Get.snackbar(
      "Success",
      "Booking rejected",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void completeBooking(String bookingId) {
    final booking = activeBookings.firstWhere((b) => b.id == bookingId);
    activeBookings.removeWhere((b) => b.id == bookingId);
    
    completedBookings.add(Booking(
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
    ));

    Get.snackbar(
      "Success",
      "Booking completed",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
