import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../constants.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/widgets/app_map.dart';
import '../../rate_driver/view/rate_driver_screen.dart';
import '../../trip_cancelled/view/trip_cancelled_screen.dart';
import '../controller/booking_controller.dart';

/// شاشة التتبّع الموحّدة: تعرض حالة الرحلة الحيّة (بانتظار/في الطريق/وصل/جارية)
/// عبر استطلاع دوري، وتنتقل تلقائياً للتقييم عند الاكتمال أو للإلغاء.
class TrackingScreen extends StatefulWidget {
  final int rideId;
  const TrackingScreen({super.key, required this.rideId});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  bool _navigated = false;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    Get.find<BookingController>().startTracking(widget.rideId);
  }

  @override
  void dispose() {
    Get.find<BookingController>().stopTracking();
    super.dispose();
  }

  Future<void> _onCancel(BookingController c, RideModel ride) async {
    setState(() => _cancelling = true);
    final ok = await c.cancelRide(ride.id, reason: 'إلغاء من العميل');
    if (ok) {
      Get.off(() => const TripCancelledScreen());
    } else if (mounted) {
      setState(() => _cancelling = false);
    }
  }

  void _maybeNavigate(RideModel ride) {
    if (_navigated) return;
    if (ride.isCompleted) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => RateDriverScreen(rideId: ride.id));
      });
    } else if (ride.isCancelled) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => const TripCancelledScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: GetBuilder<BookingController>(
          builder: (c) {
            final ride = c.currentRide;
            if (ride == null) {
              return const Center(child: CircularProgressIndicator());
            }
            _maybeNavigate(ride);

            return SafeArea(
              child: Column(
                children: [
                  // الخريطة الحيّة + الخط بين الانطلاق والوصول (يُرسم محلياً)
                  Expanded(
                    child: Stack(
                      children: [
                        AppMap(
                          height: null,
                          pickup: LatLng(c.pickupLat, c.pickupLng),
                          destination: LatLng(c.destLat, c.destLng),
                        ),
                        // شريط الحالة أعلى الخريطة
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: _statusBanner(ride),
                        ),
                      ],
                    ),
                  ),
                  // بطاقة السائق السفلية
                  _driverPanel(c, ride),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusBanner(RideModel ride) {
    IconData icon;
    Color color;
    switch (ride.status) {
      case 'accepted':
        icon = Icons.directions_car;
        color = AppColors.primaryTeal;
        break;
      case 'driver_arrived':
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case 'in_progress':
        icon = Icons.navigation;
        color = AppColors.primaryTeal;
        break;
      default:
        icon = Icons.search;
        color = AppColors.secondaryAmber;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Flexible(
            child: Text(ride.statusLabel,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textMain)),
          ),
          if (ride.isPending) ...[
            const SizedBox(width: 8),
            const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ],
      ),
    );
  }

  // لوحة "جاري البحث عن سائق" — تظهر قبل أن يقبل أي سائق الطلب.
  Widget _searchingPanel(BookingController c, RideModel ride) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 3)),
          const SizedBox(height: 16),
          const Text('جاري البحث عن سائق...',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain)),
          const SizedBox(height: 6),
          const Text('نرسل طلبك إلى السائقين المتاحين القريبين منك',
              textAlign: TextAlign.center, style: AppStyles.bodyRegular),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _cancelling ? null : () => _onCancel(c, ride),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.danger),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _cancelling
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.danger))
                  : const Text('إلغاء الطلب',
                      style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverPanel(BookingController c, RideModel ride) {
    // ما دام لا يوجد سائق مُسنَد بعد → نعرض حالة "جاري البحث عن سائق".
    if (ride.driverName == null || ride.isPending) {
      return _searchingPanel(c, ride);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryTeal,
                child: Text(
                  (ride.driverName ?? '؟').substring(0, 1),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride.driverName ?? 'السائق',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain)),
                    if (ride.carModel != null)
                      Text(ride.carModel!, style: AppStyles.bodyRegular),
                  ],
                ),
              ),
              if (ride.plateNumber != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(ride.plateNumber!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الأجرة التقديرية',
                  style: TextStyle(color: AppColors.textSecondary)),
              Text('${ride.estimatedFare.toStringAsFixed(0)} ل.س',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.textMain)),
            ],
          ),
          const SizedBox(height: 16),
          // زر الإلغاء (يظهر قبل بدء الرحلة فقط)
          if (ride.status == 'pending' ||
              ride.status == 'accepted' ||
              ride.status == 'driver_arrived')
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _cancelling ? null : () => _onCancel(c, ride),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.danger),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _cancelling
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.danger))
                    : const Text('إلغاء الطلب',
                        style: TextStyle(
                            color: AppColors.danger, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
