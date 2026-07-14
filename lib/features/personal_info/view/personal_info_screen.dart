import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/personal_info_controller.dart';

/// صفحة «معلوماتي» — تعديل بيانات السائق (الاسم/البريد/الهاتف).
class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<PersonalInfoController>(
        init: PersonalInfoController()..load(),
        builder: (c) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('معلوماتي'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: c.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _field('الاسم الكامل', c.nameController, Icons.person_outline),
                    const SizedBox(height: 16),
                    _field('البريد الإلكتروني', c.emailController,
                        Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _field('رقم الهاتف', c.phoneController,
                        Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: c.isSaving ? null : c.save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: c.isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppColors.primary),
                              )
                            : const Text('حفظ التغييرات',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
