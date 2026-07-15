class RideDetailsModel {
  final int id;
  final String status;
  final double estimatedFare;

  /// إجمالي أجرة الرحلة النهائية (ما يدفعه الزبون) — يُضبط عند اكتمال الرحلة.
  final double finalFare;

  /// تفاصيل الدفعة (من علاقة payment): صافي أرباح السائق، العمولة، ونسبتها.
  final double driverEarning;
  final double commissionAmount;
  final double commissionPercentage;

  /// المبلغ الفعلي الواجب تحصيله من الزبون (بعد الخصم) + قيمة الخصم.
  final double amountDue;
  final double discountAmount;

  /// تسعيرة نوع السيارة — نستخدمها لحساب "الأجرة حتى الآن" بنفس معادلة السيرفر
  /// (base_fare + المسافة × price_per_km).
  final double baseFare;
  final double pricePerKm;

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

  const RideDetailsModel({
    required this.id,
    required this.status,
    required this.estimatedFare,
    this.finalFare = 0,
    this.driverEarning = 0,
    this.commissionAmount = 0,
    this.commissionPercentage = 0,
    this.amountDue = 0,
    this.discountAmount = 0,
    this.baseFare = 0,
    this.pricePerKm = 0,
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

  // الأجرة المعتمدة للعرض: النهائية إن وُجدت، وإلا التقديرية.
  double get displayFare => finalFare > 0 ? finalFare : estimatedFare;

  factory RideDetailsModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] is Map
        ? Map<String, dynamic>.from(json['customer'] as Map)
        : null;
    final payment = json['payment'] is Map
        ? Map<String, dynamic>.from(json['payment'] as Map)
        : null;

    // نوع السيارة قد يأتي مباشرة (car_type) أو داخل السيارة (car.car_type).
    final car = json['car'] is Map ? Map<String, dynamic>.from(json['car'] as Map) : null;
    final rawCarType = json['car_type'] ?? car?['car_type'];
    final carType = rawCarType is Map
        ? Map<String, dynamic>.from(rawCarType as Map)
        : null;

    return RideDetailsModel(
      id: _toInt(json['id'] ?? json['ride_id']),
      status: (json['status'] ?? '').toString(),
      estimatedFare: _toDouble(
        json['estimated_fare'] ?? json['estimatedFare'],
      ),
      finalFare: _toDouble(json['final_fare'] ?? json['finalFare']),
      driverEarning: _toDouble(payment?['driver_earning']),
      commissionAmount: _toDouble(payment?['commission_amount']),
      commissionPercentage: _toDouble(payment?['commission_percentage']),
      amountDue: _toDouble(payment?['amount']),
      discountAmount: _toDouble(payment?['discount_amount']),
      baseFare: _toDouble(carType?['base_fare']),
      pricePerKm: _toDouble(carType?['price_per_km']),
      distanceKm: _toDouble(json['distance_km'] ?? json['distanceKm']),
      pickupAddress: (json['pickup_address'] ?? json['pickupAddress'] ?? '').toString(),
      destinationAddress: (json['destination_address'] ?? json['destinationAddress'] ?? '').toString(),
      pickupLat: _toDouble(json['pickup_latitude'] ?? json['pickupLat']),
      pickupLng: _toDouble(json['pickup_longitude'] ?? json['pickupLng']),
      destinationLat: _toDouble(json['destination_latitude'] ?? json['destinationLat']),
      destinationLng: _toDouble(json['destination_longitude'] ?? json['destinationLng']),
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
    // الـ backend يُرجع الأرقام العشرية (decimal) كنصوص مثل "33.5138000".
    return double.tryParse('$value') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }
}
