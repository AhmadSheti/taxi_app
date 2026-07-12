import 'package:flutter/material.dart';

/// كل ألوان تطبيق السائق في مكان واحد.
/// أي شاشة تحتاج لوناً، تستورد هذا الملف وتستخدم AppColors.xxx
/// (بدل تعريف الألوان داخل كل صفحة).
class AppColors {
  // الألوان الرئيسية للهوية
  static const Color primary = Color(0xFF0D3E46);   // زيتي غامق (اللون الأساسي)
  static const Color accent = Color(0xFFFBC02D);    // أصفر خردلي (الأزرار)

  // ألوان الواجهة
  static const Color background = Color(0xFFF7F9FA);       // خلفية الشاشات
  static const Color cardWhite = Color(0xFFFFFFFF);        // البطاقات البيضاء
  static const Color unreadBackground = Color(0xFFFFFDF6); // خلفية الإشعار غير المقروء

  // ألوان النصوص
  static const Color textMain = Color(0xFF0D3E46);   // نصوص رئيسية
  static const Color textGrey = Color(0xFF757575);   // نصوص ثانوية / رمادية

  // ألوان الحالات
  static const Color danger = Color(0xFFE63946);     // أخطاء / إلغاء
}
