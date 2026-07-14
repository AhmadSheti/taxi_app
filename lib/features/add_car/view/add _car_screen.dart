import 'dart:io'; // مطلوب للتعامل مع ملف الصورة المحملة
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // استيراد مكتبة التقاط الصور

import '../controller/add_car_controller.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _carFormKey = GlobalKey<FormState>();

  // نُنشئ الكنترولر هنا ونسجّله عبر GetBuilder(init: ...).
  final AddCarController controller = AddCarController();

  // متغير لحفظ ملف الصورة المحددة من قبل السائق
  File? _carImage;

  @override
  void initState() {
    super.initState();
    // تحميل أنواع السيارات عند فتح الشاشة.
    controller.loadCarTypes();
  }

  // دالة لفتح الاستوديو واختيار صورة
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // التقاط صورة من معرض الصور (Gallery)
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _carImage = File(pickedFile.path); // حفظ مسار الصورة لتحديث الواجهة
        controller.carImage = _carImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GetBuilder<AddCarController>(
          init: controller,
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _carFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "الخطوة ٢ من ٢",
                      style: TextStyle(color: Colors.teal, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "سيارتك",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Colors.black12,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 20),

                    // مربع رفع الصورة التفاعلي
                    GestureDetector(
                      onTap: _pickImage, // استدعاء دالة فتح المعرض عند الضغط
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xffF7F7F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black12,
                            style: BorderStyle.solid,
                          ),
                          // إذا تم اختيار صورة، يتم عرضها كخلفية للمربع
                          image: _carImage != null
                              ? DecorationImage(
                                  image: FileImage(_carImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _carImage == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 44,
                                    color: Colors.teal,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "اضغط هنا لإضافة صورة السيارة",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : null, // يختفي النص والأيقونة إذا ظهرت الصورة المرفوعة
                      ),
                    ),
                    const SizedBox(height: 24), // حقل رقم اللوحة التفاعلي المرتفع
                    _buildAnimatedCarField(
                      labelText: "رقم اللوحة",
                      controller: controller.plateController,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? "الرجاء إدخال رقم اللوحة"
                          : null,
                    ),

                    // صف الماركة والموديل بأنيميشن مرتفع
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildAnimatedCarField(
                            labelText: "الماركة",
                            controller: controller.brandController,
                            validator: (val) =>
                                (val == null || val.trim().isEmpty)
                                ? "مطلوب"
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAnimatedCarField(
                            labelText: "الموديل",
                            controller: controller.modelController,
                            validator: (val) =>
                                (val == null || val.trim().isEmpty)
                                ? "مطلوب"
                                : null,
                          ),
                        ),
                      ],
                    ),

                    // صف السنة واللون بأنيميشن مرتفع
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildAnimatedCarField(
                            labelText: "السنة",
                            controller: controller.yearController,
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val == null || val.trim().isEmpty)
                                ? "مطلوب"
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAnimatedCarField(
                            labelText: "اللون",
                            controller: controller.colorController,
                            validator: (val) =>
                                (val == null || val.trim().isEmpty)
                                ? "مطلوب"
                                : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "نوع السيارة",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // خيارات نوع السيارة (تُجلب من السيرفر)
                    _buildCarTypeSelector(controller),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                // التحقق من الحقول ثم الإرسال.
                                if (_carFormKey.currentState!.validate()) {
                                  controller.submit();
                                }
                              },
                        child: controller.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "إكمال التسجيل",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // منتقي نوع السيارة: يبني الخيارات من القائمة القادمة من السيرفر.
  Widget _buildCarTypeSelector(AddCarController controller) {
    if (controller.carTypes.isEmpty) {
      if (controller.isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(color: Colors.teal, strokeWidth: 2.5),
            ),
          ),
        );
      }
      return const Align(
        alignment: Alignment.centerRight,
        child: Text(
          "لا توجد أنواع سيارات متاحة",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.carTypes.map((type) {
        final int? id = type['id'] as int?;
        final String name = (type['type_name'] ?? '').toString();
        final bool isSelected = controller.selectedCarTypeId == id;
        return GestureDetector(
          onTap: () => controller.selectCarType(id),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xffE0F2F1)
                  : const Color(0xffF7F7F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? Colors.teal : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.teal : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnimatedCarField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: const Color(0xffF7F7F9),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
