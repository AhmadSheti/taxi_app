# طريقة الربط في المشروع (GetX) — شرح للزملاء

هدفنا: ربط أي شاشة بالسيرفر بأبسط شكل. اتبع نفس القالب في كل مرة.

## 1) البنية (Structure)

```
lib/
├─ core/                      ← أشياء مشتركة بين كل الشاشات
│  ├─ network/
│  │  ├─ api_constants.dart   ← عنوان السيرفر + كل الروابط (Endpoints)
│  │  ├─ api_method.dart      ← أنواع الطلب (GET/POST/PUT/DELETE)
│  │  └─ api_service.dart     ← ملف واحد يرسل كل الطلبات (makeRequest)
│  ├─ storage/app_storage.dart ← حفظ التوكن محلياً
│  └─ app_binding.dart        ← نحقن كل الـ Controllers هنا (يُربط في main)
│
└─ features/                  ← كل ميزة/صفحة في مجلد مستقل
   ├─ auth/                   (تسجيل الدخول)
   │  ├─ model/user_model.dart
   │  ├─ controller/login_controller.dart
   │  └─ view/login_screen.dart
   └─ notifications/          (الإشعارات)
      ├─ model/notification_model.dart
      ├─ controller/notifications_controller.dart
      └─ view/notifications_screen.dart
```

**القاعدة:** كل ميزة = مجلد فيه ثلاثة أشياء:
- `model/`  → يحوّل JSON إلى كائن Dart (`fromJson`).
- `controller/` → كل المنطق (الطلبات + الحالة). يرث `GetxController`.
- `view/` → الواجهة فقط. لا يوجد منطق داخلها.

## 2) القواعد المتفق عليها

- **لا نستخدم `.obs`** ولا `Obx`. نستخدم متغيّرات عادية، وعند تغيّرها نستدعي `update()`.
- في الواجهة نراقب الحالة بـ **`GetBuilder<MyController>`** (يُعاد بناؤه عند `update()`).
- **لا نستخدم `onInit`.** لجلب البيانات عند فتح الشاشة نستخدم `GetBuilder(initState: ...)`.
- **كل الحقن في `main`** عبر `AppBinding` (`initialBinding: AppBinding()`)، والواجهة تستدعي الكنترولر بـ `Get.find<...>()` (وليس `Get.put`).

## 3) خطوات إضافة ميزة/شاشة جديدة

1. أضف الرابط في `core/network/api_constants.dart`.
2. أنشئ مجلد الميزة داخل `features/` وبداخله `model/ controller/ view/`.
3. في الـ **model**: اكتب `fromJson`.
4. في الـ **controller**: متغيّراتك + دالة تستدعي `ApiService.instance.makeRequest(...)`، ثم `result.fold(خطأ, نجاح)` مع `update()`.
5. في الـ **view**: `GetBuilder<Controller>` لعرض الحالة.
6. أضف الكنترولر في `core/app_binding.dart`.

## 4) شكل الطلب (نفسه في كل مكان)

```dart
final result = await ApiService.instance.makeRequest(
  method: ApiMethod.post,          // نوع الطلب
  endPoint: EndPoints.login,       // الرابط
  body: { 'email': ..., 'password': ... },
);

result.fold(
  (error) => Get.snackbar('خطأ', error), // Left = خطأ
  (data)  => ...,                        // Right = نجاح (JSON)
);
```

## 5) قبل التشغيل

- غيّر `baseUrl` في `core/network/api_constants.dart` لعنوان سيرفرك.
  (`10.0.2.2` = localhost لمحاكي أندرويد، أو ضع IP جهازك لجهاز حقيقي.)
