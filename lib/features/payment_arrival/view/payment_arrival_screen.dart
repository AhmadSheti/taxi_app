import 'package:flutter/material.dart';
import '../../../constants.dart'; // استدعاء ملف الثوابت المباشر داخل الـ lib
import '../../rate_driver/view/rate_driver_screen.dart'; // للاستدعاء عند الانتقال لصفحة التقييم

class PaymentArrivalScreen extends StatelessWidget {
  const PaymentArrivalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'نهاية الرحلة',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // رسالة الوصول الترحيبية الودودة
              const Text(
                'وصلت بسلامة! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F4C5C),
                ),
              ),
              const Text(
                'نتمنى لك يوماً سعيداً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Color(0xFF7A7A8C),
                ),
              ),
              const SizedBox(height: 24),

              // بطاقة تفاصيل السائق والمركبة
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: const Color(0xFFE4EEF1),),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF0F4C5C).withOpacity(0.1),
                      child: const Text(
                        'س',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F4C5C),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'سامر الحميص',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            'كيا سيراتو · فضي',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Color(0xFF7A7A8C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'DAM 4128',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ملخص الرحلة والمسافة
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    _buildTripInfoRow('المسافة الفعلية', '4.2 كم'),
                    const Divider(height: 20),
                    _buildTripInfoRow('المدة الزمنية', '14 دقيقة'),
                    const Divider(height: 20),
                    _buildTripInfoRow('متوسط السرعة', '18 كم/س'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // بطاقة الفاتورة وتفاصيل الأجرة بالأرقام المطلوبة (123)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: ListView(
                    children: [
                      const Text(
                        'تفاصيل الأجرة المالية',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInvoiceRow('الأجرة الأساسية', '2000 ل.س'),
                      _buildInvoiceRow('المسافة (4.2 كم × 500)', '2100 ل.س'),
                      _buildInvoiceRow('وقت الانتظار', '100 ل.س'),
                      _buildInvoiceRow('خصم MISHWAR10', '-420 ل.س', isDiscount: true),
                      const Divider(height: 24, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'المجموع النهائي',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF0F4C5C),
                            ),
                          ),
                          Text(
                            '3780 ل.س',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Color(0xFF0F4C5C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // أزرار التحكم والاتخاذ للإجراء السفلي
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RateDriverScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4C5C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'تقييم السائق',
                  style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text(
                  'إرسال إيصال على البريد الإلكتروني',
                  style: TextStyle(fontFamily: 'Cairo', color: Color(0xFF0F4C5C), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripInfoRow(String title, String value) {
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFF7A7A8C))),
        Text(value, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
      ],
    );
  }

  Widget _buildInvoiceRow(String title, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Color(0xFF7A7A8C))),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? const Color(0xFFE63946) : const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}