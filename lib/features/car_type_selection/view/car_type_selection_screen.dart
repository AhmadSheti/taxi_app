import 'package:flutter/material.dart';
import 'package:get/get.dart';
// تأكد من تغيير المسار حسب اسم مجلد الثوابت لديك لملف الألوان
import '../../../constants.dart';
import '../controller/car_type_selection_controller.dart';

class CarTypeSelectionScreen extends StatefulWidget {
  const CarTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<CarTypeSelectionScreen> createState() => _CarTypeSelectionScreenState();
}

class _CarTypeSelectionScreenState extends State<CarTypeSelectionScreen> {
  late final CarTypeSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(CarTypeSelectionController());
    _controller.loadCarTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم اللغة العربية بالكامل
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Stack(
          children: [
            // 1. خلفية الخريطة ومسار الرحلة (مؤقتة لحين ربط الخرائط الفعلي)
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              color: const Color(0xFFE4EEF1),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'خريطة مسار الرحلة الحالية 🗺️',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: Color(0xFF0F4C5C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // زر العودة الخلفي فوق الخريطة
                  Positioned(
                    top: 50,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF1A1A2E),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. اللوحة السفلية واختيار الفئات
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.55,
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
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // خط صغير علوي للزينة وسحب القائمة
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        'اختر نوع السيارة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // قائمة السيارات المتاحة
                      Expanded(
                        child: GetBuilder<CarTypeSelectionController>(
                          builder: (controller) {
                            if (controller.isLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (controller.carTypes.isEmpty) {
                              return const Center(child: Text('لا توجد فئات سيارات حالياً'));
                            }

                            return ListView.builder(
                              itemCount: controller.carTypes.length,
                              itemBuilder: (context, index) {
                                final car = controller.carTypes[index];
                                final isSelected = controller.selectedCarTypeId == car.id;

                                return GestureDetector(
                                  onTap: () {
                                    controller.selectCarType(car.id);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFF1F7F8)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF0F4C5C)
                                            : Colors.grey[200]!,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFF0F4C5C)
                                                : Colors.grey[100],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.directions_car_filled_outlined,
                                            size: 32,
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF0F4C5C),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                car.typeName,
                                                style: const TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1A1A2E),
                                                ),
                                              ),
                                              Text(
                                                'المقاعد: ${car.seats ?? 4}',
                                                style: const TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                  color: Color(0xFF7A7A8C),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${car.baseFare} ل.س',
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F4C5C),
                                              ),
                                            ),
                                            Text(
                                              'لكل كم ${car.pricePerKm} ل.س',
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 12,
                                                color: Color(0xFF2EC4B6),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // 3. شريط اختيار طريقة الدفع
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.money, color: Color(0xFF2EC4B6)),
                                SizedBox(width: 10),
                                Text(
                                  'نقداً (كاش)',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'تغيير الفواتير',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: Color(0xFF0F4C5C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 4. زر تأكيد فئة السيارة والانتقال
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: GetBuilder<CarTypeSelectionController>(
                          builder: (controller) => ElevatedButton(
                            onPressed: controller.isEstimating
                                ? null
                                : () async {
                                    await controller.estimateFare(
                                      pickupLatitude: 33.5138,
                                      pickupLongitude: 36.2765,
                                      destinationLatitude: 33.5301,
                                      destinationLongitude: 36.2921,
                                      discountCode: 'MISHWAR10',
                                    );

                                    if (controller.fareEstimate != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'السعر التقديري: ${controller.fareEstimate!.totalFare} ل.س',
                                            style: const TextStyle(fontFamily: 'Cairo'),
                                          ),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFB627,
                            ), // اللون الثانوي CTA الذهبي
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isEstimating
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text(
                                  'تأكيد فئة السيارة الطلب',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A2E),
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
      ),
    );
  }
}
