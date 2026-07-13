import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الملف الشخصي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: controller.fetchProfile,
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: GetBuilder<ProfileController>(
            builder: (controller) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.fetchProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                          ),
                          child: const Text('حاول مرة أخرى'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    _buildHeader(controller),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildProfileForm(controller),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildProfileMenu(controller),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileController controller) {
    final name = controller.nameController.text.trim();
    final initial = name.isNotEmpty ? name[0] : 'أ';
    final memberSinceText = controller.memberSince.isNotEmpty
        ? 'عضو منذ ${controller.memberSince}'
        : 'عضو منذ سنة';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48),
              const Text(
                'مرحباً بك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: controller.fetchProfile,
                child: const Icon(Icons.sync, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name.isNotEmpty ? name : 'العميل',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    memberSinceText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.accentYellow,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(controller.favoritesCount, 'مفضلون'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(controller.ratingAverage, 'تقييم'),
              ),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard(controller.ridesCount, 'رحلة')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(ProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.successMessage.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              controller.successMessage,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (controller.errorMessage.isNotEmpty && controller.hasError)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              controller.errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        _buildTextField(
          controller: controller.nameController,
          label: 'الاسم',
          hint: 'أدخل اسمك',
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: controller.emailController,
          label: 'البريد الإلكتروني',
          hint: 'example@mail.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: controller.phoneController,
          label: 'رقم الجوال',
          hint: '٠٩٥xxxxxxxx',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: controller.avatarController,
          label: 'رابط الصورة الشخصية',
          hint: 'https://...jpg',
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: controller.isSubmitting ? null : controller.updateProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.3,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'حفظ التعديلات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.textGrey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.textGrey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primaryDark),
        ),
      ),
    );
  }

  Widget _buildProfileMenu(ProfileController controller) {
    return Column(
      children: [
        _buildMenuContainer([
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'حسابي',
            trailing: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textGrey,
            ),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuItem(
            icon: Icons.badge_outlined,
            title: 'بيانات شخصية',
            showArrow: true,
            onTap: () {},
          ),
        ]),
        const SizedBox(height: 16),
        _buildMenuContainer([
          _buildMenuItem(
            icon: Icons.favorite_border,
            title: 'الأماكن المفضلة',
            trailing: Text(
              controller.favoritesCount,
              style: const TextStyle(color: AppColors.textGrey),
            ),
            showArrow: true,
            onTap: () {},
          ),
        ]),
        const SizedBox(height: 16),
        _buildMenuContainer([
          _buildMenuItem(
            icon: Icons.notifications_none,
            title: 'الإشعارات',
            showArrow: true,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuItem(
            icon: Icons.language,
            title: 'اللغة',
            trailing: const Text(
              'العربية',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
            showArrow: true,
            onTap: () {},
          ),
        ]),
        const SizedBox(height: 16),
        _buildMenuContainer([
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'المساعدة والدعم',
            showArrow: true,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            titleColor: Colors.red,
            iconColor: Colors.red,
            showArrow: true,
            onTap: () {},
          ),
        ]),
        const SizedBox(height: 24),
        const Text(
          'إصدار ١.٤.٢ مشوار',
          style: TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ويدجت مخصصة لبناء كروت الإحصائيات الصغيرة
  Widget _buildStatCard(String value, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // حاوية موحدة لإعطاء تأثير المجموعات (Grouped Sections) كالحواف الدائرية والظل
  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // عنصر القائمة الفردي المخصص لتسهيل إعادة الاستخدام والتعديل
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color titleColor = AppColors.textDark,
    Color iconColor = AppColors.primaryDark,
    Widget? trailing,
    bool showArrow = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          if (trailing != null && showArrow) const SizedBox(width: 8),
          if (showArrow)
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textGrey,
              size: 14,
            ),
        ],
      ),
    );
  }
}
