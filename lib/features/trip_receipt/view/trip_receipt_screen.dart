import 'package:flutter/material.dart';
import '../../driver_earning/view/driver_earning_screen.dart';

class TripReceiptScreen extends StatelessWidget {
  const TripReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF00B4A0); // التيركواز الأساسي
    const Color darkBlue = Color(0xFF0F3A46); // الغامق للنصوص والعناوين
    const Color orangeColor = Color(0xFFFFB822); // الأصفر للخصومات والتقييم
    const Color lightBg = Color(0xFFF7F9FA); // خلفية كرت السعر الفاتحة

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(color: Colors.black, blurRadius: 15, spreadRadius: 2),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة إغلاق الواجهة فوق يميناً
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),

                      onPressed: () {
                        // TODO: Close screen and return to map dashboard
                        Navigator.of(context).pop();
                      },
                    ),
                  ),

                  // علامة النجاح الخضراء الدائرية
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFE2F7F4),
                    child: Icon(Icons.check_circle, color: tealColor, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'تمت الرحلة بنجاح',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // كرت عرض السعر المطلوب نقداً (الرمادي الفاتح)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: lightBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'اطلب من العميل نقداً',
                          style: TextStyle(
                            color: tealColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '١٢,٥٠٠',
                          style: TextStyle(
                            color: tealColor,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ليرة سورية',
                          style: TextStyle(
                            color: darkBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // تفاصيل العميل والمشوار
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: darkBlue,
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              'أحمد العلي',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: darkBlue,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'المالكي ⟵ مطار دمشق . ١٨.٤ كم . ٣٢ د',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // صندوق تفاصيل وتوزيع الأجرة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'توزيع الأجرة',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        const Divider(height: 20),
                        _buildReceiptRow(
                          'إجمالي الأجرة',
                          '١٢,٥٠٠ ل.س',
                          Colors.black,
                        ),
                        const SizedBox(height: 10),
                        _buildReceiptRow(
                          'حصة الشركة (١٠٪)',
                          '-١,٢٥٠ ل.س',
                          orangeColor,
                        ),
                        const Divider(
                          height: 25,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        _buildReceiptRow(
                          'حصتك الصافية',
                          '١١,٢٥٠ ل.س',
                          tealColor,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // زر التأكيد السفلي "تم استلام المبلغ"
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DriverEarningsScreen(),
                          ),
                          (route) => false,
                        );

                        // TODO: Commit financial transaction and clear state
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
                        'تم استلام المبلغ',
                        style: TextStyle(
                          color: Colors.white,
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
        ),
      ),
    );
  }

  // ويدجت داخلي لبناء أسطر الفاتورة بشكل منسق يمين ويسار
  Widget _buildReceiptRow(
    String title,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: isBold ? const Color(0xff0d3e46) : Colors.grey.shade600,
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
