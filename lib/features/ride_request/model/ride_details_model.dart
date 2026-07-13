class RideDetailsModel {
  final int id;
  final String status;
  final double estimatedFare;
  final double distanceKm;
  final String pickupAddress;
  final String destinationAddress;
  final int customerId;
  final String customerName;
  final double ratingAverage;

  const RideDetailsModel({
    required this.id,
    required this.status,
    required this.estimatedFare,
    required this.distanceKm,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.customerId,
    required this.customerName,
    required this.ratingAverage,
  });

  factory RideDetailsModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] is Map
        ? Map<String, dynamic>.from(json['customer'] as Map)
        : null;

    return RideDetailsModel(
      id: _toInt(json['id'] ?? json['ride_id']),
      status: (json['status'] ?? '').toString(),
      estimatedFare: _toDouble(
        json['estimated_fare'] ?? json['estimatedFare'],
      ),
      distanceKm: _toDouble(json['distance_km'] ?? json['distanceKm']),
      pickupAddress: (json['pickup_address'] ?? json['pickupAddress'] ?? '').toString(),
      destinationAddress: (json['destination_address'] ?? json['destinationAddress'] ?? '').toString(),
      customerId: _toInt(customer?['id'] ?? json['customer_id'] ?? json['customerId']),
      customerName: (customer?['name'] ?? json['customer_name'] ?? json['customerName'] ?? 'عميل').toString(),
      ratingAverage: _toDouble(
        customer?['rating_average'] ??
            customer?['ratingAverage'] ??
            json['rating_average'] ??
            json['ratingAverage'],
      ),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }
}
