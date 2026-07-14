import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/report_issue_controller.dart';

class ReportIssueScreen extends StatefulWidget {
  final int reportedId;
  final int? rideId;
  final String? driverName;

  const ReportIssueScreen({
    super.key,
    required this.reportedId,
    this.rideId,
    this.driverName,
  });

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _desc = TextEditingController();
  String _reason = 'قيادة غير آمنة';

  final _reasons = const [
    'قيادة غير آمنة',
    'سلوك غير لائق',
    'أجرة غير صحيحة',
    'نظافة السيارة',
    'أخرى',
  ];

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ReportIssueController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('الإبلاغ عن مشكلة'),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textMain,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.driverName != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('البلاغ عن: ${widget.driverName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.textMain)),
                ),
              const SizedBox(height: 16),
              const Text('سبب البلاغ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _reasons
                    .map((r) => ChoiceChip(
                          label: Text(r),
                          selected: _reason == r,
                          onSelected: (_) => setState(() => _reason = r),
                          selectedColor: AppColors.secondaryAmber,
                          backgroundColor: AppColors.cardWhite,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('الوصف',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
              const SizedBox(height: 10),
              TextField(
                controller: _desc,
                maxLines: 5,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'اشرح المشكلة بالتفصيل (10 أحرف على الأقل)',
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
                child: GetBuilder<ReportIssueController>(
                  builder: (ctrl) => ElevatedButton(
                    onPressed: ctrl.isSending
                        ? null
                        : () async {
                            final text = '$_reason: ${_desc.text.trim()}';
                            if (_desc.text.trim().length < 4) {
                              Get.snackbar('تنبيه', 'اكتب وصفاً كافياً',
                                  backgroundColor: Colors.amber.shade100,
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }
                            final ok = await ctrl.submit(
                              reportedId: widget.reportedId,
                              rideId: widget.rideId,
                              description: text,
                            );
                            if (ok) {
                              Get.back();
                              Get.snackbar('تم', 'تم إرسال البلاغ، ستتم مراجعته',
                                  backgroundColor: Colors.green.shade100,
                                  snackPosition: SnackPosition.BOTTOM);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: ctrl.isSending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('إرسال البلاغ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
