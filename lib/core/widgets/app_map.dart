import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../constants.dart';

/// ويدجت خريطة مشترك (OpenStreetMap — مجاني بلا مفتاح API).
/// يرسم:
///  - الخريطة (بلاطات OSM).
///  - خطاً (Polyline) بين نقطة الانطلاق والوصول — يُرسم محلياً في التطبيق، بلا API.
///  - علامات (Markers) للانطلاق / الوصول / السائق.
///
/// كل الإحداثيات LatLng. مرّر ما تملكه؛ الويدجت يتكيّف:
///  - نقطتان → خط + علامتان + ملاءمة الإطار (fit) لكليهما.
///  - نقطة واحدة → علامة واحدة (خريطة عادية متمركزة عليها).
class AppMap extends StatelessWidget {
  final LatLng? pickup;
  final LatLng? destination;
  final LatLng? driver;

  /// ارتفاع ثابت للخريطة. إن كان null تملأ المساحة المتاحة (للخلفية بملء الشاشة).
  final double? height;
  final double borderRadius;
  final double initialZoom;

  const AppMap({
    super.key,
    this.pickup,
    this.destination,
    this.driver,
    this.height = 250,
    this.borderRadius = 0,
    this.initialZoom = 13,
  });

  List<LatLng> get _all => [
        if (pickup != null) pickup!,
        if (destination != null) destination!,
        if (driver != null) driver!,
      ];

  @override
  Widget build(BuildContext context) {
    final all = _all;
    // مركز افتراضي: دمشق (يُستخدم عند عدم توفّر أي نقطة).
    final center = all.isNotEmpty ? all.first : const LatLng(33.5138, 36.2765);

    Widget map = FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: initialZoom,
        // إن توفّرت نقطتان أو أكثر نلائم الإطار ليُظهرها كلها.
        initialCameraFit: all.length >= 2
            ? CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(all),
                padding: const EdgeInsets.all(50),
              )
            : null,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.mashwar.app',
        ),
        // الخط بين الانطلاق والوصول (محلي، بلا API)
        if (pickup != null && destination != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [pickup!, destination!],
                color: AppColors.primary,
                strokeWidth: 4,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (pickup != null)
              Marker(
                point: pickup!,
                width: 44,
                height: 44,
                child: _pin(Icons.my_location, Colors.green),
              ),
            if (destination != null)
              Marker(
                point: destination!,
                width: 44,
                height: 44,
                child: _pin(Icons.location_on, AppColors.danger),
              ),
            if (driver != null)
              Marker(
                point: driver!,
                width: 46,
                height: 46,
                child: _carPin(),
              ),
          ],
        ),
      ],
    );

    if (borderRadius > 0) {
      map = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: map,
      );
    }

    return height == null ? map : SizedBox(height: height, child: map);
  }

  Widget _pin(IconData icon, Color color) {
    return Icon(icon, color: color, size: 38);
  }

  Widget _carPin() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.local_taxi, color: AppColors.primary, size: 22),
    );
  }
}
