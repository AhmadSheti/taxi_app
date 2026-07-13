class DriverEarningsChartModel {
  final String date;
  final double earnings;
  final int ridesCount;

  DriverEarningsChartModel({
    required this.date,
    required this.earnings,
    required this.ridesCount,
  });

  factory DriverEarningsChartModel.fromJson(Map<String, dynamic> json) {
    return DriverEarningsChartModel(
      date: json['date']?.toString() ?? '',
      earnings: (json['earnings'] ?? 0).toDouble(),
      ridesCount: (json['rides_count'] ?? 0).toInt(),
    );
  }
}
