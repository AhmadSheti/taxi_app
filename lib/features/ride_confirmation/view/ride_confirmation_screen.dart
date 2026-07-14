import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../booking/controller/booking_controller.dart';
import '../../booking/view/tracking_screen.dart';

class RideConfirmationScreen extends StatelessWidget {
  const RideConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discountCtrl = TextEditingController();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('مراجعة وتأكيد'),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textMain,
          elevation: 0,
        ),
        body: GetBuilder<BookingController>(
          builder: (c) {
            final e = c.estimate ?? {};
            num n(String k) {
              final v = e[k];
              return v is num ? v : double.tryParse('$v') ?? 0;
            }

            // رمز العملة يأتي من الـ backend (إعداد app_currency)، افتراضياً ل.س.
            final currency = (e['currency'] ?? 'ل.س').toString();
            // صياغة موحّدة للمبالغ المالية فقط.
            String money(String k) => '${n(k).toStringAsFixed(0)} $currency';

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // السائق
                      if (c.selectedDriver != null)
                        _card(Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primaryTeal,
                              child: Text(c.selectedDriver!.initial,
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.selectedDriver!.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textMain)),
                                  Text(c.selectedCarType?.arabicName ?? '',
                                      style: AppStyles.bodyRegular),
                                ],
                              ),
                            ),
                            if (c.selectedDriver!.plateNumber != null)
                              Text(c.selectedDriver!.plateNumber!,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        )),
                      const SizedBox(height: 12),

                      // كود الخصم
                      _card(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('كود الخصم',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMain)),
                          const SizedBox(height: 8),
                          if (c.appliedDiscountCode != null)
                            Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppColors.success, size: 20),
                                const SizedBox(width: 8),
                                Text('${c.appliedDiscountCode} (${c.discountPercentage?.toStringAsFixed(0)}%)',
                                    style: const TextStyle(color: AppColors.success)),
                                const Spacer(),
                                TextButton(
                                    onPressed: c.removeDiscount,
                                    child: const Text('إزالة',
                                        style: TextStyle(color: AppColors.danger))),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: discountCtrl,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                        hintText: 'أدخل الكود', isDense: true),
                                  ),
                                ),
                                TextButton(
                                  onPressed: c.validatingDiscount
                                      ? null
                                      : () => c.validateDiscount(discountCtrl.text),
                                  child: c.validatingDiscount
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('تطبيق'),
                                ),
                              ],
                            ),
                        ],
                      )),
                      const SizedBox(height: 12),

                      // معلومات الرحلة (مسافة ومدة — قيم فيزيائية وليست مبالغ مالية)
                      _card(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _info(Icons.straighten,
                              '${n('distance_km').toStringAsFixed(1)} كم', 'المسافة'),
                          Container(width: 1, height: 38, color: Colors.black12),
                          _info(Icons.schedule,
                              '${n('duration_minutes').toStringAsFixed(0)} دقيقة', 'المدة التقديرية'),
                        ],
                      )),
                      const SizedBox(height: 12),

                      // تفاصيل الأجرة (مبالغ مالية فقط)
                      _card(Column(
                        children: [
                          _row('الأجرة الأساسية', money('base_fare')),
                          _row('أجرة المسافة (${n('distance_km').toStringAsFixed(1)} كم)',
                              money('distance_fare')),
                          if (n('discount_amount') > 0)
                            _row('الخصم', '- ${money('discount_amount')}',
                                color: AppColors.success),
                          const Divider(),
                          _row('المجموع', money('total_fare'), bold: true),
                        ],
                      )),
                    ],
                  ),
                ),
                _confirmBar(c),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _card(Widget child) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.cardWhite, borderRadius: BorderRadius.circular(16)),
        child: child,
      );

  // عنصر معلومة رحلة (أيقونة + قيمة + وصف) — للمسافة والمدة.
  Widget _info(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryTeal, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  color: color ?? AppColors.textMain,
                  fontSize: bold ? 18 : 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _confirmBar(BookingController c) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppColors.cardWhite),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: c.submitting
                ? null
                : () async {
                    final rideId = await c.createRide();
                    if (rideId != null) {
                      Get.off(() => TrackingScreen(rideId: rideId));
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryAmber,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: c.submitting
                ? const SizedBox(
                    width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('تأكيد الطلب', style: AppStyles.buttonText),
          ),
        ),
      ),
    );
  }
}
