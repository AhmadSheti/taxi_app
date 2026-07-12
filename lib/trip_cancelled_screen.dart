import 'package:flutter/material.dart';
import 'constants.dart';

class TripCancelledScreen extends StatefulWidget {
  const TripCancelledScreen({Key? key}) : super(key: key);

  @override
  State<TripCancelledScreen> createState() => _TripCancelledScreenState();
}

class _TripCancelledScreenState extends State<TripCancelledScreen> {
  String? _selectedReason;

  final List<String> _cancelReasons = [
    'السائق متأخر عن الوقت المحدد',
    'عدم استجابة السائق للاتصالات',
    'غيرت وجهتي أو خطتي البديلة',
    'لقد استقليت سيارة أخرى بالفعل',
    'سبب آخر إضافي'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1),
                
                // أيقونة الإلغاء التحذيرية الحمراء
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE63946).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 40,
                      color: Color(0xFFE63946),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'تم إلغاء الرحلة بنجاح',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'نأسف جداً لحدوث ذلك الإلغاء. نرجو مساعدتنا بتحديد السبب بدقة لتحسين تجربتك القادمة مع مشوار.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Color(0xFF7A7A8C), height: 1.5),
                ),
                const SizedBox(height: 32),

                // قائمة أسباب إلغاء الرحلة المخصصة
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    children: _cancelReasons.map((reason) {
                      return RadioListTile<String>(
                        title: Text(
                          reason,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, color: Color(0xFF1A1A2E)),
                        ),
                        value: reason,
                        groupValue: _selectedReason,
                        activeColor: const Color(0xFF0F4C5C),
                        onChanged: (value) {
                          setState(() {
                            _selectedReason = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                
                const Spacer(flex: 2),

                // أزرار اتخاذ الإجراءات والتحكم
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4C5C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'اطلب مشوار جديد',
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'العودة للشاشة الرئيسية',
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}