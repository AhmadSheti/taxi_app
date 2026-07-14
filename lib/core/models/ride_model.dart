/// رحلة كما تعود من الـ backend (تُستخدم في التتبّع، السجلّ، الملخّص).
class RideModel {
  final int id;
  final String status;
  final double estimatedFare;
  final double? finalFare;
  final String? pickupAddress;
  final String? destinationAddress;
  final double? distanceKm;
  final int? durationMinutes;
  final String? createdAt;

  // بيانات السائق (إن وُجدت)
  final int? driverId;
  final String? driverName;
  final double? driverRating;
  final String? plateNumber;
  final String? carModel;

  RideModel({
    required this.id,
    required this.status,
    required this.estimatedFare,
    this.finalFare,
    this.pickupAddress,
    this.destinationAddress,
    this.distanceKm,
    this.durationMinutes,
    this.createdAt,
    this.driverId,
    this.driverName,
    this.driverRating,
    this.plateNumber,
    this.carModel,
  });

  factory RideModel.fromJson(Map<String, dynamic> j) {
    final driver = j['driver'] as Map<String, dynamic>?;
    // السيارة قد تأتي داخل السائق أو على مستوى الرحلة نفسها.
    final car = (driver?['car'] ?? j['car']) as Map<String, dynamic>?;
    return RideModel(
      id: j['id'] ?? 0,
      status: j['status'] ?? '',
      estimatedFare: double.tryParse('${j['estimated_fare']}') ?? 0,
      finalFare:
          j['final_fare'] == null ? null : double.tryParse('${j['final_fare']}'),
      pickupAddress: j['pickup_address'],
      destinationAddress: j['destination_address'],
      distanceKm:
          j['distance_km'] == null ? null : double.tryParse('${j['distance_km']}'),
      durationMinutes: j['duration_minutes'],
      createdAt: j['completed_at'] ?? j['requested_at'] ?? j['created_at'],
      driverId: driver?['id'] ?? j['driver_id'],
      driverName: driver?['name'],
      driverRating: driver?['rating_average'] == null
          ? null
          : double.tryParse('${driver?['rating_average']}'),
      plateNumber: car?['plate_number'],
      carModel: car?['model'],
    );
  }

  // ─── مساعدات الحالة ───
  bool get isPending => status == 'pending';
  bool get isActive => ['pending', 'accepted', 'driver_arrived', 'in_progress'].contains(status);
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled' || status == 'rejected';

  // النص العربي للحالة (يُعرض في شاشة التتبّع والسجلّ).
  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'جاري البحث عن سائق...';
      case 'accepted':
        return 'السائق في الطريق إليك';
      case 'driver_arrived':
        return 'وصل السائق';
      case 'in_progress':
        return 'الرحلة جارية';
      case 'completed':
        return 'اكتملت الرحلة';
      case 'cancelled':
        return 'ملغاة';
      case 'rejected':
        return 'رُفضت';
      default:
        return status;
    }
  }
}
