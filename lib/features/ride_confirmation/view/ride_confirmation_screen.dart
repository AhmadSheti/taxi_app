import 'package:flutter/material.dart';

import '../../../constants.dart';

class RideConfirmationScreen extends StatelessWidget {
  const RideConfirmationScreen({Key? key}) : super(key: key);

  // ألوان الهوية البصرية الرسمية لتطبيق "مشوار"
  final Color primaryTeal = const Color(0xFF0F4C5C);
  final Color secondaryAmber = const Color(0xFFFFB627);
  final Color successGreen = const Color(0xFF2EC4B6);
  final Color textMain = const Color(0xFF1A1A2E);
  final Color textSecondary = const Color(0xFF7A7A8C);
  final Color backgroundLight = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم كامل للغة العربية والاتجاه RTL
      child: Scaffold(
        backgroundColor: backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textMain, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'مراجعة وتأكيد الرحلة',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: textMain,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. بطاقة ملخص السائق المختار
              _buildSectionTitle('السائق المختار'),
              const SizedBox(height: 8),
              _buildDriverSummaryCard(),
              const SizedBox(height: 20),

              // 2. إشعار كود الخصم الأخضر (MISHWAR10)
              _buildPromoCodeAlert(),
              const SizedBox(height: 20),

              // 3. تفاصيل الفاتورة والأجرة
              _buildSectionTitle('تفاصيل الأجرة'),
              const SizedBox(height: 8),
              _buildInvoiceCard(),
              const SizedBox(height: 20),

              // 4. طريقة الدفع
              _buildSectionTitle('طريقة الدفع'),
              const SizedBox(height: 8),
              _buildPaymentMethodCard(),
              const SizedBox(height: 30),

              // 5. زر الإجراء الرئيسي لتأكيد الطلب
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: primaryTeal,
      ),
    );
  }

  // 1. بطاقة السائق
  Widget _buildDriverSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: primaryTeal.withOpacity(0.1),
            child: Icon(Icons.person, color: primaryTeal, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سامر الحميص',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: textMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'كيا سيراتو · فضي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '4.9',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: textMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '0.8 كم (4 دقائق)',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. إشعار الخصم الأخضر
  Widget _buildPromoCodeAlert() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: successGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: successGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'MISHWAR10 تم تطبيق كود خصم 10% على هذه الرحلة',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: textMain,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. كرت الفاتورة بالتفصيل
  Widget _buildInvoiceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInvoiceRow('الأجرة الأساسية', '2000 ل.س'),
          const SizedBox(height: 10),
          _buildInvoiceRow('المسافة (4.2 كم × 500)', '2100 ل.س'),
          const SizedBox(height: 10),
          _buildInvoiceRow('وقت الانتظار', '100 ل.س'),
          const SizedBox(height: 10),
          _buildInvoiceRow('خصم MISHWAR10', '- 420 ل.س', isDiscount: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الكلي',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textMain,
                ),
              ),
              Text(
                '3780 ل.س',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? successGreen : textMain,
          ),
        ),
      ],
    );
  }

  // 4. بطاقة طريقة الدفع
  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.payments, color: primaryTeal, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'دفع نقدي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textMain,
                  ),
                ),
                Text(
                  'تدفع للسائق مباشرة عند الوصول',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: primaryTeal, size: 20),
        ],
      ),
    );
  }

  // 5. زر تأكيد الطلب
  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // تأثير بصري مؤقت عند نجاح التأكيد
          showDialog(
            context: context,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                title: const Text('تم إرسال الطلب', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                content: const Text('جاري الاتصال بالسائق وتأكيد الرحلة معك...', style: TextStyle(fontFamily: 'Cairo')),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق الحوار
                      Navigator.pop(context); // العودة للشاشة السابقة
                    },
                    child: Text('حسناً', style: TextStyle(fontFamily: 'Cairo', color: primaryTeal, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryAmber,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'تأكيد الطلب',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: textMain,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}