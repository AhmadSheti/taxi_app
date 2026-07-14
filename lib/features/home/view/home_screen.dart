import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../constants.dart';
import '../../booking/controller/booking_controller.dart';
import '../../car_type_selection/view/car_type_selection_screen.dart';
import '../../location_picker/model/picked_location.dart';
import '../../location_picker/view/location_picker_screen.dart';
import '../controller/home_controller.dart';

/// تبويب الرئيسية: ترحيب + إدخال نقطة الانطلاق والوجهة + بدء الحجز.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pickup = TextEditingController();
  final _dest = TextEditingController();

  // الإحداثيات المختارة من الخريطة (null = لم تُختر بعد → نستخدم الافتراضي).
  double? _pickupLat, _pickupLng;
  double? _destLat, _destLng;

  @override
  void initState() {
    super.initState();
    Get.find<HomeController>().fetchProfile();
  }

  @override
  void dispose() {
    _pickup.dispose();
    _dest.dispose();
    super.dispose();
  }

  /// يفتح شاشة الخريطة لاختيار موقع، ثم يضع الاسم الافتراضي ويحفظ الإحداثيات.
  Future<void> _openPicker({required bool isPickup}) async {
    final booking = Get.find<BookingController>();
    final initial = isPickup
        ? LatLng(_pickupLat ?? booking.pickupLat, _pickupLng ?? booking.pickupLng)
        : LatLng(_destLat ?? booking.destLat, _destLng ?? booking.destLng);

    final result = await Get.to(() => LocationPickerScreen(
          initialCenter: initial,
          title: isPickup ? 'اختر نقطة الانطلاق' : 'اختر الوجهة',
          pinColor: isPickup ? AppColors.primaryTeal : AppColors.danger,
        ));

    if (result is PickedLocation) {
      setState(() {
        if (isPickup) {
          _pickupLat = result.point.latitude;
          _pickupLng = result.point.longitude;
          _pickup.text = result.name;
        } else {
          _destLat = result.point.latitude;
          _destLng = result.point.longitude;
          _dest.text = result.name;
        }
      });
    }
  }

  void _startBooking() {
    if (_dest.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'اختر وجهتك أولاً',
          backgroundColor: Colors.amber.shade100,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final booking = Get.find<BookingController>();
    booking.reset();
    // نمرّر الإحداثيات المختارة (أو نُبقي الافتراضي إن لم يختر المستخدم).
    booking.pickupLat = _pickupLat ?? booking.pickupLat;
    booking.pickupLng = _pickupLng ?? booking.pickupLng;
    booking.destLat = _destLat ?? booking.destLat;
    booking.destLng = _destLng ?? booking.destLng;
    booking.pickupAddress =
        _pickup.text.trim().isEmpty ? 'نقطة الانطلاق الحالية' : _pickup.text.trim();
    booking.destAddress = _dest.text.trim();
    Get.to(() => const CarTypeSelectionScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<HomeController>(
                builder: (c) => Text(
                  c.userName.isEmpty ? 'أهلاً بك' : 'صباح الخير، ${c.userName}',
                  style: AppStyles.headingBold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('إلى أين تريد الذهاب اليوم؟', style: AppStyles.bodyRegular),
              const SizedBox(height: 24),

              // بطاقة إدخال الرحلة
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    _locationField(_pickup, 'نقطة الانطلاق', Icons.my_location,
                        AppColors.primaryTeal,
                        () => _openPicker(isPickup: true)),
                    const Divider(height: 20),
                    _locationField(_dest, 'إلى أين؟', Icons.location_on,
                        AppColors.danger, () => _openPicker(isPickup: false)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _startBooking,
                  icon: const Icon(Icons.add, color: AppColors.textMain),
                  label: const Text('احجز رحلة جديدة', style: AppStyles.buttonText),
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
    );
  }

  Widget _locationField(TextEditingController c, String hint, IconData icon,
      Color color, VoidCallback onTap) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          // readOnly + onTap: النقر يفتح الخريطة بدل لوحة المفاتيح.
          child: TextField(
            controller: c,
            readOnly: true,
            onTap: onTap,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
        const Icon(Icons.map_outlined, size: 18, color: AppColors.textSecondary),
      ],
    );
  }
}
