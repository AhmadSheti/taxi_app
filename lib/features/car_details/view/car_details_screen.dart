import 'package:flutter/material.dart';
import '../../blocked_users/view/blocked_users_screen.dart';
class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // لون الخلفية في الصورة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("سيارتي", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // حاوية صورة السيارة
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.directions_car, size: 80, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            
            // حاوية رقم اللوحة
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text("DAM 7752", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ),
            const SizedBox(height: 20),
            
            // تفاصيل السيارة (المعلومات)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildDetailRow("الماركة", "هيونداي"),
                  const Divider(),
                  _buildDetailRow("الموديل", "إنترا"),
                  const Divider(),
                  _buildDetailRow("السنة", "2020"),
                  const Divider(),
                  _buildDetailRow("اللون", "أبيض"),
                  const Divider(),
                  _buildDetailRow("نوع السيارة", "مريح"),
                  const Divider(),
                  _buildDetailRow("عدد المقاعد", "4 مقاعد"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت لتصميم سطر المعلومة
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}