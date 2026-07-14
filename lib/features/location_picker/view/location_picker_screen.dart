import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../constants.dart';
import '../model/picked_location.dart';

/// شاشة اختيار موقع على الخريطة.
/// الفكرة: دبّوس (Marker) ثابت في منتصف الشاشة، والمستخدم يحرّك الخريطة تحته.
/// عند «تأكيد الموقع» نأخذ مركز الخريطة الحالي ونرجع PickedLocation عبر Get.back(result:).
class LocationPickerScreen extends StatefulWidget {
  final LatLng initialCenter;
  final String title;
  final Color pinColor;

  const LocationPickerScreen({
    super.key,
    required this.initialCenter,
    this.title = 'اختر الموقع',
    this.pinColor = AppColors.primaryTeal,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  late LatLng _center; // يتحدّث مع كل تحريك للخريطة

  @override
  void initState() {
    super.initState();
    _center = widget.initialCenter;
  }

  void _confirm() {
    // اسم افتراضي للموقع (لا يوجد reverse-geocoding — بلا API).
    final name =
        'موقع محدد (${_center.latitude.toStringAsFixed(5)}, ${_center.longitude.toStringAsFixed(5)})';
    Get.back(result: PickedLocation(_center, name));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // 1) الخريطة (OpenStreetMap)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: widget.initialCenter,
                initialZoom: 15,
                onPositionChanged: (camera, hasGesture) {
                  _center = camera.center; // نتتبّع المركز باستمرار
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mashwar.customer',
                ),
              ],
            ),

            // 2) الدبّوس الثابت في منتصف الشاشة (طرفه يشير للمركز)
            IgnorePointer(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Icon(Icons.location_pin,
                      size: 50, color: widget.pinColor),
                ),
              ),
            ),

            // 3) زر «موقعي» (يعيد التمركز على النقطة الأولية)
            Positioned(
              bottom: 140,
              left: 16,
              child: FloatingActionButton.small(
                heroTag: 'recenter',
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryTeal,
                onPressed: () =>
                    _mapController.move(widget.initialCenter, 15),
                child: const Icon(Icons.my_location),
              ),
            ),

            // 4) اللوحة السفلية: تلميح + زر التأكيد
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app_outlined,
                            size: 18, color: AppColors.textSecondary),
                        SizedBox(width: 6),
                        Text('حرّك الخريطة لضبط الموقع بدقّة',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _confirm,
                        icon: const Icon(Icons.check, color: AppColors.textMain),
                        label: const Text('تأكيد الموقع',
                            style: AppStyles.buttonText),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryAmber,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
