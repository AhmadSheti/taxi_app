import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main/view/main_shell.dart';
import '../../ride_request/controller/ride_request_controller.dart';

class TripReceiptScreen extends StatefulWidget {
  const TripReceiptScreen({super.key});

  @override
  State<TripReceiptScreen> createState() => _TripReceiptScreenState();
}

class _TripReceiptScreenState extends State<TripReceiptScreen> {
  final RideRequestController controller = Get.find<RideRequestController>();
  // المعرّف الحقيقي للرحلة الحالية (مضبوط منذ قبول الطلب) — وليس رقماً وهمياً.
  int get _rideId => controller.currentRideId;

  @override
  void initState() {
    super.initState();
    // نجلب تفاصيل الرحلة (مع الدفعة) بعد الإطار الأول.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getRideDetails(_rideId);
    });
  }

  // صياغة المبلغ بفواصل الآلاف (مثال: 12500 → 12,500).
  String _money(double v) => v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => ',',
      );

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF00B4A0);
    const Color darkBlue = Color(0xFF0F3A46);
    const Color orangeColor = Color(0xFFFFB822);
    const Color lightBg = Color(0xFFF7F9FA);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: GetBuilder<RideRequestController>(
          builder: (c) {
            final ride = c.currentRide;

            // لا نعرض الإيصال حتى تصل الأجرة النهائية والدفعة الحقيقية من السيرفر
            // (عبر getRideDetails)، منعاً لوميض بيانات تقديرية/قديمة عند أول فتح.
            final bool ready =
                ride != null && ride.finalFare > 0 && ride.driverEarning > 0;
            if (!ready) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF00B4A0)),
                    SizedBox(height: 16),
                    Text('جاري تحميل الإيصال...',
                        style: TextStyle(
                            color: Color(0xFF0F3A46),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }

            final double total = ride.displayFare;
            final double commission = ride.commissionAmount;
            final double commissionPct = ride.commissionPercentage;
            final double earning = ride.driverEarning;

            final String routeLine =
                '${ride.pickupAddress} ⟵ ${ride.destinationAddress}'
                '${ride.distanceKm > 0 ? ' · ${ride.distanceKm.toStringAsFixed(1)} كم' : ''}';

            return Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 15,
                        spreadRadius: 2),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFFE2F7F4),
                        child: Icon(Icons.check_circle, color: tealColor, size: 36),
                      ),
                      const SizedBox(height: 12),
                      const Text('تمت الرحلة بنجاح',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkBlue)),
                      const SizedBox(height: 20),

                      // المبلغ المطلوب نقداً من الزبون (إجمالي الأجرة).
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                            color: lightBg, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            const Text('اطلب من العميل نقداً',
                                style: TextStyle(
                                    color: tealColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(_money(total),
                                style: const TextStyle(
                                    color: tealColor,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1)),
                            const SizedBox(height: 4),
                            const Text('ليرة سورية',
                                style: TextStyle(
                                    color: darkBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // تفاصيل العميل والمشوار
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: darkBlue,
                              child: Icon(Icons.person, color: Colors.white, size: 18),
                            ),
                            const Spacer(),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(ride.customerName,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: darkBlue)),
                                  const SizedBox(height: 2),
                                  Text(routeLine,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // توزيع الأجرة (قيم حقيقية)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('توزيع الأجرة',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue)),
                            const Divider(height: 20),
                            _buildReceiptRow(
                                'إجمالي الأجرة', '${_money(total)} ل.س', Colors.black),
                            const SizedBox(height: 10),
                            _buildReceiptRow(
                                'حصة الشركة (${commissionPct.toStringAsFixed(0)}٪)',
                                '- ${_money(commission)} ل.س',
                                orangeColor),
                            const Divider(height: 25, thickness: 1, color: Colors.grey),
                            _buildReceiptRow(
                                'حصتك الصافية', '${_money(earning)} ل.س', tealColor,
                                isBold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await controller.confirmPayment(_rideId);
                            controller.finishTrip();
                            Get.offAll(() => const MainShell());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tealColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.check, color: Colors.white, size: 20),
                          label: const Text('تم استلام المبلغ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String title, String value, Color valueColor,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        Text(title,
            style: TextStyle(
                color: isBold ? const Color(0xff0d3e46) : Colors.grey.shade600,
                fontSize: isBold ? 14 : 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
