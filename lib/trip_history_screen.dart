import 'package:flutter/material.dart';
import 'driver_ratings_screen.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  // الألوان المعتمدة بتطبيق مشوار
  final Color tealColor = const Color(0xFF00B4A0);
  final Color darkBlue = const Color(0xFF0D3E46);
  final Color bgLight = const Color(0xFFF7F9FA);

  // المتغير المسؤول عن التبويب النشط حالياً
  int selectedTab = 0;
  final List<String> tabs = ['الكل', 'مكتملة', 'ملغاة', 'مرفوضة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'سجلّ الرحلات',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: darkBlue, size: 18),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DriverRatingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //  شريط التبويبات1..
          Container(
            height: 45,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true, // عشان يبدأ الترتيب العربي من اليمين لليسار
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                bool isActive = selectedTab == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? tealColor : bgLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. قائمة الرحلات (List of Trips)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // قسم: اليوم
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'اليوم',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildTripCard(
                    name: 'أحمد العلي',
                    initials: 'أ',
                    avatarColor: const Color(0xFF1F5E6B),
                    route: 'المالكي ← مطار دمشق',
                    timeInfo: 'منذ ١٤ دقيقة',
                    rating: '٥.٠',
                    price: '١١,٢٥٠ ل.س',
                    status: 'مكتملة',
                    statusColor: tealColor,
                  ),
                  _buildTripCard(
                    name: 'ليلى مرعي',
                    initials: 'ل',
                    avatarColor: const Color(0xFF9B6BFF),
                    route: 'شارع بغداد ← باب توما',
                    timeInfo: '٩:١٢ ص',
                    rating: '٤.٠',
                    price: '٢,٤٣٠ ل.س',
                    status: 'مكتملة',
                    statusColor: tealColor,
                  ),
                  _buildTripCard(
                    name: 'ماجد الحلو',
                    initials: 'م',
                    avatarColor: const Color(0xFF4AC2CD),
                    route: 'الزاهرة ← دمر',
                    timeInfo: '٨:٢٠ ص',
                    rating: '', // لا يوجد تقييم للمرفوضة
                    price: 'تجاوز ١٥ ثانية',
                    status: 'مرفوضة',
                    statusColor: const Color(0xFFFFB822),
                  ),

                  // قسم: أمس
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'أمس',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildTripCard(
                    name: 'خليل العطار',
                    initials: 'خ',
                    avatarColor: const Color(0xFFF39C12),
                    route: 'الجامعة ← المهاجرين',
                    timeInfo: '٨:٠١ م',
                    rating: '٥.٠',
                    price: '٣,٢٠٠ ل.س',
                    status: 'مكتملة',
                    statusColor: tealColor,
                  ),
                  _buildTripCard(
                    name: 'سلمى الديب',
                    initials: 'س',
                    avatarColor: const Color(0xFFE74C3C),
                    route: 'القصاع ← مشروع دمر',
                    timeInfo: '٤:١٥ م',
                    rating: '',
                    price: 'ملغاة من العميل',
                    status: 'ملغاة',
                    statusColor: const Color(0xFFE74C3C),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //ويدجت داخلي لبناء كرت الرحلة
  Widget _buildTripCard({
    required String name,
    required String initials,
    required Color avatarColor,
    required String route,
    required String timeInfo,
    required String rating,
    required String price,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. تفاصيل الحالة والسعر (يسار الكرت)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                price,
                style: TextStyle(
                  fontSize: price.contains('ل.س') ? 14 : 11,
                  fontWeight: price.contains('ل.س')
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: price.contains('ل.س') ? tealColor : Colors.grey,
                ),
              ),
            ],
          ),

          const Spacer(),
          // 2. تفاصيل العميل والمسار والوقت (يمين الكرت)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                route,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (rating.isNotEmpty) ...[
                    Text(
                      rating,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, color: Color(0xFFFFB822), size: 12),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    timeInfo,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),

          // 3. الآفاتار (صورة الحرف الدائرية)
          CircleAvatar(
            radius: 18,
            backgroundColor: avatarColor,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
