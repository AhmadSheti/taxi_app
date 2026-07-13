import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart'; // استدعاء ملف الثوابت والألوان الموحد لمشروع مشوار
import '../controller/history_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(HistoryController());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الاتجاه العربي RTL
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'رحلاتي',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textMain,
            ),
          ),
          centerTitle: true,
        ),
        body: GetBuilder<HistoryController>(
          builder: (controller) {
            return Column(
              children: [
                // 1. شريط التبويبات العلوي للتصفية (Tabs)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.tabs.map((tabData) {
                      final tab = tabData['label']!;
                      final bool isSelected = controller.selectedTab == tab;
                      return GestureDetector(
                        onTap: () {
                          controller.setSelectedTab(tab);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryTeal
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: const Color(0xFFE4EEF1),
                                    width: 1,
                                  ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),

                if (controller.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (controller.hasError)
                  Expanded(
                    child: Center(
                      child: Text(
                        controller.errorMessage,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                else if (controller.visibleTrips.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: AppColors.textSecondary.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد رحلات في هذا القسم حالياً',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: controller.visibleTrips.length,
                      itemBuilder: (context, index) {
                        final trip = controller.visibleTrips[index];
                        final bool isCompleted = trip['status'] == 'completed';
                        final driver = trip['driver'];
                        final driverName = driver is Map
                            ? driver['name']?.toString() ?? ''
                            : '';
                        final driverRating = driver is Map
                            ? driver['rating_average']?.toString() ?? ''
                            : '';
                        final pickup = trip['pickup_address']?.toString() ?? '';
                        final destination =
                            trip['destination_address']?.toString() ?? '';
                        final date = trip['completed_at']?.toString() ?? '';
                        final fare = trip['final_fare']?.toString() ?? '';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ترويسة البطاقة: اسم السائق والحالة المالية
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors.primaryTeal
                                              .withOpacity(0.1),
                                          child: const Icon(
                                            Icons.person,
                                            color: AppColors.primaryTeal,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              driverName,
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.textMain,
                                              ),
                                            ),
                                            Text(
                                              driverRating.isNotEmpty
                                                  ? 'تقييم السائق: $driverRating'
                                                  : '',
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // شارة حالة الرحلة (مكتملة باللون الأخضر / ملغاة باللون الأحمر)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.success.withOpacity(0.1)
                                            : AppColors.danger.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isCompleted ? 'مكتملة' : 'ملغاة',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: isCompleted
                                              ? AppColors.success
                                              : AppColors.danger,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    color: Color(0xFFE4EEF1),
                                    height: 1,
                                  ),
                                ),
                                // مسار الرحلة (الانطلاق والوصول)
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: AppColors.primaryTeal,
                                        ),
                                        Container(
                                          width: 2,
                                          height: 24,
                                          color: const Color(0xFFE4EEF1),
                                        ),
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: AppColors.secondaryAmber,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pickup,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 13,
                                              color: AppColors.textMain,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            destination,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 13,
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    color: Color(0xFFE4EEF1),
                                    height: 1,
                                  ),
                                ),
                                // تذييل البطاقة: الوقت والتكلفة المادية للرحلة
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          date,
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isCompleted)
                                      Text(
                                        fare.isNotEmpty ? '$fare ل.س' : '-',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
