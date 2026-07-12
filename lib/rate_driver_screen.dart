import 'package:flutter/material.dart';
import 'constants.dart';

class RateDriverScreen extends StatefulWidget {
  const RateDriverScreen({Key? key}) : super(key: key);

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  int selectedStars = 5;
  List<String> selectedChips = [];

  final List<String> tags = ['سرعة', 'نظافة المركبة', 'قيادة آمنة', 'تعامل لطيف', 'دقة في الموعد'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName('/')), // العودة للرئيسية كافتراضي تالي
            child: const Text(
              'تخطّي',
              style: TextStyle(fontFamily: 'Cairo', color: Color(0xFF0F4C5C), fontWeight: FontWeight.bold),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'كيف كانت رحلتك مع سامر؟',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              ),
              const Text(
                'تقييمك يساعدنا على تحسين جودة خدمات مشوار دائمًا',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Color(0xFF7A7A8C)),
              ),
              const SizedBox(height: 24),

              // النجوم التفاعلية المضيئة باللون الذهبي المعتمد
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedStars ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 40,
                      color: const Color(0xFFFFB627),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStars = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 30),

              const Text(
                'ما الذي أعجبك بشكل خاص؟',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 10),

              // وسوم سريعة Chips تفاعلية
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: tags.map((tag) {
                  final isSelected = selectedChips.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                    selected: isSelected,
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          selectedChips.add(tag);
                        } else {
                          selectedChips.remove(tag);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF0F4C5C),
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? const Color(0xFF0F4C5C) : Colors.grey.shade200),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // حقل نصي للتعليقات الاختيارية
              const Text(
                'شاركنا المزيد من التفاصيل (اختياري)',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'اكتب تجربتك هنا بوضوح وسرية...',
                  hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Color(0xFF7A7A8C)),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF0F4C5C)),
                  ),
                ),
              ),
              const Spacer(),

              // زر التأكيد الذهبي بحسب الدليل البصري للهوية
              ElevatedButton(
                onPressed: () {
                  // هنا يتم الإرسال البرمجي ثم الانتقال
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('شكراً لمشاركتنا تقييمك الودود!')),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB627),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'إرسال التقييم المعتمد',
                  style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1A1A2E)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}