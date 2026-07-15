import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/app_map.dart';
import '../../ride_request/controller/ride_request_controller.dart';
import '../../trip_receipt/view/trip_receipt_screen.dart';

class LiveTripScreen extends StatefulWidget {
  const LiveTripScreen({super.key});

  @override
  State<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends State<LiveTripScreen> {
  Timer? _tripTimer;
  Timer? _trackingTimer;
  StreamSubscription<Position>? _positionSub;

  // زمن ومسافة حقيقيان — يبدآن من الصفر عند بدء الرحلة.
  int _elapsedSeconds = 0;
  double _distance = 0; // المسافة المقطوعة فعلياً (كم) من GPS
  Position? _lastPosition; // آخر موقع لحساب الفارق
  bool _gpsReady = false;

  bool _completing = false;
  // معرّف الرحلة الحقيقي (من الكنترولر) بدل رقم ثابت.
  int get _rideId => Get.find<RideRequestController>().currentRideId;

  // الأجرة حتى الآن = أجرة الأساس + (المسافة × سعر الكيلومتر) — نفس معادلة السيرفر.
  double get _fare {
    final ride = Get.find<RideRequestController>().currentRide;
    final base = ride?.baseFare ?? 0;
    final perKm = ride?.pricePerKm ?? 0;
    return base + (_distance * perKm);
  }

  @override
  void initState() {
    super.initState();
    _startTripTracking();
  }

  Future<void> _startTripTracking() async {
    // عدّاد الزمن الحقيقي
    _tripTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });

    // 1) صلاحيات الموقع
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        Get.snackbar('تنبيه', 'صلاحية الموقع مطلوبة لقياس مسافة الرحلة',
            backgroundColor: Colors.amber.shade100,
            snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }

    // 2) بثّ الموقع الحقيقي: نجمع المسافة فعلياً بين كل نقطتين
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // متر — نتجاهل الاهتزاز البسيط
      ),
    ).listen((pos) {
      if (_lastPosition != null) {
        final meters = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          pos.latitude,
          pos.longitude,
        );
        if (mounted) setState(() => _distance += meters / 1000);
      }
      _lastPosition = pos;
      if (!_gpsReady && mounted) setState(() => _gpsReady = true);
    });

    // 3) إرسال الموقع الحقيقي للسيرفر كل 10 ثوانٍ (يعتمد عليه السيرفر في التسعير)
    _trackingTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final pos = _lastPosition;
      if (pos == null) return;
      await Get.find<RideRequestController>().sendTracking(
        _rideId,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
    });
  }

  @override
  void dispose() {
    _tripTimer?.cancel();
    _trackingTimer?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _onCompleteTrip() async {
    setState(() => _completing = true);
    _tripTimer?.cancel();
    _trackingTimer?.cancel();

    final controller = Get.find<RideRequestController>();
    await controller.completeRide(
      _rideId,
      distanceKm: _distance,
      durationMinutes: _elapsedSeconds ~/ 60,
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TripReceiptScreen()),
    );
  }

  // دالة لتنسيق الوقت لشكل (دقائق:ثواني)
  String _formatDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(
      0xFF00B4A0,
    ); // التيركواز الأساسي للشريط والتعليمات
    const Color orangeColor = Color(0xFFFFB822); // الأصفر لزر إنهاء الرحلة
    const Color darkBlue = Color(0xFF0F3A46); // لون لوحة الأجرة الغامق

    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية الخريطة الحقيقية (OpenStreetMap)
          Positioned.fill(
            child: GetBuilder<RideRequestController>(
              builder: (c) {
                final ride = c.currentRide;
                if (ride == null || ride.pickupLat == 0) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return AppMap(
                  height: null,
                  pickup: LatLng(ride.pickupLat, ride.pickupLng),
                  destination: LatLng(ride.destinationLat, ride.destinationLng),
                );
              },
            ),
          ),

          // 2. لوحة إحصائيات الرحلة العلوية (الأجرة، المسافة، الوقت)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // العداد (المدة)
                    _buildStatColumn('المدة', _formatDuration(_elapsedSeconds)),

                    // خط فاصل عمودي ناعم
                    Container(
                      width: 1,
                      height: 35,
                      color: Colors.grey.shade300,
                    ),

                    // المسافة
                    _buildStatColumn(
                      'المسافة',
                      '${_distance.toStringAsFixed(1)} كم',
                    ),

                    // خط فاصل عمودي ناعم
                    Container(
                      width: 1,
                      height: 35,
                      color: Colors.grey.shade300,
                    ),

                    // الأجرة الحالية (يساراً بالتصميم)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'الأجرة حتى الآن',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              ' ل.س',
                              style: TextStyle(
                                color: darkBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              // _fare أصبح double محسوباً من المسافة الحقيقية،
                              // لذا نعرضه بلا كسور مع فواصل الآلاف.
                              _fare.toStringAsFixed(0).replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]},',
                              ),
                              style: const TextStyle(
                                color: tealColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. شارة الإشعار الصغيرة تحت اللوحة "الرحلة جارية مع أحمد"
          Positioned(
            top: 115,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'الرحلة جارية . مع أحمد',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6),
                    CircleAvatar(radius: 4, backgroundColor: tealColor),
                  ],
                ),
              ),
            ),
          ),

          // 4. زر الطوارئ SOS العائم فوق كرت الوجهة
          Positioned(
            bottom: 225,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () async {
                final Uri launchUri = Uri(scheme: 'tel', path: '112');
                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                  // TODO: Send critical trip SOS event to server للربط
                }
              },
              backgroundColor: Colors.red.shade600,
              elevation: 4,
              child: const Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),

          // 5. البطاقة البيضاء السفلية (الوجهة وزر الإنهاء)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // خط السحب العلوي المعتاد
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // تفاصيل الوجهة المقصودة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'الوجهة . ٥.٤ كم متبقية',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'مطار دمشق الدولي . صالة المغادرة',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: orangeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.flag_rounded,
                          color: orangeColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // زر "إنهاء الرحلة" الأصفر الكبير
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _completing ? null : _onCompleteTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: _completing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'إنهاء الرحلة',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت داخلي لبناء خانات الإحصائيات (المدة والمسافة)
  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
