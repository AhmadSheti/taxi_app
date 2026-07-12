import 'package:flutter/material.dart';
import 'constants.dart';
// استيراد شاشة اختيار السيارة للخطوة القادمة
// import 'car_selection_screen.dart';

class PickupConfirmationScreen extends StatefulWidget {
  final String selectedDestination;

  // تم تصحيح الـ Constructor هنا للاعتماد على الصياغة الحديثة لفلاتر
  const PickupConfirmationScreen({
    super.key,
    required this.selectedDestination,
  });

  @override
  State<PickupConfirmationScreen> createState() =>
      _PickupConfirmationScreenState();
}

class _PickupConfirmationScreenState extends State<PickupConfirmationScreen> {
  // موقع وهمي للانطلاق كما هو محدد في نبرة صوت الدليل
  final String _pickupAddress =
      'شارع المزة، أمام الهيئة العامة لمستشفى المواساة';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم اللغة العربية بالكامل
      child: Scaffold(
        body: Stack(
          children: [
            // 1. خلفية الخريطة (البديل البصري المؤقت لحين ربط الخرائط الفعلي)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFE4EEF1), // لون الخلفية الهادئة المائل للزرقة
              child: Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Icon(
                    Icons.map_outlined,
                    size: 120,
                    color: AppColors.primaryTeal.withOpacity(0.5),
                  ),
                ),
              ),
            ),

            // 2. زر العودة العلوي
            Positioned(
              top: 48,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.primaryTeal,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // 3. مؤشر تحديد الموقع الثابت في منتصف الشاشة (Map Pin)
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'انطلق من هنا',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.location_on_rounded,
                    size: 44,
                    color: AppColors.primaryTeal,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // لتعويض توازن السهم السفلي للمؤشر
                ],
              ),
            ),

            // 4. البطاقة السفلية لتأكيد الموقع
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // شريط صغير علوي للزينة يوحي بإمكانية السحب للأسفل
                    Center(
                      child: Container(
                        width: 40,
                        height: 40 / 10, // يماثل السمك 4 الذي وضعته
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'موقع الانطلاق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.my_location,
                          color: AppColors.primaryTeal,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _pickupAddress,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFE4EEF1)),
                    ),
                    // عرض سريع للوجهة التي اخترناها في الشاشة السابقة للتأكيد المرئي
                    Row(
                      children: [
                        const Icon(
                          Icons.flag_rounded,
                          color: AppColors.secondaryAmber,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'الوجهة المحددة: ${widget.selectedDestination}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // زر التأكيد الرئيسي باللون الذهبي
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          // هنا سنربط الانتقال إلى الشاشة (C) اختيار نوع السيارة لاحقاً
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم تأكيد الموقع بنجاح، جاري جلب سيارات مشوار المتاحة...',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryAmber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'تأكيد موقع الانطلاق',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
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