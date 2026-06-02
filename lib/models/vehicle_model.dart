class Vehicle {
  final String id;
  final String name;
  final String type;
  final String numberPlate;
  final int pricePerHour;
  final int pricePerDay;
  final double rating;
  final bool isAvailable;
  final String imageUrl;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.numberPlate,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.rating,
    required this.isAvailable,
    required this.imageUrl,
  });
}
