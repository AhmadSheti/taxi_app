import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/blocked_drivers_controller.dart';

class BlockedDriversScreen extends StatelessWidget {
  const BlockedDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlockedDriversController>(
      init: BlockedDriversController()..fetchBlocked(),
      builder: (c) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('السائقون المحظورون'),
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textMain,
            elevation: 0,
          ),
          body: c.isLoading
              ? const Center(child: CircularProgressIndicator())
              : c.blocked.isEmpty
                  ? const Center(
                      child: Text('لا يوجد سائقون محظورون',
                          style: TextStyle(color: AppColors.textSecondary)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: c.blocked.length,
                      itemBuilder: (_, i) => _card(c, c.blocked[i]),
                    ),
        ),
      ),
    );
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Widget _card(BlockedDriversController c, Map<String, dynamic> item) {
    // السيرفر يُعيد بيانات السائق داخل كائن "blocked"، ومعرّفه في "blocked_id".
    final driver = item['blocked'] is Map
        ? Map<String, dynamic>.from(item['blocked'] as Map)
        : null;
    final int driverId = _toInt(item['blocked_id'] ?? driver?['id']);
    final String name = (driver?['name'] ?? item['name'] ?? 'سائق').toString();
    final String? reason = item['reason']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardWhite, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryTeal,
            child: Text(name.isNotEmpty ? name.substring(0, 1) : '؟',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.textMain)),
                if (reason != null && reason.isNotEmpty)
                  Text('السبب: $reason', style: AppStyles.bodyRegular),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: driverId == 0 ? null : () => c.unblock(driverId),
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryTeal)),
            child: const Text('إلغاء الحظر',
                style: TextStyle(color: AppColors.primaryTeal)),
          ),
        ],
      ),
    );
  }
}
