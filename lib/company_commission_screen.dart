import 'package:flutter/material.dart';
import 'trip_history_screen.dart';

class CompanyCommissionScreen extends StatelessWidget {
  const CompanyCommissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF00B4A0); // التيركواز الأساسي
    const Color darkBlue = Color(0xFF0F3A46); // الغامق للنصوص والعناوين
    const Color orangeColor = Color(0xFFFFB822); // الأصفر للتنبيهات والأزرار
    const Color lightBg = Color(0xFFF7F9FA); // خلفية كرت السعر الفاتحة

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'عمولة الشركة',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: darkBlue,
              size: 18,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripHistoryScreen(),
                ), // تأكدي من اسم الكلاس
              );
            },

            // TODO: Back navigation
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. كرت التنبيه العلوي الأصفر (اقترب موعد سداد العمولة)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E7), // أصفر فاتح جداً
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: orangeColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'اقترب موعد سداد العمولة',
                          style: TextStyle(
                            color: Color(0xFFB37D00),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تجاوزت العمولة المستحقة الحد المسموح، الرجاء التسديد خلال ٣ أيام لتجنب إيقاف الحساب.',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: orangeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. كرت عرض السعر والمبلغ المستحق الحالي
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'المبلغ المستحق',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Text(
                        ' ل.س',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '٤٨,٤٢٠',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // شريط التقدم للحد المسموح (Progress Bar)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '٥٠,٠٠٠ ل.س',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      Text(
                        'الحد المسموح',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value:
                          0.96, // يمثل نسبة القرب من الحد الأقصى (48,420 من 50,000)
                      backgroundColor: Color(0xFFE5E9F0),
                      valueColor: AlwaysStoppedAnimation<Color>(tealColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. زر "سداد المبلغ المستحق" الأصفر الكبير
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Trigger payment gateway or process commission payment للربط
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.payment, color: darkBlue, size: 20),
                label: const Text(
                  'سداد المبلغ المستحق',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 4. سجل السداد السالف (قائمة الدفعات السابقة)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'سجل السداد',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // قائمة الدفعات
            _buildPaymentHistoryItem('٥٠,٠٠٠ ل.س', '٨ مايو ٢٠٢٦', tealColor),
            _buildPaymentHistoryItem('٥٠,٠٠٠ ل.س', '١ مايو ٢٠٢٦', tealColor),
            _buildPaymentHistoryItem('٤٢,٣٠٠ ل.س', '٢٤ أبريل ٢٠٢٦', tealColor),
          ],
        ),
      ),
    );
  }

  // ويدجت داخلي مخصص لبناء أسطر سجل السداد بشكل أنيق متل الصورة
  Widget _buildPaymentHistoryItem(
    String amount,
    String date,
    Color activeColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // شارة الحالة (مدفوع) يساراً
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'مدفوع',
              style: TextStyle(
                color: activeColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.check_circle, color: activeColor, size: 16),

          const Spacer(),

          // تفاصيل المبلغ والتاريخ يميناً
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3A46),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
