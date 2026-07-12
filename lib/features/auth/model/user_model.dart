// نموذج المستخدم: يحوّل الـ JSON القادم من السيرفر إلى كائن Dart نتعامل معه بسهولة.
class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  // نبني الكائن من خريطة JSON (Map).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
    );
  }
}
