class DriverEarningsSummaryModel {
  final String period;
  final double totalEarnings;
  final int ridesCount;
  final double totalDistanceKm;
  final double averagePerRide;
  final double commissionOwed;

  DriverEarningsSummaryModel({
    required this.period,
    required this.totalEarnings,
    required this.ridesCount,
    required this.totalDistanceKm,
    required this.averagePerRide,
    required this.commissionOwed,
  });

  factory DriverEarningsSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return DriverEarningsSummaryModel(
      period: data['period']?.toString() ?? '',
      totalEarnings: (data['total_earnings'] ?? 0).toDouble(),
      ridesCount: (data['rides_count'] ?? 0).toInt(),
      totalDistanceKm: (data['total_distance_km'] ?? 0).toDouble(),
      averagePerRide: (data['average_per_ride'] ?? 0).toDouble(),
      commissionOwed: (data['commission_owed'] ?? 0).toDouble(),
    );
  }
}
