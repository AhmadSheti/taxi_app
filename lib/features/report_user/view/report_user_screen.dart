import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/report_user_controller.dart';

class ReportUserScreen extends StatelessWidget {
  const ReportUserScreen({super.key, this.reportedId = 1, this.rideId});

  /// معرّف المستخدم المُبلَّغ عنه.
  final int reportedId;

  /// معرّف الرحلة المرتبطة بالبلاغ (اختياري).
  final int? rideId;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<ReportUserController>(
        init: ReportUserController(),
        builder: (controller) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text("الإبلاغ عن زبون"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "سبب البلاغ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.reasons.map((reason) {
                    final selected = controller.selectedReason == reason;
                    return ChoiceChip(
                      label: Text(reason),
                      selected: selected,
                      onSelected: (_) => controller.selectReason(reason),
                      selectedColor: AppColors.accent,
                      backgroundColor: AppColors.cardWhite,
                      labelStyle: TextStyle(
                        color: selected ? AppColors.primary : AppColors.textGrey,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "وصف الحادثة",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "اكتب تفاصيل الحادثة هنا...",
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.submit(
                              reportedId: reportedId,
                              rideId: rideId,
                            ),
                    child: controller.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "إرسال البلاغ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
