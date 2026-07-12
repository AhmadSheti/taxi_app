import 'package:flutter/material.dart';

class ReportUserScreen extends StatefulWidget {
  const ReportUserScreen({super.key});

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  bool blockUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإبلاغ عن زبون")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "وصف الحادثة", border: OutlineInputBorder())),
            SwitchListTile(
              title: const Text("حظر الزبون أيضاً"),
              value: blockUser,
              onChanged: (val) => setState(() => blockUser = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {},
              child: const Text("إرسال البلاغ", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}