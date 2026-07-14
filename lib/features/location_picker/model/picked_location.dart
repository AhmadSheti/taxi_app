import 'package:latlong2/latlong.dart';

/// نتيجة اختيار موقع من شاشة الخريطة: الإحداثيات + اسم افتراضي للموقع.
class PickedLocation {
  final LatLng point;
  final String name;

  const PickedLocation(this.point, this.name);
}
