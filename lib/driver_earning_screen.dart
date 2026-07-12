import 'package:flutter/material.dart';
import 'company_commission_screen.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF00B4A0); // التيركواز الأساسي
    const Color darkBlue = Color(0xFF0F3A46); // الغامق للنصوص والعناوين
    const Color lightGrey = Color(0xFFF1F3F6); // خلفية الكروت الصغيرة

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.settings_outlined, color: darkBlue),
        centerTitle: true,
        title: const Text(
          'أرباحي',
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
                  builder: (context) => const CompanyCommissionScreen(),
                ), // تأكدي أن اسم الكلاس لصفحة العمولة هو هذا أو ما يشابهه
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
            // 1. شريط التصفية الزمني العلوي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton('الكل', false),
                _buildTabButton('الشهر', false),
                _buildTabButton('الأسبوع', true, activeColor: tealColor),
                _buildTabButton('اليوم', false),
              ],
            ),
            const SizedBox(height: 20),

            // 2. كرت إجمالي أرباح الأسبوع
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7F6), // تيركواز فاتح جداً للخلفية
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'أرباح هذا الأسبوع',
                        style: TextStyle(
                          color: tealColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: tealColor,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                        '٣٢٤,٧٥٠',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'مقابل الأسبوع الماضي',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '١٢٪ +',
                        style: TextStyle(
                          color: tealColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_upward, color: tealColor, size: 12),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. كرت المخطط البياني للأرباح اليومية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'الأرباح اليومية (ألف ل.س)',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '١٥ - ٢٢ مايو',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 25),

                  // رسم أعمدة المخطط البياني ببساطة مذهلة
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarChartColumn(45, false),
                        _buildBarChartColumn(60, false),
                        _buildBarChartColumn(35, false),
                        _buildBarChartColumn(
                          80,
                          true,
                          barColor: tealColor,
                        ), // اليوم الأعلى ربحاً
                        _buildBarChartColumn(50, false),
                        _buildBarChartColumn(65, false),
                        _buildBarChartColumn(40, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. شبكة الإحصائيات السفلية (Grid 2x2)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('ساعات الاتصال', '٢٦:٤٠', lightGrey),
                ),
                const SizedBox(width: 15),
                Expanded(child: _buildStatCard('عدد الرحلات', '٣٨', lightGrey)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'متوسط الرحلة',
                    '٨,٥٤٠ ل.س',
                    lightGrey,
                    valueColor: tealColor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard('المسافة الكلية', '٤١٢ كم', lightGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت داخلي لبناء أزرار شريط التصفية
  Widget _buildTabButton(String label, bool isActive, {Color? activeColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isActive ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade600,
          fontSize: 13,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // ويدجت داخلي لبناء أعمدة الرسم البياني
  Widget _buildBarChartColumn(
    double height,
    bool isActive, {
    Color barColor = const Color(0xFFE5E9F0),
  }) {
    return Container(
      width: 18,
      height: height,
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // ويدجت داخلي لبناء كروت الإحصائيات السفلية الصغيرة
  Widget _buildStatCard(
    String label,
    String value,
    Color bgColor, {
    Color valueColor = Colors.black87,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
