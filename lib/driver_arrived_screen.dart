import 'package:flutter/material.dart';
import 'constants.dart'; // استدعاء ملف الثوابت والألوان مباشرة
import 'trip_in_progress_screen.dart';

class DriverArrivedScreen extends StatelessWidget {
  const DriverArrivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الاتجاه العربي بالكامل
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // 1. خريطة خلفية وهمية
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: Icon(
                  Icons.map,
                  size: 80,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
            
            // 2. بطاقة البيانات السفلية
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // شريط سحب علوي صغير
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // عنوان الحالة الرئيسي
                    const Text(
                      "السائق وصل!",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "ابحث عن السيارة برقم اللوحة أدناه",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // رسائل التواصل السريعة المكتوبة مسبقاً من السائق
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.secondaryAmber.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, color: AppColors.secondaryAmber),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "رسالة من السائق: \"وصلت ولا أستطيع رؤيتك\"",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // بطاقة بيانات السيارة ولوحة الترخيص المتميزة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
                              child: const Icon(Icons.directions_car, color: AppColors.primaryTeal, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "سامر - كيا سيراتو",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Icon(Icons.star, color: AppColors.secondaryAmber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      "4.9",
                                      style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "فضية",
                                      style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // رقم اللوحة المصمم كبطاقة ترخيص مرورية
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.textMain, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: const [
                              Text(
                                "DAM 4128",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                "دمشق",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // زر الانتقال إلى الشاشة التالية (لمحاكاة تقدم الرحلة برمجياً)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryAmber,
                          foregroundColor: AppColors.textMain,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  TripInProgressScreen()),
                          );
                        },
                        child: const Text(
                          "بدء الرحلة (محاكاة)",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}