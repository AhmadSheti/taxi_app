import 'package:flutter/material.dart';
import 'constants.dart'; // استدعاء مباشر لأن الملفات كلها في مجلد lib

class EnRouteScreen extends StatelessWidget {
  const EnRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // 1. خلفية الخريطة التوضيحية
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE4EEF1), // خلفية هادئة تمثل الخريطة
            child: const Center(
              child: Icon(
                Icons.navigation_outlined,
                size: 80,
                color: Color(0xFF0F4C5C), // اللون الأساسي للمشروع
              ),
            ),
          ),

          // 2. زر العودة العلوي
          Positioned(
            top: 50,
            right: 20, // RTL يدعم اللغة العربية
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF1A1A2E)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. البطاقة السفلية - بيانات السائق والرحلة
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الوقت المتبقي لوصول السائق بنبرة صوت دقيقة وموجزة
                    const Center(
                      child: Text(
                        "٤ دقائق على وصول السائق",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F4C5C), // اللون الأساسي
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE4EEF1)),
                    const SizedBox(height: 16),

                    // صف بيانات السائق والسيارة
                    Row(
                      children: [
                        // صورة السائق (أيقونة مؤقتة دائرية كبنية أساسية)
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE4EEF1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Color(0xFF0F4C5C), size: 30),
                        ),
                        const SizedBox(width: 12),
                        
                        // اسم السائق وتقييمه
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "سامر الحميص",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFFFB627), size: 16), // اللون الذهبي للتقييم
                                  const SizedBox(width: 4),
                                  Text(
                                    "408 (125 رحلة)",
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      color: Color(0xFF7A7A8C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // تفاصيل السيارة ورقم اللوحة
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF7A7A8C).withOpacity(0.3)),
                              ),
                              child: const Text(
                                "دمشق · ٤٥٨٩٢١",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "سايبا · بيضاء",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: Color(0xFF7A7A8C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // أزرار التفاعل (اتصال - مراسلة - إلغاء)
                    Row(
                      children: [
                        // زر الاتصال هاتفياً
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFF0F4C5C)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.phone_in_talk_outlined, color: Color(0xFF0F4C5C), size: 20),
                            label: const Text(
                              "اتصال",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F4C5C),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // زر المراسلة (Chat) باللون الأساسي للتطبيق
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F4C5C),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                            label: const Text(
                              "مراسلة",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // زر إلغاء الرحلة الاحتياطي أسفل الشاشة باللون التحذيري المعتمد
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "إلغاء الرحلة",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE63946), // لون Danger
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}