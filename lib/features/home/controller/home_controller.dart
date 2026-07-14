import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

/// كنترولر الشاشة الرئيسية: يجلب اسم المستخدم للترحيب،
/// ويحمل تبويب شريط التنقّل الحالي كي تتمكّن التبويبات من التنقّل بينها
/// (مثلاً زر الرجوع في صفحة الإشعارات يعيدنا إلى تبويب الرئيسية).
class HomeController extends GetxController {
  String userName = '';

  // تبويب شريط التنقّل السفلي الحالي (0: الرئيسية، 1: رحلاتي، 2: الإشعارات، 3: حسابي).
  int tab = 0;

  void changeTab(int index) {
    if (index == tab) return;
    tab = index;
    update();
  }

  Future<void> fetchProfile() async {
    final res = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.profile,
    );
    res.fold((_) {}, (data) {
      userName = data['data']?['name'] ?? '';
      update();
    });
  }
}
