import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ride_request/controller/ride_request_controller.dart';
import '../../waiting_customer/view/waiting_customer_screen.dart';

class ActiveTripScreen extends StatelessWidget {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF00B4A0); // التيركواز الأساسي
    const Color orangeColor = Color(
      0xFFFFB822,
    ); // الأصفر / الذهبي للأزرار والتقييم
    const Color lightGrey = Color(0xFFF1F3F6); // خلفية الرمادي الفاتح للتذكير

    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية الخريطة (شكل مؤقت للخريطة بالخلفية)
          Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.map, size: 100, color: Colors.grey),
            ),
          ),

          // 2.شريط الملاحة العلوي
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: tealColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 6),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // وقت الوصول المتوقع يساراً
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'الوصول',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          '٤ د',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // نص التوجيه يميناً مع أيقونة الملاحة
                    Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              'متّجه إلى العميل',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'اتجه يميناً بعد ٢٠٠ متر',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.navigation_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. زر الطوارئ SOS العائم على اليمين فوق البطاقة
          Positioned(
            bottom: 270,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('تنبيه طوارئ'),
                    content: const Text(
                      'هل أنت متأكد أنك تريد إرسال نداء استغاثة؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          // هنا في المستقبل سيتم ربط كود السيرفر
                          Navigator.pop(context);
                        },
                        child: const Text('نعم، إرسال'),
                      ),
                    ],
                  ),
                );
              },

              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.red, width: 1.5),
              ),
              child: const Text(
                'SOS',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // 4. البطاقة البيضاء السفلية (بيانات العميل والتحكم)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // خط السحب العلوي الصغير
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // بيانات العميل (الصورة، الاسم، التقييم، أزرار التواصل)
                  Row(
                    children: [
                      // أزرار الاتصال والرسائل يساراً
                      Row(
                        children: [
                          _buildCircleButton(Icons.chat_bubble, tealColor),
                          const SizedBox(width: 8),
                          _buildCircleButton(Icons.phone, tealColor),
                        ],
                      ),
                      const Spacer(),
                      // اسم وتقييم العميل يميناً
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.star, color: orangeColor, size: 14),
                              SizedBox(width: 4),
                              Text(
                                '٤.٨',
                                style: TextStyle(
                                  color: orangeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'أحمد العلي',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            '١.٢ كم . شارع بغداد، مقابل الصيدلية',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // الصورة الشخصية الدائرية مع الحرف الأول
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: tealColor,
                        child: Text(
                          'أ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // صندوق التذكير الأصفر الفاتح بنوع السيارة ورقمها
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'DAM 7752',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              'تذكير: يبحث العميل عن السيارة',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.assignment_turned_in_outlined,
                              size: 16,
                              color: orangeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ), // زر الأكشن الكبير "وصلت إلى موقع العميل" باللون الأصفر الذهبي
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () async {
                        final controller = Get.find<RideRequestController>();
                        await controller.markArrived(501);
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WaitingCustomerScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'وصلت إلى موقع العميل . ٥٠ م',
                        style: TextStyle(
                          color: Colors.black,
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
    );
  }

  // ويدجت لبناء أزرار الاتصال الدائرية الصغيرة يساراً بسهولة
  Widget _buildCircleButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
