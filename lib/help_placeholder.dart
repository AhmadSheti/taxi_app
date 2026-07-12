import 'package:flutter/material.dart';

class HelpPlaceholder extends StatelessWidget {
  const HelpPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المساعدة والدعم")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "نسعد بخدمتك. يمكنك التواصل مع فريق الدعم الفني عبر البريد الإلكتروني أو مركز المساعدة المباشر.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}