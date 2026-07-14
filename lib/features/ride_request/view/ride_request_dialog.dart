import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/widgets/app_map.dart';
import '../../active_trip/view/active_trip_screen.dart';
import '../../dashboard/model/pending_ride_model.dart';
import '../controller/ride_request_controller.dart';

void showRideRequest(BuildContext context, PendingRideModel ride) {
  showDialog(
    context: context,
    barrierDismissible: false, // لا يُغلق إلا بالضغط على قبول أو رفض
    builder: (context) => _RideRequestDialog(ride: ride),
  );
}

class _RideRequestDialog extends StatefulWidget {
  final PendingRideModel ride;
  const _RideRequestDialog({required this.ride});

  @override
  State<_RideRequestDialog> createState() => _RideRequestDialogState();
}

class _RideRequestDialogState extends State<_RideRequestDialog> {
  final controller = Get.find<RideRequestController>();
  bool _accepting = false;
  bool _rejecting = false;

  // يُعطّل كلا الزرين ما دامت أي عملية جارية.
  bool get _busy => _accepting || _rejecting;

  Future<void> _onReject() async {
    setState(() => _rejecting = true);
    await controller.rejectRide(widget.ride.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _onAccept() async {
    setState(() => _accepting = true);
    await controller.acceptRide(widget.ride.id);
    await controller.getRideDetails(widget.ride.id);
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ActiveTripScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    return Dialog(
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
                      // ملاحظة: لا يوجد نظام تقييم للزبائن في الـ backend
                      // (التقييم باتجاه واحد: العميل يقيّم السائق فقط).
                      const Text(
                        'طلب رحلة جديد',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // 2. الخريطة المصغرة — خريطة حقيقية + خط بين الانطلاق والوصول
            AppMap(
              pickup: LatLng(ride.pickupLat, ride.pickupLng),
              destination: LatLng(ride.destinationLat, ride.destinationLng),
              height: 130,
              borderRadius: 15,
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
                    onPressed: _busy ? null : _onReject,
                    child: _rejecting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'رفض',
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _busy ? null : _onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF80CBC4),
                    ),
                    child: _accepting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('قبول'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
