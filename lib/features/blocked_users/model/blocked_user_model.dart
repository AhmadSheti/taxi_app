// نموذج المستخدم المحظور — يمثّل عنصراً واحداً من قائمة المحظورين.
class BlockedUserModel {
  final int customerId;
  final String name;
  final String? reason;
  final String? blockedAt;

  BlockedUserModel({
    required this.customerId,
    required this.name,
    this.reason,
    this.blockedAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    // السيرفر يُعيد بيانات الزبون داخل كائن "blocked"، ومعرّفه في "blocked_id".
    final blocked = json['blocked'] is Map
        ? Map<String, dynamic>.from(json['blocked'] as Map)
        : const <String, dynamic>{};
    return BlockedUserModel(
      customerId:
          _toInt(blocked['id'] ?? json['blocked_id'] ?? json['customer_id']),
      name: (blocked['name'] ?? json['name'] ?? 'عميل').toString(),
      reason: json['reason']?.toString(),
      blockedAt: (json['created_at'] ?? json['blocked_at'])?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
