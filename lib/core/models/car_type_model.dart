/// نوع السيارة (اقتصادي / مريح / فاخر) كما يعود من الـ backend.
class CarTypeModel {
  final int id;
  final String typeName;
  final double baseFare;
  final double pricePerKm;
  final String? description;

  CarTypeModel({
    required this.id,
    required this.typeName,
    required this.baseFare,
    required this.pricePerKm,
    this.description,
  });

  factory CarTypeModel.fromJson(Map<String, dynamic> j) {
    return CarTypeModel(
      id: j['id'] ?? 0,
      typeName: j['type_name'] ?? '',
      baseFare: double.tryParse('${j['base_fare']}') ?? 0,
      pricePerKm: double.tryParse('${j['price_per_km']}') ?? 0,
      description: j['description'],
    );
  }

  // الاسم العربي المعروض في الواجهة.
  String get arabicName {
    switch (typeName) {
      case 'Economy':
        return 'اقتصادي';
      case 'Comfort':
        return 'مريح';
      case 'Luxury':
        return 'فاخر';
      default:
        return typeName;
    }
  }
}
