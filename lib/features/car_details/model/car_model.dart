// نموذج بيانات السيارة كما يرجعها السيرفر.
class CarModel {
  final String plateNumber;
  final String brand;
  final String model;
  final String manufacturingYear;
  final String color;
  final String carTypeName;

  CarModel({
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.manufacturingYear,
    required this.color,
    required this.carTypeName,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      plateNumber: json['plate_number']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      manufacturingYear: json['manufacturing_year']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      carTypeName: json['car_type']?['type_name']?.toString() ?? '',
    );
  }
}
