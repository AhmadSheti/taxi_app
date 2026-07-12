import 'package:flutter/material.dart';
import 'constants.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // النصوص الرسمية المعتمدة في دليل مشروع مشوار
  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'اطلب رحلتك بضغطة',
      'desc':
          'أوِقف سيارة أجرة من هاتفك واخرت سائقك بنفسك من بني عشرات السائقني القريبني منك.',
    },
    {
      'title': 'تتّبع سائقك مباشرة',
      'desc':
          'شاهد سيارتك تقترب على الخريطة بدقة، واعرف الوقت المتبقي على وصولها.',
    },
    {
      'title': 'ادفع نقداً بسهولة',
      'desc':
          'بدون بطاقات ولا تعقيدات. ادفع للسائق نقداً بعد انتهاء الرحلة، بالعملة المحلية.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // الخلفية الهادئة E4EEF1 أو F8F9FA
      body: SafeArea(
        // استخدام Directionality لضمان الاتجاه العربي RTL
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // زر تخطي في الأعلى
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'تخطّي',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // الشرائح المتغيرة المعتمدة على الـ PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // أيقونات معبرة ومؤقتة لكل شريحة داخل دائرة فيروزية خفيفة
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: AppColors.primaryTeal.withOpacity(
                              0.08,
                            ),
                            child: Icon(
                              index == 0
                                  ? Icons.local_taxi_rounded
                                  : index == 1
                                  ? Icons.map_rounded
                                  : Icons.payments_rounded,
                              size: 60,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                          const SizedBox(height: 50),
                          // العنوان الرئيسي للشريحة
                          Text(
                            _onboardingData[index]['title']!,
                            style: AppStyles.headingBold,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // الوصف الفرعي للشريحة
                          Text(
                            _onboardingData[index]['desc']!,
                            style: AppStyles.bodyRegular,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // الجزء السفلي: العداد الرقمي وزر التفاعل
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // العداد الرقمي المكتوب بالأرقام الغربية النظامية (1 / 3)
                    Text(
                      '${_currentPage + 1} / 3',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),

                    // زر التالي / ابدأ الآن الديناميكي
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.secondaryAmber, // الزر الذهبي
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? 'ابدأ الآن'
                            : 'التالي',
                        style: AppStyles.buttonText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
