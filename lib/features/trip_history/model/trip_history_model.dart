class TripHistoryModel {
  final int id;
  final String status;
  final int finalFare;
  final String pickupAddress;
  final String destinationAddress;
  final String completedAt;
  final int customerId;
  final String customerName;

  TripHistoryModel({
    required this.id,
    required this.status,
    required this.finalFare,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.completedAt,
    required this.customerId,
    required this.customerName,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] is Map
        ? Map<String, dynamic>.from(json['customer'] as Map)
        : {};
    return TripHistoryModel(
      id: _toInt(json['id']),
      status: (json['status'] ?? '').toString(),
      finalFare: _toInt(json['final_fare'] ?? json['finalFare']),
      pickupAddress: (json['pickup_address'] ?? json['pickupAddress'] ?? '').toString(),
      destinationAddress: (json['destination_address'] ?? json['destinationAddress'] ?? '').toString(),
      completedAt: (json['completed_at'] ?? json['completedAt'] ?? '').toString(),
      customerId: _toInt(customer['id'] ?? json['customer_id'] ?? json['customerId']),
      customerName: (customer['name'] ?? json['customer_name'] ?? json['customerName'] ?? 'عميل').toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
