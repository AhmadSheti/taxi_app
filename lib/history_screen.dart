import 'package:flutter/material.dart';
import 'constants.dart'; // استدعاء ملف الثوابت والألوان الموحد لمشروع مشوار

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // التبويب الافتراضي المحدد عند فتح الشاشة
  String _selectedTab = 'الكل';

  // قائمة التبويبات المتوفرة لتصفية الرحلات حسب كتاب التصميم
  final List<String> _tabs = ['الكل', 'اليوم', 'مكتملة', 'ملغاة'];

  // بيانات وهمية للرحلات السابقة متوافقة مع الهوية البصرية والترميز الرقمي القياسي (1234)
  final List<Map<String, dynamic>> _trips = [
    {
      'driverName': 'سامر الحميص',
      'carInfo': 'كيا سيراتو - 123456',
      'date': '10 يوليو 2026',
      'time': '14:30',
      'pickup': 'المزة - الشيخ سعد',
      'destination': 'ساحة الأمويين',
      'price': '15000 ل.س',
      'status': 'مكتملة', // الحالات: مكتملة أو ملغاة
      'isToday': true,
    },
    {
      'driverName': 'أحمد العلي',
      'carInfo': 'هيونداي أفانتي - 987654',
      'date': '10 يوليو 2026',
      'time': '09:15',
      'pickup': 'مشروع دمر - الجزيرة 2',
      'destination': 'باب توما',
      'price': '22000 ل.س',
      'status': 'ملغاة',
      'isToday': true,
    },
    {
      'driverName': 'خالد المصري',
      'carInfo': 'تويوتا كورولا - 456123',
      'date': '08 يوليو 2026',
      'time': '18:00',
      'pickup': 'كفرسوسة - اللوان',
      'destination': 'جرمانا - الساحة',
      'price': '18500 ل.س',
      'status': 'مكتملة',
      'isToday': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // تصفية القائمة بناءً على التبويب النشط
    List<Map<String, dynamic>> filteredTrips = _trips.where((trip) {
      if (_selectedTab == 'اليوم') return trip['isToday'] == true;
      if (_selectedTab == 'مكتملة') return trip['status'] == 'مكتملة';
      if (_selectedTab == 'ملغاة') return trip['status'] == 'ملغاة';
      return true; // في حال تبويب 'الكل'
    }).toList();

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
        body: Column(
          children: [
            // 1. شريط التبويبات العلوي للتصفية (Tabs)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _tabs.map((tab) {
                  final bool isSelected = _selectedTab == tab;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = tab;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryTeal : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(color: const Color(0xFFE4EEF1), width: 1),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            // 2. قائمة بطاقات الرحلات السابقة
            Expanded(
              child: filteredTrips.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 64, color: AppColors.textSecondary.withOpacity(0.4)),
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
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredTrips.length,
                      itemBuilder: (context, index) {
                        final trip = filteredTrips[index];
                        final bool isCompleted = trip['status'] == 'مكتملة';

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
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ترويسة البطاقة: اسم السائق والحالة المالية
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
                                          child: const Icon(Icons.person, color: AppColors.primaryTeal),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              trip['driverName'],
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.textMain,
                                              ),
                                            ),
                                            Text(
                                              trip['carInfo'],
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
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.success.withOpacity(0.1)
                                            : AppColors.danger.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        trip['status'],
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: isCompleted ? AppColors.success : AppColors.danger,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: Color(0xFFE4EEF1), height: 1),
                                ),
                                // مسار الرحلة (الانطلاق والوصول)
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.circle, size: 12, color: AppColors.primaryTeal),
                                        Container(width: 2, height: 24, color: const Color(0xFFE4EEF1)),
                                        const Icon(Icons.location_on, size: 14, color: AppColors.secondaryAmber),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trip['pickup'],
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
                                            trip['destination'],
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
                                  child: Divider(color: Color(0xFFE4EEF1), height: 1),
                                ),
                                // تذييل البطاقة: الوقت والتكلفة المادية للرحلة
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${trip['date']} - ${trip['time']}',
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
                                        trip['price'],
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
        ),
      ),
    );
  }
}