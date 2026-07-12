import 'package:flutter/material.dart';
import 'report_user_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإشعارات"),
        actions: [
          TextButton(
            onPressed: () {
              print("تم الضغط على قراءة الكل");
            },
            child: const Text("قراءة الكل"),
          ),
        ], //ـactions
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotification("تذكير سداد العمولة", "المبلغ المستحق 48.43 ل.س"),
          _buildNotification("تقييم جديد", "أحمد العلي قيم رحلتك بـ 5 نجوم"),
        ],
      ),
    );
  }

  Widget _buildNotification(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.notifications_active, color: Colors.amber),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
