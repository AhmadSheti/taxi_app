import 'package:flutter/material.dart';

import '../../../constants.dart';

/// قسم من صفحة معلومات: عنوان (اختياري) + نص.
class InfoSection {
  final String? heading;
  final String body;
  const InfoSection({this.heading, required this.body});
}

/// صفحة محتوى ثابتة قابلة لإعادة الاستخدام (خصوصية / شروط / مساعدة / عن التطبيق).
class InfoPage extends StatelessWidget {
  final String title;
  final String? intro;
  final List<InfoSection> sections;

  const InfoPage({
    super.key,
    required this.title,
    this.intro,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(title),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (intro != null) ...[
              Text(intro!,
                  style: const TextStyle(
                      fontSize: 15, height: 1.7, color: AppColors.textGrey)),
              const SizedBox(height: 18),
            ],
            for (final s in sections) ...[
              if (s.heading != null) ...[
                Text(s.heading!,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                const SizedBox(height: 6),
              ],
              Text(s.body,
                  style: const TextStyle(
                      fontSize: 14, height: 1.8, color: AppColors.textMain)),
              const SizedBox(height: 18),
            ],
            const SizedBox(height: 8),
            const Center(
              child: Text('مشوار سائق · Mishwar Driver',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

/// سياسة الخصوصية
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPage(
      title: 'سياسة الخصوصية',
      intro:
          'خصوصيتك تهمّنا. توضّح هذه السياسة البيانات التي نجمعها منك كسائق في تطبيق مشوار، وكيف نستخدمها ونحميها.',
      sections: [
        InfoSection(
          heading: '١. البيانات التي نجمعها',
          body:
              'نجمع اسمك ورقم هاتفك وبريدك ومعلومات سيارتك ووثائقها، وموقعك الجغرافي أثناء الاتصال لعرضك للركّاب القريبين وتتبّع الرحلة، بالإضافة إلى سجلّ رحلاتك وأرباحك وتقييماتك.',
        ),
        InfoSection(
          heading: '٢. كيف نستخدم بياناتك',
          body:
              'نستخدم بياناتك لعرضك للركّاب المناسبين، وتوجيه طلبات الرحلات إليك، وحساب أرباحك وعمولة المنصّة، وعرض مسارك على الخريطة، وتحسين جودة الخدمة.',
        ),
        InfoSection(
          heading: '٣. مشاركة البيانات',
          body:
              'لا نبيع بياناتك. نشارك اسمك وتقييمك ومعلومات سيارتك مع الراكب المرتبط برحلتك فقط، وقد نُفصح عنها للجهات القانونية عند وجود طلب رسمي.',
        ),
        InfoSection(
          heading: '٤. أمان المعلومات',
          body:
              'نحمي بياناتك عبر اتصال مُشفّر (HTTPS) وصلاحيات وصول محدودة.',
        ),
        InfoSection(
          heading: '٥. حقوقك',
          body:
              'يمكنك تعديل بياناتك من صفحة «معلوماتي»، أو طلب حذف حسابك بالتواصل مع الدعم، والتحكّم بأذونات الموقع من إعدادات جهازك.',
        ),
        InfoSection(
          heading: '٦. التواصل',
          body: 'لأي استفسار حول الخصوصية، راسلنا على privacy@mishwar.app.',
        ),
      ],
    );
  }
}

/// الشروط والأحكام
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPage(
      title: 'الشروط والأحكام',
      intro:
          'باستخدامك تطبيق مشوار سائق فإنك توافق على الشروط التالية التي تنظّم عملك على المنصّة.',
      sections: [
        InfoSection(
          heading: '١. طبيعة العلاقة',
          body:
              'أنت سائق مستقلّ، ومشوار منصّة وساطة تربطك بالركّاب. لست موظفاً لدى المنصّة، وأنت مسؤول عن تنفيذ الرحلة والالتزام بالأنظمة المرورية.',
        ),
        InfoSection(
          heading: '٢. الوثائق والمركبة',
          body:
              'يجب أن تكون وثائقك ورخصتك وتأمين مركبتك سارية وصحيحة، وأن تحافظ على سيارتك نظيفة وآمنة.',
        ),
        InfoSection(
          heading: '٣. العمولة والأرباح',
          body:
              'تحتسب المنصّة نسبة عمولة على كل رحلة مكتملة، ويظهر صافي ربحك في صفحة «الأرباح». تلتزم بتسديد العمولة المستحقة في مواعيدها.',
        ),
        InfoSection(
          heading: '٤. قبول ورفض الطلبات',
          body:
              'لك حرية قبول أو رفض الطلبات، لكن معدّل القبول والتقييم يؤثّران في ظهورك للركّاب.',
        ),
        InfoSection(
          heading: '٥. السلوك',
          body:
              'يُمنع أي سلوك غير لائق تجاه الركّاب. نحتفظ بحق إيقاف الحسابات المخالفة.',
        ),
        InfoSection(
          heading: '٦. التعديلات',
          body:
              'قد نُحدّث هذه الشروط من وقت لآخر، ويسري التحديث فور نشره داخل التطبيق.',
        ),
      ],
    );
  }
}

/// المساعدة والدعم
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPage(
      title: 'المساعدة والدعم',
      intro: 'نحن هنا لمساعدتك. تجد أدناه إجابات الأسئلة الشائعة وطرق التواصل معنا.',
      sections: [
        InfoSection(
          heading: 'كيف أستقبل الطلبات؟',
          body:
              'فعّل حالة «متصل» من الشاشة الرئيسية، وستصلك طلبات الرحلات القريبة لتقبلها أو ترفضها.',
        ),
        InfoSection(
          heading: 'كيف تُحسب أرباحي؟',
          body:
              'يُحسب صافي ربحك = أجرة الرحلة − عمولة المنصّة. تجد تفصيل أرباحك ومستحقّات العمولة في صفحتي «الأرباح» و«المحفظة والعمولة».',
        ),
        InfoSection(
          heading: 'كيف أضيف/أعدّل سيارتي؟',
          body:
              'من «حسابي» → «سيارتي» يمكنك عرض بيانات سيارتك، ومن التسجيل الأول تضيف سيارتك.',
        ),
        InfoSection(
          heading: 'التواصل معنا',
          body:
              'البريد: drivers@mishwar.app\nالهاتف: 137\nساعات العمل: يومياً من ٨ صباحاً حتى ١٢ منتصف الليل.',
        ),
      ],
    );
  }
}

/// عن التطبيق
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPage(
      title: 'عن التطبيق',
      intro:
          'مشوار سائق تطبيق يمكّنك من استقبال طلبات الركّاب القريبين، وإدارة رحلاتك وأرباحك بسهولة.',
      sections: [
        InfoSection(
          heading: 'رؤيتنا',
          body: 'دخل عادل للسائقين وتجربة تنقّل آمنة وشفّافة للركّاب.',
        ),
        InfoSection(heading: 'الإصدار', body: 'مشوار سائق · الإصدار 1.0.0'),
        InfoSection(
          heading: 'حقوق النشر',
          body: '© 2026 مشوار · جميع الحقوق محفوظة.',
        ),
      ],
    );
  }
}
