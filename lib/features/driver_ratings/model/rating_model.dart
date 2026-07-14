/// نموذج تقييم فردي واحد من العميل للسائق.
class RatingModel {
  final int id;
  final int score;
  final String? comment;
  final String customerName;
  final String createdAt;

  RatingModel({
    required this.id,
    required this.score,
    required this.comment,
    required this.customerName,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: _toInt(json['id']),
      score: _toInt(json['score']),
      comment: json['comment']?.toString(),
      customerName:
          (json['customer_name'] ?? json['customerName'] ?? 'عميل').toString(),
      createdAt: (json['created_at'] ?? json['createdAt'] ?? '').toString(),
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

/// نموذج ملخّص التقييمات (المتوسط، العدد الكلي، توزيع النجوم).
class RatingsSummaryModel {
  final double average;
  final int totalCount;

  /// توزيع عدد التقييمات لكل نجمة: المفتاح رقم النجمة (1..5) والقيمة العدد.
  final Map<int, int> distribution;

  RatingsSummaryModel({
    required this.average,
    required this.totalCount,
    required this.distribution,
  });

  factory RatingsSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawDist = json['distribution'];
    final Map<int, int> dist = {};
    if (rawDist is Map) {
      rawDist.forEach((key, value) {
        final star = int.tryParse(key.toString());
        if (star != null) {
          dist[star] = _toInt(value);
        }
      });
    }
    return RatingsSummaryModel(
      average: _toDouble(json['average']),
      totalCount: _toInt(json['total_count'] ?? json['totalCount']),
      distribution: dist,
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

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
