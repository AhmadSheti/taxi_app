import 'package:flutter/material.dart';
import '../../ride_request/view/ride_request_dialog.dart';

// الموديل (الوعاء اللي بيشيل البيانات)
class StatItem {
  final String title;
  final String value;
  final Color valueColor;
  StatItem({
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isOnline = true;
  final List<StatItem> stats = [
    StatItem(title: 'ساعات الاتصال', value: '3:42 س'),
    StatItem(title: 'رحلات اليوم', value: '7 رحلة'),
    StatItem(
      title: 'معدل القبول',
      value: '94 %',
      valueColor: const Color(0xFF00B4A0),
    ),
    StatItem(
      title: 'التقييم',
      value: '4.9 ★',
      valueColor: const Color(0xFF00B4A0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية (الخريطة)
          Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.map, size: 100, color: Colors.grey),
            ),
          ),

          // العلوية
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopCard(
                    Icons.account_balance_wallet,
                    'أرباح اليوم: ٤٥,٠٠٠ ل.س',
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isOnline = !isOnline;
                      });

                      // هنا نضع شرط الربط:
                      // إذا تغيرت الحالة إلى "متصل"، نظهر النافذة
                      if (isOnline) {
                        showRideRequest(context);
                      }
                    },
                    child: _buildTopCard(
                      Icons.circle,
                      isOnline ? 'مُتصل' : 'غير متصل',
                      color: isOnline ? const Color(0xFF00B4A0) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // الكرت السفلي
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Icon(Icons.settings, color: Colors.grey),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'متاح لاستقبال الطلبات',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'متصل منذ ٣:٤٢ ساعات . المالكي',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        backgroundColor: Color(0xFFE0F7F4),
                        child: Icon(Icons.flash_on, color: Color(0xFF00B4A0)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // الإحصاءات
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemCount: stats.length,
                    itemBuilder: (context, index) =>
                        _buildStatCard(stats[index]),
                  ),
                  const SizedBox(height: 20),
                  _buildLastTripCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(StatItem item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Text(
            item.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: item.valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard(
    IconData icon,
    String text, {
    Color color = const Color(0xFF00B4A0),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLastTripCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
          Text(
            'آخر رحلة ٧,٢٠٠ ل.س',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
