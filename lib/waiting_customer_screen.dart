import 'dart:async';
import 'package:flutter/material.dart';
import 'live_trip_screen.dart';

class WaitingCustomerScreen extends StatefulWidget {
  const WaitingCustomerScreen({super.key});

  @override
  State<WaitingCustomerScreen> createState() => _WaitingCustomerScreenState();
}

class _WaitingCustomerScreenState extends State<WaitingCustomerScreen> {
  // عداد تصاعدي لوقت الانتظار (بدءاً من دقيقة و24 ثانية متل الصورة)
  int _totalSeconds = 84;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startWaitingTimer();
  }

  void _startWaitingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // دالة لتنسيق الوقت بشكل (دقائق:ثواني)
  String _formatDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF00B4A0); // التيركواز الأساسي
    const Color orangeColor = Color(0xFFFFB822); // الأصفر للانتظار
    const Color lightGrey = Color(0xFFF1F3F6);

    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية الخريطة
          Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.map, size: 100, color: Colors.grey),
            ),
          ),

          // 2. شريط حالة الانتظار العلوي (الأصفر)
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
                  color: orangeColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 6),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // كرت الإشعار الصغير (مجاني حتى ٣:٠٠)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'مجاني حتى ٣:٠٠',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // العداد والنص يميناً
                    Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'بانتظار العميل',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '${_formatDuration(_totalSeconds)} من الانتظار',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.access_time_filled,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ), // 3. البطاقة البيضاء السفلية (بيانات العميل وبدء الرحلة)
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
                  // خط السحب العلوي
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // صف معلومات العميل المبسطة مع زر الاتصال
                  Row(
                    children: [
                      // زر اتصال دائري يساراً
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: tealColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: tealColor,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      // تفاصيل العميل يميناً
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'أحمد العلي',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: const [
                              Text(
                                'سورلندي قميصاً أبيض',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.star, color: orangeColor, size: 14),
                              Text(
                                '٤.٨',
                                style: TextStyle(
                                  color: orangeColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
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
                  const SizedBox(height: 25),

                  // زر "بدء الرحلة" التيركواز الكبير الفخم
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _timer?.cancel();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiveTripScreen(),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: tealColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        'بدء الرحلة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15), // خيار إلغاء الرحلة تحت
                  TextButton(
                    onPressed: () {
                      _timer?.cancel();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('إلغاء الرحلة'),
                          content: const Text(
                            'هل أنت متأكد أنك تريد إلغاء الرحلة لعدم حضور العميل؟',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('رجوع'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                // 3. هنا سيتم الانتقال للرئيسية بعد الإلغاء
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (route) => false,
                                );
                              },
                              child: const Text('تأكيد الإلغاء'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'إلغاء الرحلة . لم يأتِ العميل',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
}
