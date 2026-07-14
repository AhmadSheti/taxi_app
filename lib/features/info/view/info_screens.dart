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
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (intro != null) ...[
              Text(intro!, style: AppStyles.bodyRegular),
              const SizedBox(height: 18),
            ],
            for (final s in sections) ...[
              if (s.heading != null) ...[
                Text(s.heading!,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal)),
                const SizedBox(height: 6),
              ],
              Text(s.body,
                  style: const TextStyle(
                      fontSize: 14, height: 1.8, color: AppColors.textMain)),
              const SizedBox(height: 18),
            ],
            const SizedBox(height: 8),
            const Center(
              child: Text('مشوار · Mishwar',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
          'خصوصيتك تهمّنا. توضّح هذه السياسة البيانات التي نجمعها منك في تطبيق مشوار، وكيف نستخدمها ونحميها.',
      sections: [
        InfoSection(
          heading: '١. البيانات التي نجمعها',
          body:
              'نجمع الاسم ورقم الهاتف والبريد الإلكتروني عند إنشاء الحساب، وموقعك الجغرافي أثناء استخدام الخدمة لتحديد نقطة الانطلاق والوجهة، بالإضافة إلى سجلّ رحلاتك ومدفوعاتك.',
        ),
        InfoSection(
          heading: '٢. كيف نستخدم بياناتك',
          body:
              'نستخدم بياناتك لمطابقتك مع أقرب سائق مناسب، وحساب أجرة الرحلة، وعرض مسارك على الخريطة، وتحسين جودة الخدمة، والتواصل معك بخصوص رحلاتك والدعم.',
        ),
        InfoSection(
          heading: '٣. مشاركة البيانات',
          body:
              'لا نبيع بياناتك لأي طرف. نشارك الحد الأدنى الضروري (الاسم ونقطة الالتقاء) مع السائق المرتبط برحلتك فقط، وقد نُفصح عنها للجهات القانونية عند وجود طلب رسمي.',
        ),
        InfoSection(
          heading: '٤. أمان المعلومات',
          body:
              'نحمي بياناتك عبر اتصال مُشفّر (HTTPS) وصلاحيات وصول محدودة. رغم ذلك، لا يمكن ضمان أمان مطلق لأي نقل عبر الإنترنت.',
        ),
        InfoSection(
          heading: '٥. حقوقك',
          body:
              'يمكنك تعديل بياناتك أو طلب حذف حسابك في أي وقت عبر صفحة «حسابي» أو بالتواصل مع الدعم. كما يمكنك التحكم بأذونات الموقع من إعدادات جهازك.',
        ),
        InfoSection(
          heading: '٦. التواصل',
          body:
              'لأي استفسار حول الخصوصية، راسلنا على privacy@mishwar.app.',
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
          'باستخدامك تطبيق مشوار فإنك توافق على الشروط التالية التي تنظّم العلاقة بينك وبين المنصّة.',
      sections: [
        InfoSection(
          heading: '١. طبيعة الخدمة',
          body:
              'مشوار منصّة وساطة تربط الركّاب بالسائقين. المنصّة ليست شركة نقل، والسائقون مستقلّون مسؤولون عن تنفيذ الرحلة.',
        ),
        InfoSection(
          heading: '٢. الحساب',
          body:
              'يجب أن تكون المعلومات التي تقدّمها صحيحة، وأنت مسؤول عن سرّية بيانات دخولك وعن كل نشاط يتم عبر حسابك.',
        ),
        InfoSection(
          heading: '٣. الأجرة والدفع',
          body:
              'تُحسب الأجرة وفق نوع السيارة والمسافة والوقت، وتُعرض تقديرياً قبل التأكيد وقد تختلف قليلاً. الدفع الحالي نقدي مباشرةً للسائق بعد انتهاء الرحلة.',
        ),
        InfoSection(
          heading: '٤. الإلغاء',
          body:
              'يمكنك إلغاء الطلب قبل قبوله بلا رسوم. قد تُطبَّق سياسة إلغاء بعد قبول السائق للحفاظ على حقوق الطرفين.',
        ),
        InfoSection(
          heading: '٥. سلوك المستخدم',
          body:
              'يُمنع استخدام الخدمة لأي غرض غير قانوني أو مسيء. نحتفظ بحق إيقاف الحسابات المخالفة.',
        ),
        InfoSection(
          heading: '٦. إخلاء المسؤولية',
          body:
              'نبذل جهدنا لتقديم خدمة موثوقة، لكننا لا نضمن خلوّها من الانقطاعات، ولا نتحمّل مسؤولية الأضرار الناتجة عن سوء استخدام الخدمة.',
        ),
        InfoSection(
          heading: '٧. التعديلات',
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
          heading: 'كيف أطلب رحلة؟',
          body:
              'من الشاشة الرئيسية اضغط حقل «نقطة الانطلاق» ثم «إلى أين» لاختيار الموقعين على الخريطة، ثم «احجز رحلة»، واختر نوع السيارة والسائق وأكّد الطلب.',
        ),
        InfoSection(
          heading: 'كيف أدفع؟',
          body:
              'الدفع نقدي حالياً، تدفعه مباشرةً للسائق بعد انتهاء الرحلة بالمبلغ الظاهر في التطبيق.',
        ),
        InfoSection(
          heading: 'كيف أُبلغ عن مشكلة في رحلة؟',
          body:
              'من سجلّ الرحلات افتح الرحلة المعنية واختر «الإبلاغ عن مشكلة»، أو راسل الدعم مباشرةً.',
        ),
        InfoSection(
          heading: 'التواصل معنا',
          body:
              'البريد: support@mishwar.app\nالهاتف: 137\nساعات العمل: يومياً من ٩ صباحاً حتى ١٢ منتصف الليل.',
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
          'مشوار تطبيق سوري لطلب سيارات الأجرة، يضع التحكّم في يدك: اختر سائقك، تابِع رحلتك على الخريطة، وادفع نقداً بسهولة.',
      sections: [
        InfoSection(
          heading: 'رؤيتنا',
          body:
              'تنقّل مريح وآمن وشفّاف يربط الركّاب بالسائقين القريبين بأفضل الأسعار المحلية.',
        ),
        InfoSection(
          heading: 'الإصدار',
          body: 'مشوار — العميل · الإصدار 1.0.0',
        ),
        InfoSection(
          heading: 'حقوق النشر',
          body: '© 2026 مشوار · جميع الحقوق محفوظة.',
        ),
      ],
    );
  }
}
