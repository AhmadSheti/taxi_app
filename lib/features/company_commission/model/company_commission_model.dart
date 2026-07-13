class CompanyCommissionModel {
  final int totalOwed;
  final int ridesCount;
  final bool warning;

  CompanyCommissionModel({
    required this.totalOwed,
    required this.ridesCount,
    required this.warning,
  });

  factory CompanyCommissionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? Map<String, dynamic>.from(json['data']) : <String, dynamic>{};
    return CompanyCommissionModel(
      totalOwed: _toInt(data['total_owed'] ?? data['totalOwed']),
      ridesCount: _toInt(data['rides_count'] ?? data['ridesCount']),
      warning: data['warning'] == true || data['warning']?.toString().toLowerCase() == 'true',
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
