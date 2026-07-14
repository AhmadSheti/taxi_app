import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../home/view/home_shell.dart';

class TripCancelledScreen extends StatelessWidget {
  const TripCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: AppColors.danger, size: 56),
                ),
                const SizedBox(height: 20),
                const Text('تم إلغاء الرحلة', style: AppStyles.headingBold),
                const SizedBox(height: 8),
                const Text('نأسف لذلك. يمكنك طلب رحلة جديدة في أي وقت.',
                    textAlign: TextAlign.center, style: AppStyles.bodyRegular),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Get.offAll(() => const HomeShell()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryAmber,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('العودة للرئيسية', style: AppStyles.buttonText),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
