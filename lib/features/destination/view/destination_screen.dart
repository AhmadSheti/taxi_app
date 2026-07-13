import 'package:flutter/material.dart';
import 'package:get/get.dart';
// تأكد من تعديل مسار استيراد ملف الألوان بحسب مشروعك
import '../../../constants.dart';
import '../controller/destination_controller.dart';

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

  late final DestinationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(DestinationController());
    _controller.loadSavedPlaces();
  }

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
                child: GetBuilder<DestinationController>(
                  builder: (controller) {
                    if (controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.savedPlaces.isEmpty) {
                      return const Center(
                        child: Text('لا توجد أماكن محفوظة حالياً'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: controller.savedPlaces.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: Color(0xFFE4EEF1)),
                      itemBuilder: (context, index) {
                        final place = controller.savedPlaces[index];

                        return ListTile(
                          onTap: () {
                            controller.selectPlace(place);
                            _destinationController.text = place.title;
                            setState(() {});
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE4EEF1),
                            child: Icon(
                              place.type == 'home'
                                  ? Icons.home_rounded
                                  : place.type == 'work'
                                  ? Icons.work_rounded
                                  : Icons.history,
                              color: AppColors.primaryTeal,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            place.title,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain,
                            ),
                          ),
                          subtitle: Text(
                            place.subtitle.isEmpty
                                ? 'مكان محفوظ'
                                : place.subtitle,
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
                        final selected = _controller.selectedPlace;
                        if (selected != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم اختيار الوجهة: ${_destinationController.text}\nالإحداثيات: ${selected.latitude}, ${selected.longitude}',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم اختيار الوجهة: ${_destinationController.text}',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
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
