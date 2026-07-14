import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../core/models/car_type_model.dart';
import '../../booking/controller/booking_controller.dart';
import '../../ride_confirmation/view/ride_confirmation_screen.dart';

class CarTypeSelectionScreen extends StatefulWidget {
  const CarTypeSelectionScreen({super.key});

  @override
  State<CarTypeSelectionScreen> createState() => _CarTypeSelectionScreenState();
}

class _CarTypeSelectionScreenState extends State<CarTypeSelectionScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<BookingController>().fetchCarTypes();
  }

  IconData _icon(String type) {
    switch (type) {
      case 'Luxury':
        return Icons.directions_car;
      case 'Comfort':
        return Icons.local_taxi;
      default:
        return Icons.airport_shuttle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('اختر نوع السيارة'),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textMain,
          elevation: 0,
        ),
        body: GetBuilder<BookingController>(
          builder: (c) {
            if (c.loadingCarTypes) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text('الأسعار تقديرية وقد تتغيّر', style: AppStyles.bodyRegular),
                      const SizedBox(height: 12),
                      ...c.carTypes.map((t) => _carTile(c, t)),
                    ],
                  ),
                ),
                _bottomBar(c),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _carTile(BookingController c, CarTypeModel t) {
    final selected = c.selectedCarType?.id == t.id;
    return GestureDetector(
      onTap: () => c.selectCarType(t),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondaryAmber.withValues(alpha: 0.15) : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.secondaryAmber : Colors.black.withValues(alpha: 0.06),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(_icon(t.typeName), size: 34, color: AppColors.primaryTeal),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.arabicName,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain)),
                  if (t.description != null)
                    Text(t.description!, style: AppStyles.bodyRegular),
                ],
              ),
            ),
            Text('${t.baseFare.toStringAsFixed(0)} ل.س',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(BookingController c) {
    final total = c.estimate?['total_fare'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (total != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('السعر التقديري',
                        style: TextStyle(color: AppColors.textSecondary)),
                    Text('${(total is num ? total : double.tryParse('$total') ?? 0).toStringAsFixed(0)} ل.س',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain)),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: c.selectedCarType == null
                    ? null
                    : () => Get.to(() => const RideConfirmationScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryAmber,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('متابعة', style: AppStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
