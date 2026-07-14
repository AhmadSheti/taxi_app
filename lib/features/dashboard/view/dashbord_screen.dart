import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_map.dart';
import '../controller/availability_controller.dart';
import '../controller/pending_rides_controller.dart';
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
  final PendingRidesController _pendingRidesController = Get.find<PendingRidesController>();
  final AvailabilityController _availabilityController = Get.find<AvailabilityController>();
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
  void initState() {
    super.initState();
    // عند وصول طلب جديد أثناء الاستطلاع → نعرض حوار القبول تلقائياً.
    _pendingRidesController.onNewRequest = (ride) {
      if (mounted) showRideRequest(context, ride);
    };
    // نزامن الحالة الحقيقية من السيرفر، ثم نبدأ الاستطلاع فقط إن كان السائق نشطاً.
    _availabilityController.syncStatus().then((_) {
      if (_availabilityController.isOnline) {
        _pendingRidesController.startPolling();
      }
    });
  }

  @override
  void dispose() {
    // نوقف الاستطلاع ونلغي الـ callback عند مغادرة لوحة التحكم.
    _pendingRidesController.onNewRequest = null;
    _pendingRidesController.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية: خريطة حقيقية (OpenStreetMap) بملء الشاشة
          const Positioned.fill(
            child: AppMap(height: null, initialZoom: 12),
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
                    onTap: () async {
                      if (_availabilityController.isLoading) return;
                      await _availabilityController.toggleAvailability();

                      if (_availabilityController.isOnline) {
                        final firstRide = _pendingRidesController.pendingRides.isNotEmpty
                            ? _pendingRidesController.pendingRides.first
                            : null;
                        if (firstRide != null) {
                          showRideRequest(context, firstRide);
                        } else {
                          Get.snackbar('معلومة', 'لا توجد طلبات واردة حالياً',
                              backgroundColor: Colors.amber.shade100,
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      }
                    },
                    child: GetBuilder<AvailabilityController>(
                      builder: (controller) => _buildTopCard(
                        Icons.circle,
                        controller.isLoading
                            ? 'جارٍ التحديث...'
                            : (controller.isOnline ? 'مُتصل' : 'غير متصل'),
                        color: controller.isOnline ? const Color(0xFF00B4A0) : Colors.grey,
                        loading: controller.isLoading,
                      ),
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
                  GetBuilder<PendingRidesController>(
                    builder: (controller) => _buildIncomingRequestCard(controller),
                  ),
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
    bool loading = false,
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
          loading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: color),
                )
              : Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // بطاقة "طلب وارد" واضحة — تظهر عند وجود طلبات، وبالضغط عليها يُفتح حوار القبول.
  Widget _buildIncomingRequestCard(PendingRidesController controller) {
    if (controller.isLoading && controller.pendingRides.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.pendingRides.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Column(
          children: [
            Icon(Icons.search, color: Colors.grey, size: 28),
            SizedBox(height: 8),
            Text('جاري البحث عن طلبات...',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    final ride = controller.pendingRides.first;
    final extra = controller.pendingRides.length - 1;

    return GestureDetector(
      onTap: () => showRideRequest(context, ride),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7F4),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF00B4A0), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF00B4A0),
                  child: Icon(Icons.notifications_active, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('طلب رحلة وارد',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(
                        '${ride.customerName} • ${ride.distanceKm.toStringAsFixed(1)} كم',
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text('${ride.estimatedFare.toStringAsFixed(0)} ل.س',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF00B4A0))),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => showRideRequest(context, ride),
                icon: const Icon(Icons.visibility, size: 18),
                label: Text(extra > 0 ? 'عرض الطلب (و $extra آخر)' : 'عرض الطلب وقبوله'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B4A0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
