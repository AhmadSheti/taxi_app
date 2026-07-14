import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../constants.dart';

/// ويدجت خريطة مشترك (OpenStreetMap — مجاني بلا مفتاح API).
/// يرسم الخريطة + خطاً (Polyline) بين الانطلاق والوصول محلياً (بلا API) + علامات.
/// مرّر ما تملكه من إحداثيات LatLng؛ الويدجت يتكيّف.
class AppMap extends StatelessWidget {
  final LatLng? pickup;
  final LatLng? destination;
  final LatLng? driver;

  /// ارتفاع ثابت. إن كان null تملأ المساحة المتاحة (خلفية بملء الشاشة).
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
    final center = all.isNotEmpty ? all.first : const LatLng(33.5138, 36.2765);

    Widget map = FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: initialZoom,
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
          userAgentPackageName: 'com.mashwar.customer',
        ),
        if (pickup != null && destination != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [pickup!, destination!],
                color: AppColors.primaryTeal,
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
                child: const Icon(Icons.my_location,
                    color: Colors.green, size: 38),
              ),
            if (destination != null)
              Marker(
                point: destination!,
                width: 44,
                height: 44,
                child: const Icon(Icons.location_on,
                    color: AppColors.danger, size: 38),
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

  Widget _carPin() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.secondaryAmber,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.local_taxi, color: AppColors.primaryTeal, size: 22),
    );
  }
}
