class TripHistoryModel {
  final int id;
  final String status;

  /// إجمالي أجرة الرحلة (ما يدفعه الزبون) — قيمة عشرية، نقرأها كـ double.
  /// مهم: final_fare يعود من السيرفر كنص "7100.00"، وكان int.tryParse يفشل → 0.
  final double finalFare;

  /// صافي أرباح السائق بعد عمولة الشركة (من الدفعة، إن وُجدت).
  final double driverEarning;

  final String pickupAddress;
  final String destinationAddress;
  final String completedAt;
  final int customerId;
  final String customerName;

  TripHistoryModel({
    required this.id,
    required this.status,
    required this.finalFare,
    required this.driverEarning,
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
    final payment = json['payment'] is Map
        ? Map<String, dynamic>.from(json['payment'] as Map)
        : {};

    return TripHistoryModel(
      id: _toInt(json['id']),
      status: (json['status'] ?? '').toString(),
      finalFare: _toDouble(json['final_fare'] ?? json['finalFare']),
      driverEarning: _toDouble(payment['driver_earning']),
      pickupAddress: (json['pickup_address'] ?? json['pickupAddress'] ?? '').toString(),
      destinationAddress: (json['destination_address'] ?? json['destinationAddress'] ?? '').toString(),
      completedAt: (json['completed_at'] ?? json['completedAt'] ?? '').toString(),
      customerId: _toInt(customer['id'] ?? json['customer_id'] ?? json['customerId']),
      customerName: (customer['name'] ?? json['customer_name'] ?? json['customerName'] ?? 'عميل').toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
    return 0;
  }

  // يتعامل مع الأرقام العشرية القادمة كنص ("7100.00") أو كرقم.
  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
