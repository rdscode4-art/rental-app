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

  factory Booking.fromJson(Map<String, dynamic> json) {
    final vehicle = _asMap(json['vehicleId']);
    final rider = _asMap(json['riderId']);
    final status = _formatStatus(json['status']?.toString() ?? 'pending');

    return Booking(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      customerName: rider['name']?.toString().trim().isNotEmpty == true
          ? rider['name'].toString()
          : 'Customer',
      customerImage: rider['profilePhoto']?.toString() ?? '',
      vehicleName: vehicle['model']?.toString().trim().isNotEmpty == true
          ? vehicle['model'].toString()
          : 'Vehicle',
      vehicleType: vehicle['type']?.toString() ?? '',
      pickup: _formatBookingPeriod(json),
      drop: '',
      duration: _formatDuration(json),
      amount: _asInt(json['estimatedFare']),
      status: status,
      bookingDate:
          DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
      case 'active':
      case 'ongoing':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'cancelled':
      case 'canceled':
      case 'rejected':
        return 'Cancelled';
      default:
        return status.isEmpty
            ? 'Pending'
            : '${status[0].toUpperCase()}${status.substring(1)}';
    }
  }

  static String _formatDuration(Map<String, dynamic> json) {
    final bookingType = json['bookingType']?.toString().toLowerCase();
    final totalDays = json['totalDays'];
    final totalHours = json['totalHours'];

    if (bookingType == 'daily' && totalDays != null) {
      return '$totalDays ${totalDays == 1 ? 'Day' : 'Days'}';
    }

    if (totalHours != null) {
      return '$totalHours ${totalHours == 1 ? 'Hour' : 'Hours'}';
    }

    return bookingType == null || bookingType.isEmpty ? '' : bookingType;
  }

  static String _formatBookingPeriod(Map<String, dynamic> json) {
    final startDate = DateTime.tryParse(json['startDate']?.toString() ?? '');
    final endDate = DateTime.tryParse(json['endDate']?.toString() ?? '');

    if (startDate == null) return 'Pickup date not available';
    if (endDate == null) return 'Starts ${_formatDate(startDate)}';

    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  static String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }
}
