import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../core/models/ride_model.dart';
import '../../report_issue/view/report_issue_screen.dart';
import '../controller/history_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      init: HistoryController()..fetchRides(),
      builder: (c) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('رحلاتي',
                style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.background,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.textMain),
                tooltip: 'تحديث',
                onPressed: c.fetchRides,
              ),
            ],
          ),
          body: Column(
            children: [
              _filters(c),
              Expanded(child: _body(c)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filters(HistoryController c) {
    Widget chip(String label, String value) {
      final active = c.filter == value;
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          onSelected: (_) => c.setFilter(value),
          selectedColor: AppColors.primaryTeal,
          labelStyle: TextStyle(
              color: active ? Colors.white : AppColors.textMain,
              fontWeight: FontWeight.bold),
          backgroundColor: AppColors.cardWhite,
        ),
      );
    }

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          chip('الكل', 'all'),
          chip('مكتملة', 'completed'),
          chip('ملغاة', 'cancelled'),
        ],
      ),
    );
  }

  Widget _body(HistoryController c) {
    // مؤشّر التحميل الكامل يظهر فقط عند التحميل الأول (لا توجد بيانات).
    if (c.isLoading && c.rides.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      color: AppColors.primaryTeal,
      onRefresh: c.fetchRides,
      child: c.rides.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 140),
                Center(
                    child: Text('لا توجد رحلات',
                        style: TextStyle(color: AppColors.textSecondary))),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: c.rides.length,
              itemBuilder: (_, i) => _rideCard(c, c.rides[i]),
            ),
    );
  }

  Widget _rideCard(HistoryController c, RideModel r) {
    final Color statusColor = r.isCompleted
        ? AppColors.success
        : r.isCancelled
            ? AppColors.danger
            : AppColors.secondaryAmber;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardWhite, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(r.driverName ?? 'رحلة',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.textMain)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(r.statusLabel,
                    style: TextStyle(color: statusColor, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _line(Icons.circle, r.pickupAddress ?? '-', AppColors.primaryTeal),
          _line(Icons.location_on, r.destinationAddress ?? '-', AppColors.danger),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(r.finalFare ?? r.estimatedFare).toStringAsFixed(0)} ل.س',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.textMain)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (r.driverId != null) _blockButton(c, r),
                  if (r.isCompleted && r.driverId != null)
                    TextButton.icon(
                      onPressed: () => Get.to(() => ReportIssueScreen(
                            reportedId: r.driverId!,
                            rideId: r.id,
                            driverName: r.driverName,
                          )),
                      icon: const Icon(Icons.flag_outlined,
                          size: 16, color: AppColors.danger),
                      label: const Text('إبلاغ',
                          style: TextStyle(color: AppColors.danger, fontSize: 12)),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// زر حظر السائق: يعرض التحميل أثناء الطلب و"محظور" بعد نجاحه.
  Widget _blockButton(HistoryController c, RideModel r) {
    final int driverId = r.driverId!;
    final bool isBlocking = c.blockingDriverId == driverId;
    final bool isBlocked = c.blockedDriverIds.contains(driverId);

    if (isBlocked) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text('محظور',
            style: TextStyle(
                color: AppColors.danger,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      );
    }

    return TextButton.icon(
      onPressed: isBlocking ? null : () => _confirmBlock(c, r),
      icon: isBlocking
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.danger),
            )
          : const Icon(Icons.block, size: 16, color: AppColors.danger),
      label: const Text('حظر',
          style: TextStyle(color: AppColors.danger, fontSize: 12)),
    );
  }

  /// حوار تأكيد الحظر مع حقل سبب اختياري.
  Future<void> _confirmBlock(HistoryController c, RideModel r) async {
    final reasonCtrl = TextEditingController();
    final confirmed = await Get.dialog<bool>(
      Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حظر السائق'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'هل تريد حظر ${r.driverName ?? 'هذا السائق'}؟ '
                'لن تتم مطابقتك معه في الرحلات القادمة.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                maxLines: 2,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                    hintText: 'سبب الحظر (اختياري)', isDense: true),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('حظر', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await c.blockDriver(r.driverId!, reason: reasonCtrl.text.trim());
    }
  }

  Widget _line(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bodyRegular)),
        ],
      ),
    );
  }
}
