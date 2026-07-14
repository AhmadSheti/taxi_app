/// سائق متاح كما يعود من الـ backend (مع سيارته ونوعها ومسافته).
class DriverModel {
  final int id;
  final String name;
  final double ratingAverage;
  final int ratingCount;
  final double? distanceKm;
  final String? plateNumber;
  final String? carModel;
  final String? carColor;
  final String? carTypeName;

  DriverModel({
    required this.id,
    required this.name,
    required this.ratingAverage,
    required this.ratingCount,
    this.distanceKm,
    this.plateNumber,
    this.carModel,
    this.carColor,
    this.carTypeName,
  });

  factory DriverModel.fromJson(Map<String, dynamic> j) {
    final car = j['car'] as Map<String, dynamic>?;
    final carType = car?['car_type'] as Map<String, dynamic>?;
    return DriverModel(
      id: j['id'] ?? 0,
      name: j['name'] ?? '',
      ratingAverage: double.tryParse('${j['rating_average']}') ?? 0,
      ratingCount: j['rating_count'] ?? 0,
      distanceKm:
          j['distance_km'] == null ? null : double.tryParse('${j['distance_km']}'),
      plateNumber: car?['plate_number'],
      carModel: car?['model'],
      carColor: car?['color'],
      carTypeName: carType?['type_name'],
    );
  }

  // أول حرف من الاسم — للأفاتار الدائري.
  String get initial => name.isNotEmpty ? name.substring(0, 1) : '؟';
}
