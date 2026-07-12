// نموذج الإشعار: يطابق الحقول القادمة من السيرفر (Laravel).
class NotificationModel {
  final int id;
  final String type;
  final String title;
  final String body;
  final bool isRead; // مقروء أم لا (نحسبه من read_at)
  final String? createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      // إذا كان read_at غير فارغ فالإشعار مقروء.
      isRead: json['read_at'] != null,
      createdAt: json['created_at'],
    );
  }
}
