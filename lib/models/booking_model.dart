class Booking {
  final String id;
  final String customerName;
  final String customerImage;
  final String vehicleName;
  final String vehicleType;
  final String pickup;
  final String drop;
  final String duration;
  final int amount;
  final String status;
  final DateTime bookingDate;

  Booking({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.vehicleName,
    required this.vehicleType,
    required this.pickup,
    required this.drop,
    required this.duration,
    required this.amount,
    required this.status,
    required this.bookingDate,
  });
}
