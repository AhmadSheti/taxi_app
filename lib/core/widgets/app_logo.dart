import 'package:flutter/material.dart';

/// شعار «مشوار» — صورة واحدة تُستخدم في كل الشاشات التي تحتاج شعاراً
/// (Splash / Login / Register). لتغيير الشعار: استبدل
/// assets/images/logo.jpeg فقط.
class AppLogo extends StatelessWidget {
  final double size;
  final bool circular;

  const AppLogo({super.key, this.size = 96, this.circular = true});

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/logo.jpeg',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );

    if (!circular) return image;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: image,
    );
  }
}
