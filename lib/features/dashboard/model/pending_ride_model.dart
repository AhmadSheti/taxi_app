class PendingRideModel {
  final int id;
  final String status;
  final double estimatedFare;
  final double distanceKm;
  final String pickupAddress;
  final String destinationAddress;
  final int customerId;
  final String customerName;
  final double ratingAverage;

  PendingRideModel({
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

  factory PendingRideModel.fromJson(Map<String, dynamic> json) {
    return PendingRideModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      estimatedFare: (json['estimated_fare'] ?? 0).toDouble(),
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      pickupAddress: json['pickup_address'] ?? '',
      destinationAddress: json['destination_address'] ?? '',
      customerId: json['customer']?['id'] ?? 0,
      customerName: json['customer']?['name'] ?? 'عميل',
      ratingAverage: (json['customer']?['rating_average'] ?? 0).toDouble(),
    );
  }
}
