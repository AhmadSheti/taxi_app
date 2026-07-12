import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/notifications_controller.dart';
import '../model/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // ألوان الشاشة (هوية السائق)
  static const Color background = Color(0xfff7f9fa);
  static const Color unreadBackground = Color(0xFFFFFDF6);
  static const Color primary = Color(0xff0d3e46);
  static const Color textGrey = Color(0xFF757575);
  static const Color accent = Color(0xfffbc02d);

  @override
  Widget build(BuildContext context) {
    // الكنترولر محقون في main. GetBuilder يجده تلقائياً.
    // initState تُستدعى مرة واحدة عند ظهور الشاشة → نجلب الإشعارات (بدل onInit).
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<NotificationsController>(
        initState: (_) => Get.find<NotificationsController>().fetchNotifications(),
        builder: (controller) => Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: background,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: controller.markAllAsRead,
                  child: const Text('تحديد الكل كمقروء',
                      style: TextStyle(
                          color: primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
                const Text('الإشعارات',
                    style: TextStyle(
                        color: primary, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 40),
              ],
            ),
          ),
          body: _buildBody(controller),
        ),
      ),
    );
  }

  Widget _buildBody(NotificationsController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.notifications.isEmpty) {
      return const Center(
          child: Text('لا توجد إشعارات', style: TextStyle(color: textGrey)));
    }
    return RefreshIndicator(
      onRefresh: controller.fetchNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) => _buildCard(controller.notifications[index]),
      ),
    );
  }

  Widget _buildCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.white : unreadBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.notifications_outlined,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          color: primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(item.body,
                      style: const TextStyle(
                          color: textGrey, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            if (!item.isRead) ...[
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 8,
                height: 8,
                decoration:
                    const BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
