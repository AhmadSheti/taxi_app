import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart'; // استدعاء ملف الثوابت والألوان مباشرة
import '../controller/trip_in_progress_controller.dart';

class TripInProgressScreen extends StatelessWidget {
  final int rideId;

  const TripInProgressScreen({Key? key, required this.rideId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripInProgressController(rideId: rideId));

    return Directionality(
      textDirection: TextDirection.rtl, // دعم الاتجاه العربي بالكامل
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: GetBuilder<TripInProgressController>(
          builder: (controller) {
            return Stack(
          children: [
            // 1. خريطة مسار الرحلة الحية الوهمية
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: Icon(
                  Icons.navigation,
                  size: 80,
                  color: AppColors.success,
                ),
              ),
            ),

            // 2. زر الطوارئ SOS العلوي المستمر لحماية الراكب
            Positioned(
              top: 50,
              left: 20,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // منطق الطوارئ والاتصال بالأمان
                },
                backgroundColor: AppColors.danger,
                icon: const Icon(Icons.warning, color: Colors.white),
                label: const Text(
                  "SOS",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // 3. بطاقة بيانات مسار الرحلة والعداد السفلية
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
                    
                    // عنوان الحالة العلوي والعداد المالي
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.statusLabel,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                            Text(
                              controller.driverEta,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        // العداد المالي الفوري المباشر
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "الأجرة حتى الآن",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                controller.fareText,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Divider(),
                    const SizedBox(height: 12),

                    // تفاصيل خط سير الرحلة (الانطلاق والوصول) والوقت
                    Row(
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.radio_button_checked, color: AppColors.primaryTeal, size: 20),
                            Container(width: 2, height: 30, color: Colors.grey[300]),
                            const Icon(Icons.location_on, color: AppColors.danger, size: 20),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.fromAddress.isNotEmpty
                                    ? controller.fromAddress
                                    : '09:42 · المزة، أمام مشفى الزهراء',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                controller.toAddress.isNotEmpty
                                    ? controller.toAddress
                                    : '~09:54 · المالكي، شارع 29 أيار',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMain,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // أزرار التفاعل والتواصل السريع مع السائق
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppColors.primaryTeal),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.phone, color: AppColors.primaryTeal),
                            label: const Text(
                              "اتصال",
                              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppColors.primaryTeal),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.chat, color: AppColors.primaryTeal),
                            label: const Text(
                              "مراسلة",
                              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                            ),
                          ),
                        ),
                      ],
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