import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/company_commission_controller.dart';
import '../../trip_history/view/trip_history_screen.dart';

class CompanyCommissionScreen extends StatefulWidget {
  const CompanyCommissionScreen({super.key});

  @override
  State<CompanyCommissionScreen> createState() => _CompanyCommissionScreenState();
}

class _CompanyCommissionScreenState extends State<CompanyCommissionScreen> {
  final CompanyCommissionController _controller = Get.find<CompanyCommissionController>();

  @override
  void initState() {
    super.initState();
    _controller.fetchCommission();
  }

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF00B4A0);
    const Color darkBlue = Color(0xFF0F3A46);
    const Color orangeColor = Color(0xFFFFB822);
    const Color lightBg = Color(0xFFF7F9FA);

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
                ),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<CompanyCommissionController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final totalOwed = controller.commission?.totalOwed ?? 0;
          final ridesCount = controller.commission?.ridesCount ?? 0;
          final warning = controller.commission?.warning ?? false;
          final threshold = 50000;
          final progress = totalOwed > 0 ? (totalOwed / threshold).clamp(0, 1) : 0.0;
          final amountText = totalOwed == 0
              ? '٠'
              : totalOwed.toString().replaceAllMapped(
                  RegExp(r'\B(?=(\d{3})+(?!\d))'),
                  (match) => ',',
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: warning ? const Color(0xFFFFF8E7) : const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: warning ? orangeColor.withOpacity(0.3) : tealColor.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              warning ? 'اقترب موعد سداد العمولة' : 'عمولة الشركة متوازنة',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: warning ? const Color(0xFFB37D00) : tealColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              warning
                                  ? 'تجاوزت العمولة المستحقة الحد المسموح، الرجاء التسديد خلال ٣ أيام لتجنب إيقاف الحساب.'
                                  : 'عدد الرحلات المحسوبة: $ridesCount، ولا يوجد تحذير في الوقت الحالي.',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: warning ? Colors.black : darkBlue,
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
                          color: warning ? orangeColor : tealColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          warning ? Icons.notifications_active : Icons.check_circle,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                        children: [
                          const Text(
                            ' ل.س',
                            style: TextStyle(
                              color: darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            amountText,
                            style: const TextStyle(
                              color: darkBlue,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${threshold.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')} ل.س',
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          const Text(
                            'الحد المسموح',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFE5E9F0),
                          valueColor: AlwaysStoppedAnimation<Color>(tealColor),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                _buildPaymentHistoryItem('٥٠,٠٠٠ ل.س', '٨ مايو ٢٠٢٦', tealColor),
                _buildPaymentHistoryItem('٥٠,٠٠٠ ل.س', '١ مايو ٢٠٢٦', tealColor),
                _buildPaymentHistoryItem('٤٢,٣٠٠ ل.س', '٢٤ أبريل ٢٠٢٦', tealColor),
              ],
            ),
          );
        },
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
