import 'package:flutter/material.dart';

class AppColors {
  // 1. الألوان البصرية الرئيسية للهوية (Brand Colors)
  static const Color primaryTeal = Color(
    0xFF0F4C5C,
  ); // اللون الأساسي: فيروزي داكن يعبر عن الثقة والأمان
  static const Color secondaryAmber = Color(
    0xFFFFB627,
  ); // اللون الثانوي: ذهبي/أصفر لأزرار التفاعل (CTAs)

  static const Color primaryDark = Color(
    0xFF0F4C5C,
  ); // لون داكن متوافق مع الهوية للمكالمات والأسطح الداكنة

  static const Color accentYellow = Color(
    0xFFFFB627,
  ); // لون نبرة منبه مع هوية العلامة

  static const Color textGrey = Color(0xFF7A7A8C); // لون نصوص الوصف الثانوية

  static const Color textDark = Color(0xFF1A1A2E); // لون نصوص العناوين الداكنة

  static const Color cardBackground = Color(
    0xFFFFFFFF,
  ); // لون خلفية البطاقات البيضاء

  // 2. ألوان الحالات والمؤشرات (Status Colors)
  static const Color success = Color(
    0xFF2EC4B6,
  ); // إيجابي: للرحلات المكتملة بنجاح
  static const Color danger = Color(
    0xFFE63946,
  ); // تحذيري: لحالات الإلغاء والأخطاء والطوارئ

  // 3. ألوان الواجهة والنصوص (Interface & Typography)
  static const Color textMain = Color(
    0xFF1A1A2E,
  ); // نصوص رئيسية (Ink): للعناوين العريضة والداكنة
  static const Color textSecondary = Color(
    0xFF7A7A8C,
  ); // نصوص ثانوية (Ink 3): للأوصاف الفرعية والتواريخ
  static const Color background = Color(
    0xFFF8F9FA,
  ); // الخلفية العامة الهادئة للشاشات
  static const Color cardWhite = Color(
    0xFFFFFFFF,
  ); // للبطاقات (Cards) والأسطح البيضاء العائمة
  static const Color nightMode = Color(
    0xFF0A0E1A,
  ); // اللون المخصص للوضع الليلي مستقبلاً
}

class AppStyles {
  // حالياً سنترك نوع الخط فارغاً ليعمل بالخط الافتراضي العادي، وفي نهاية المشروع نغيره لـ 'Cairo' بكلمة واحدة هنا أو في main.dart
  static const String? fontFamily = null;

  // نمط العناوين الكبيرة والعريضة في التطبيق
  static const TextStyle headingBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w900, // عريض جداً ومميز
    color: AppColors.textMain,
  );

  // نمط النصوص العادية والأوصاف الفرعية
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5, // يعطي مساحة أسطر مريحة جداً للقراءة
  );

  // نمط النصوص المكتوبة داخل الأزرار الرئيسية
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors
        .textMain, // النص داخل الأزرار الذهبية يكون داكناً لسهولة القراءة
  );
}
