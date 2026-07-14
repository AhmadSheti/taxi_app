import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/trip_history_controller.dart';
import '../model/trip_history_model.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final TripHistoryController _controller = Get.find<TripHistoryController>();
  final Color tealColor = const Color(0xFF00B4A0);
  final Color darkBlue = const Color(0xFF0D3E46);
  final Color bgLight = const Color(0xFFF7F9FA);

  int selectedTab = 0;
  final List<String> tabs = ['الكل', 'مكتملة', 'ملغاة'];
  final List<String> statusValues = ['all', 'completed', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    await _controller.fetchTripHistory(status: statusValues[selectedTab]);
  }

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
            icon: Icon(Icons.refresh, color: darkBlue),
            tooltip: 'تحديث',
            onPressed: _loadTrips,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 45,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final isActive = selectedTab == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = index;
                    });
                    _loadTrips();
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
          Expanded(
            child: GetBuilder<TripHistoryController>(
              builder: (controller) {
                // مؤشّر التحميل الكامل يظهر فقط عند التحميل الأول (لا يوجد بيانات).
                if (controller.isLoading && controller.trips.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return RefreshIndicator(
                  color: tealColor,
                  onRefresh: _loadTrips,
                  child: controller.trips.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 140),
                            Center(
                              child: Text(
                                'لا توجد رحلات حتى الآن',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          itemCount: controller.trips.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _buildTripCard(
                                controller, controller.trips[index]);
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(TripHistoryController c, TripHistoryModel trip) {
    final statusColor = trip.status == 'completed'
        ? tealColor
        : trip.status == 'cancelled'
            ? const Color(0xFFE74C3C)
            : Colors.grey;

    String money(double v) => v.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => ',',
        );
    final formattedFare = money(trip.finalFare);
    final formattedEarning = money(trip.driverEarning);
    final statusLabel = trip.status == 'completed'
        ? 'مكتملة'
        : trip.status == 'cancelled'
            ? 'ملغاة'
            : trip.status;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.customerName,
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${trip.pickupAddress} ← ${trip.destinationAddress}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صافي أرباح السائق (بعد العمولة) — هو الأهم للسائق.
                  if (trip.status == 'completed' && trip.driverEarning > 0)
                    Text(
                      'أرباحك: ل.س $formattedEarning',
                      style: TextStyle(
                        color: tealColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  // إجمالي أجرة الرحلة (ما يدفعه الزبون) — يطابق ما يراه العميل.
                  Text(
                    'إجمالي الأجرة: ل.س $formattedFare',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 12,
                      fontWeight: trip.driverEarning > 0
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                trip.completedAt.split('T').first,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          if (trip.customerId > 0) ...[
            const Divider(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: _blockButton(c, trip),
            ),
          ],
        ],
      ),
    );
  }

  /// زر حظر الزبون: يعرض التحميل أثناء الطلب و"محظور" بعد نجاحه.
  Widget _blockButton(TripHistoryController c, TripHistoryModel trip) {
    const Color danger = Color(0xFFE74C3C);
    final bool isBlocking = c.blockingCustomerId == trip.customerId;
    final bool isBlocked = c.blockedCustomerIds.contains(trip.customerId);

    if (isBlocked) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('محظور',
            style: TextStyle(
                color: danger, fontSize: 12, fontWeight: FontWeight.bold)),
      );
    }

    return TextButton.icon(
      onPressed: isBlocking ? null : () => _confirmBlock(c, trip),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 32),
      ),
      icon: isBlocking
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: danger),
            )
          : const Icon(Icons.block, size: 16, color: danger),
      label: const Text('حظر الزبون',
          style: TextStyle(color: danger, fontSize: 12)),
    );
  }

  /// حوار تأكيد الحظر مع حقل سبب اختياري.
  Future<void> _confirmBlock(
      TripHistoryController c, TripHistoryModel trip) async {
    final reasonCtrl = TextEditingController();
    final confirmed = await Get.dialog<bool>(
      Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حظر الزبون'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('هل تريد حظر ${trip.customerName}؟ '
                  'لن تصلك طلباته في المستقبل.'),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                maxLines: 2,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                    hintText: 'سبب الحظر (اختياري)', isDense: true),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style:
                  ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE74C3C)),
              child: const Text('حظر', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await c.blockCustomer(trip.customerId, reason: reasonCtrl.text.trim());
    }
  }
}
