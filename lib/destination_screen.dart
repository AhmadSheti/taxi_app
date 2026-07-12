import 'package:flutter/material.dart';
// تأكد من تعديل مسار استيراد ملف الألوان بحسب مشروعك
import 'constants.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({Key? key}) : super(key: key);
 

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final TextEditingController _pickupController = TextEditingController(
    text: 'موقعي الحالي (شارع المزة، دمشق)',
  );
  final TextEditingController _destinationController = TextEditingController();

  // قائمة وهمية للأماكن المفضلة والمقترحة بحسب دليل الأسلوب
  final List<Map<String, String>> _suggestedPlaces = [
    {'title': 'المنزل', 'subtitle': 'مشروع دمر، الجزر الثامنة', 'icon': 'home'},
    {'title': 'العمل', 'subtitle': 'تنظيم كفرسوسة، برج الشام', 'icon': 'work'},
    {
      'title': 'جامعة دمشق',
      'subtitle': 'البرامكة، كلية الهندسة المعلوماتية',
      'icon': 'history',
    },
    {
      'title': 'بوابة الصالحية',
      'subtitle': 'وسط المدينة، دمشق',
      'icon': 'history',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // يدعم اللغة العربية بالكامل RTL
      child: Scaffold(
        backgroundColor: const Color(
          0xFFF8F9FA,
        ), // الخلفية العامة الهادئة للتطبيق
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryTeal),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'حدد وجهتك',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 1. لوحة إدخال المواقع العلوية
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // المؤشر البصري الجانبي (الخط التنقيطي المذكور في الدليل)
                    Column(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 12,
                          color: AppColors.primaryTeal,
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.secondaryAmber,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // حقول الإدخال
                    Expanded(
                      child: Column(
                        children: [
                          // حقل نقطة الانطلاق (موقعك الحالي)
                          TextField(
                            controller: _pickupController,
                            readOnly: true, // يظهر تلقائياً للمستخدم
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: AppColors.textMain,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              fillColor: const Color(
                                0xFFE4EEF1,
                              ).withOpacity(0.4),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // حقل البحث عن الوجهة
                          TextField(
                            controller: _destinationController,
                            autofocus: true,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: AppColors.textMain,
                            ),
                            decoration: InputDecoration(
                              hintText: 'إلى أين تريد الذهاب؟',
                              hintStyle: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              fillColor: Colors.grey.withOpacity(0.05),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryTeal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 2. قائمة المواقع المقترحة والمفضلة
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _suggestedPlaces.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Color(0xFFE4EEF1)),
                  itemBuilder: (context, index) {
                    final place = _suggestedPlaces[index];
                    IconData iconData = Icons.history;
                    if (place['icon'] == 'home') iconData = Icons.home_rounded;
                    if (place['icon'] == 'work') iconData = Icons.work_rounded;

                    return ListTile(
                      onTap: () {
                        setState(() {
                          _destinationController.text = place['title']!;
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFE4EEF1),
                        child: Icon(
                          iconData,
                          color: AppColors.primaryTeal,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        place['title']!,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      subtitle: Text(
                        place['subtitle']!,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),

              // 3. زر التأكيد السفلي للانتقال للخطوة التالية
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_destinationController.text.isNotEmpty) {
                        // هنا سنربط الانتقال إلى الشاشة (B) تأكيد نقطة الانطلاق لاحقاً
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم اختيار الوجهة: ${_destinationController.text}، جاري الانتقال لتأكيد الانطلاق...',
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'الرجاء اختيار أو كتابة وجهة أولاً',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.secondaryAmber, // اللون الذهبي للـ CTAs
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'تأكيد الوجهة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
