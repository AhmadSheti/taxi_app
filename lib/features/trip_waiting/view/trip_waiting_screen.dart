import 'package:flutter/material.dart';
import '../../../constants.dart'; // تأكد من تعديل المسار حسب اسم ملف الثوابت والألوان لديك

class TripWaitingScreen extends StatelessWidget {
  const TripWaitingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // الخلفية العامة الهادئة للمشروع
      body: Stack(
        children: [
          // 1. خلفية الخريطة (بنية مؤقتة حتى ربط الخرائط الفعلي)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE4EEF1), // لون هادئ يمثل منطقة الخريطة
            child: const Center(
              child: Icon(
                Icons.map_outlined,
                size: 80,
                color: Color(0xFF0F4C5C), // اللون الأساسي للمشروع
              ),
            ),
          ),

          // 2. زر العودة العلوي
          Positioned(
            top: 50,
            right: 20, // RTL اتجاه اليمين
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // 3. البطاقة السفلية - جاري البحث عن سائق
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
                  children: [
                    // مؤشر تحميل دائري يعبر عن البحث المستمر
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F4C5C)),
                        strokeWidth: 3.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // النص الأساسي - نبرة صوت دقيقة وموجزة
                    const Text(
                      "جاري البحث عن السائق...",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E), // نصوص رئيسية
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // نص فرعي توضيحي
                    const Text(
                      "يرجى الانتظار لحظات حتى يتم قبول طلبك وتعيين الكابتن الأقرب إليك.",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Color(0xFF7A7A8C), // نصوص ثانوية
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // زر إلغاء الطلب - بلون الحالات والتحذير المعتمد للمشروع
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE63946), // لون danger
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // منطق إلغاء الطلب والعودة للرئيسية
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "إلغاء الطلب",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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