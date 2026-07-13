import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../active_trip/view/active_trip_screen.dart';
import '../../dashboard/model/pending_ride_model.dart';
import '../controller/ride_request_controller.dart';

void showRideRequest(BuildContext context, PendingRideModel ride) {
  final controller = Get.find<RideRequestController>();

  showDialog(
    context: context,
    barrierDismissible: false, // لا يُغلق إلا بالضغط على قبول أو رفض
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'طلب رحلة جديد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),

            // 1. معلومات العميل
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF00B4A0),
                  child: Text('أ', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'التقييم: ${ride.ratingAverage.toStringAsFixed(1)} ★',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // 2. الخريطة المصغرة
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Icon(Icons.map, color: Colors.grey)),
            ),
            const SizedBox(height: 15),

            // 3. معلومات المسافة والأجرة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('المسافة', '${ride.distanceKm.toStringAsFixed(1)} كم'),
                _buildInfoColumn('الوجهة', ride.destinationAddress),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الأجرة المتوقعة',
                    style: TextStyle(color: Color(0xFF00B4A0)),
                  ),
                  Text(
                    '${ride.estimatedFare.toStringAsFixed(0)} ل.س',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. أزرار قبول ورفض
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await controller.rejectRide(ride.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'رفض',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.acceptRide(ride.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ActiveTripScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF80CBC4),
                    ),
                    child: const Text('قبول'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ويدجت مساعد للمعلومات
Widget _buildInfoColumn(String title, String value) {
  return Column(
    children: [
      Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}
