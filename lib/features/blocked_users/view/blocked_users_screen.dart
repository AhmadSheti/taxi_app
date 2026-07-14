import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/blocked_users_controller.dart';
import '../model/blocked_user_model.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<BlockedUsersController>(
        initState: (_) => Get.find<BlockedUsersController>().load(),
        builder: (controller) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text("الزبائن المحظورون")),
          body: _buildBody(controller),
        ),
      ),
    );
  }

  Widget _buildBody(BlockedUsersController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.users.isEmpty) {
      return const Center(
        child: Text(
          "لا يوجد مستخدمون محظورون",
          style: TextStyle(color: AppColors.textGrey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        return _buildBlockedUser(controller, controller.users[index]);
      },
    );
  }

  Widget _buildBlockedUser(
      BlockedUsersController controller, BlockedUserModel user) {
    final reason = (user.reason == null || user.reason!.isEmpty)
        ? "غير محدد"
        : user.reason!;
    final subtitle = StringBuffer("السبب: $reason");
    if (user.blockedAt != null && user.blockedAt!.isNotEmpty) {
      subtitle.write("\nتم الحظر في: ${user.blockedAt}");
    }

    return Card(
      color: AppColors.cardWhite,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            user.name.isNotEmpty ? user.name[0] : "؟",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle.toString()),
        trailing: TextButton(
          onPressed: () => controller.unblock(user.customerId),
          child: const Text(
            "إلغاء الحظر",
            style: TextStyle(color: AppColors.danger),
          ),
        ),
      ),
    );
  }
}
