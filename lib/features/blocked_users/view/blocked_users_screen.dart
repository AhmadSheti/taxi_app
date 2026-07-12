import 'package:flutter/material.dart';
import '../../notifications/view/notifications_screen.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الزبائن المحظورون")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBlockedUser( context,"مصطفى الحلبي", "سلوك غير لائق", "2 مايو"),
          _buildBlockedUser( context,"هاني المصري", "لم يدفع كامل المبلغ", "22 أبريل"),
        ],
      ),
    );
  }

  Widget _buildBlockedUser  
  (  BuildContext context  ,String name, String reason, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(child: Text(name[0])),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("السبب: $reason\nتم الحظر في: $date"),
        trailing: TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
          child: const Text("إلغاء"),
        ),
      ),
    );
  }
}
