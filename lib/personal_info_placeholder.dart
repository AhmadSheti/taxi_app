import 'package:flutter/material.dart';

class PersonalInfoPlaceholder extends StatelessWidget {
  const PersonalInfoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("معلوماتي")),
      body: const Center(child: Text("صفحة تحديث البيانات الشخصية قيد التطوير")),
    );
  }
}