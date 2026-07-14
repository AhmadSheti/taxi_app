import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../booking/controller/booking_controller.dart';
import '../../home/view/home_shell.dart';

class RateDriverScreen extends StatefulWidget {
  final int rideId;
  const RateDriverScreen({super.key, required this.rideId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  int _score = 5;
  final _comment = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _sending = true);
    final ok = await Get.find<BookingController>().rate(widget.rideId, _score, _comment.text.trim());
    setState(() => _sending = false);
    if (ok) {
      Get.offAll(() => const HomeShell());
      Get.snackbar('شكراً', 'تم إرسال تقييمك',
          backgroundColor: Colors.green.shade100, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = Get.find<BookingController>().currentRide;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Icon(Icons.check_circle, color: AppColors.success, size: 64),
                const SizedBox(height: 12),
                const Text('وصلت بسلامة 🎉', style: AppStyles.headingBold),
                if (ride?.finalFare != null) ...[
                  const SizedBox(height: 4),
                  Text('الأجرة: ${ride!.finalFare!.toStringAsFixed(0)} ل.س',
                      style: AppStyles.bodyRegular),
                ],
                const SizedBox(height: 28),
                Text('كيف كانت رحلتك مع ${ride?.driverName ?? 'السائق'}؟',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final star = i + 1;
                    return IconButton(
                      onPressed: () => setState(() => _score = star),
                      icon: Icon(
                        star <= _score ? Icons.star : Icons.star_border,
                        color: AppColors.secondaryAmber,
                        size: 40,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _comment,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'أضف تعليقاً (اختياري)',
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _sending ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryAmber,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('إرسال التقييم', style: AppStyles.buttonText),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.offAll(() => const HomeShell()),
                  child: const Text('تخطّي', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
