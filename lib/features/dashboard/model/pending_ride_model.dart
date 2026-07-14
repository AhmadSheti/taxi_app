class PendingRideModel {
  final int id;
  final String status;
  final double estimatedFare;
  final double distanceKm;
  final String pickupAddress;
  final String destinationAddress;
  final double pickupLat;
  final double pickupLng;
  final double destinationLat;
  final double destinationLng;
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
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.customerId,
    required this.customerName,
    required this.ratingAverage,
  });

  static double _d(dynamic v) =>
      v is num ? v.toDouble() : double.tryParse('$v') ?? 0.0;

  factory PendingRideModel.fromJson(Map<String, dynamic> json) {
    return PendingRideModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      estimatedFare: _d(json['estimated_fare']),
      distanceKm: _d(json['distance_km']),
      pickupAddress: json['pickup_address'] ?? '',
      destinationAddress: json['destination_address'] ?? '',
      pickupLat: _d(json['pickup_latitude']),
      pickupLng: _d(json['pickup_longitude']),
      destinationLat: _d(json['destination_latitude']),
      destinationLng: _d(json['destination_longitude']),
      customerId: json['customer']?['id'] ?? 0,
      customerName: json['customer']?['name'] ?? 'عميل',
      ratingAverage: _d(json['customer']?['rating_average']),
    );
  }
}
