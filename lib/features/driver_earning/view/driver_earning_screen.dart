import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/driver_earnings_controller.dart';
class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({super.key});

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  final DriverEarningsController _controller = Get.find<DriverEarningsController>();
  String _selectedPeriod = 'week';

  @override
  void initState() {
    super.initState();
    // نؤجّل التحميل لِما بعد الإطار حتى لا نستدعي update() أثناء البناء
    // (الكنترولر مشترك وله GetBuilder حيّ في تبويب الأرباح).
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    await _controller.fetchEarningsSummary(_selectedPeriod);
    await _controller.fetchEarningsChart(_selectedPeriod);
  }

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
        centerTitle: true,
        title: const Text(
          'أرباحي',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
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
                _buildTabButton('all', 'الكل', _selectedPeriod == 'all', tealColor),
                _buildTabButton('month', 'الشهر', _selectedPeriod == 'month', tealColor),
                _buildTabButton('week', 'الأسبوع', _selectedPeriod == 'week', tealColor),
                _buildTabButton('today', 'اليوم', _selectedPeriod == 'today', tealColor),
              ],
            ),
            const SizedBox(height: 20),

            // 2. كرت ملخص الأرباح من API
            GetBuilder<DriverEarningsController>(
              builder: (controller) {
                final summary = controller.summary;
                final earnings = summary?.totalEarnings ?? 0;
                final ridesCount = summary?.ridesCount ?? 0;
                final distance = summary?.totalDistanceKm ?? 0;
                final avgRide = summary?.averagePerRide ?? 0;
                final periodLabel = summary?.period.isNotEmpty == true ? summary!.period : _selectedPeriod;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF7F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إجمالي الأرباح',
                                style: TextStyle(
                                  color: tealColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الفترة: $periodLabel',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: tealColor,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            'ل.س ',
                            style: TextStyle(
                              color: darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            earnings == 0 ? '...' : earnings.toStringAsFixed(0),
                            style: const TextStyle(
                              color: darkBlue,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSmallSummary('رحلات', ridesCount.toString(), tealColor),
                          _buildSmallSummary('المسافة', '${distance.toStringAsFixed(1)} كم', darkBlue),
                          _buildSmallSummary('متوسط', 'ل.س ${avgRide.toStringAsFixed(0)}', darkBlue),
                        ],
                      ),
                      const SizedBox(height: 8),
                      controller.isLoading
                          ? const CircularProgressIndicator(
                              color: tealColor,
                            )
                          : const SizedBox(height: 0),
                    ],
                  ),
                );
              },
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
                  GetBuilder<DriverEarningsController>(
                    builder: (controller) {
                      final chartData = controller.chartData;
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (chartData.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا توجد بيانات للمخطط',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      final maxEarnings = chartData
                          .map((item) => item.earnings)
                          .fold<double>(0, (prev, value) => value > prev ? value : prev);
                      return SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: chartData.map((item) {
                            final height = maxEarnings > 0
                                ? (item.earnings / maxEarnings) * 80
                                : 0;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildBarChartColumn(height.toDouble(), false,
                                    barColor: tealColor),
                                const SizedBox(height: 6),
                                Text(
                                  item.date.split('T').first,
                                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
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
  Widget _buildTabButton(String value, String title, bool isActive, Color activeColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
        });
        _loadData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
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

  Widget _buildSmallSummary(String title, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
