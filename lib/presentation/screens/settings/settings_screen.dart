import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehatak/presentation/bloc/theme_bloc/theme_bloc.dart' hide ThemeMode;
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/screens/auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsEnabled = true;
  bool _isBiometricEnabled = true;
  bool _isDataSaverEnabled = false;
  String _selectedLanguage = 'العربية';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ========= الملف الشخصي =========
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              const CircleAvatar(radius: 35, backgroundColor: Colors.white24, child: Text('أح', style: TextStyle(fontSize: 28, color: Colors.white))),
              const SizedBox(width: 14),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('أحمد محمد', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('ahmed@email.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 2),
                Text('📱 +967 777 123 456', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ])),
              IconButton(icon: const Icon(Icons.edit, color: Colors.white), onPressed: () {}),
            ]),
          ),
          const SizedBox(height: 22),

          // ========= الحساب =========
          _sectionTitle('الحساب'),
          _menuItem(Icons.person_outline, 'تعديل الملف الشخصي', 'الاسم، البريد، الهاتف', onTap: () {}),
          _menuItem(Icons.lock_outline, 'تغيير كلمة المرور', 'تحديث كلمة المرور', onTap: () {}),
          _menuItem(Icons.security, 'المصادقة الثنائية', 'تعزيز أمان حسابك', onTap: () {}),
          _menuItem(Icons.fingerprint, 'بصمة الإصبع', 'تسجيل الدخول بالبصمة', switchValue: _isBiometricEnabled, onSwitch: (v) => setState(() => _isBiometricEnabled = v)),
          _menuItem(Icons.delete_outline, 'حذف الحساب', 'حذف نهائي للبيانات', onTap: () {}, isDanger: true),
          const SizedBox(height: 22),

          // ========= التفضيلات =========
          _sectionTitle('التفضيلات'),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              bool isDark = false;
              if (state is ThemeLoadedState) isDark = state.themeMode == ThemeMode.dark;
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
                title: const Text('الوضع الليلي'),
                subtitle: const Text('تفعيل الوضع الداكن'),
                value: isDark,
                activeColor: AppColors.primary,
                onChanged: (v) => context.read<ThemeBloc>().add(SetThemeEvent(v)),
              );
            },
          ),
          _menuItem(Icons.notifications_active, 'الإشعارات', 'تفعيل التنبيهات', switchValue: _isNotificationsEnabled, onSwitch: (v) => setState(() => _isNotificationsEnabled = v)),
          _menuItem(Icons.language, 'اللغة', _selectedLanguage, onTap: () => _showLanguagePicker()),
          _menuItem(Icons.storage, 'توفير البيانات', 'تقليل استهلاك البيانات', switchValue: _isDataSaverEnabled, onSwitch: (v) => setState(() => _isDataSaverEnabled = v)),
          _menuItem(Icons.font_download, 'حجم الخط', 'متوسط', onTap: () {}),
          _menuItem(Icons.color_lens, 'ثيم التطبيق', 'أخضر (افتراضي)', onTap: () {}),
          const SizedBox(height: 22),

          // ========= الخصوصية والأمان =========
          _sectionTitle('الخصوصية والأمان'),
          _menuItem(Icons.privacy_tip_outlined, 'سياسة الخصوصية', 'كيف نحمي بياناتك', onTap: () {}),
          _menuItem(Icons.description_outlined, 'الشروط والأحكام', 'شروط استخدام التطبيق', onTap: () {}),
          _menuItem(Icons.shield_outlined, 'الأذونات', 'إدارة أذونات التطبيق', onTap: () {}),
          _menuItem(Icons.download_done, 'تحميل بياناتي', 'تصدير جميع بياناتك', onTap: () {}),
          const SizedBox(height: 22),

          // ========= الدعم والمساعدة =========
          _sectionTitle('الدعم والمساعدة'),
          _menuItem(Icons.help_outline, 'مركز المساعدة', 'أسئلة شائعة', onTap: () {}),
          _menuItem(Icons.chat_outlined, 'تواصل معنا', 'راسل فريق الدعم', onTap: () {}),
          _menuItem(Icons.report_outlined, 'الإبلاغ عن مشكلة', 'ساعدنا في التحسين', onTap: () {}),
          _menuItem(Icons.rate_review_outlined, 'تقييم التطبيق', 'قيمنا على المتجر', onTap: () {}),
          const SizedBox(height: 22),

          // ========= حول التطبيق =========
          _sectionTitle('حول التطبيق'),
          _menuItem(Icons.info_outline, 'عن صحتك', 'الإصدار 1.0.0', onTap: () {}),
          _menuItem(Icons.share_rounded, 'مشاركة التطبيق', 'انشر الفائدة', onTap: () {}),
          const SizedBox(height: 22),

          // ========= تسجيل الخروج =========
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false),
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('تسجيل الخروج'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(height: 14),
          Center(child: Text('© 2026 صحتك. جميع الحقوق محفوظة', style: TextStyle(color: AppColors.grey.withOpacity(0.7), fontSize: 11))),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 8, right: 4), child: Text(title, style: const TextStyle(fontSize: 13, color: AppColors.grey, fontWeight: FontWeight.w600)));
  }

  // دالة موحدة: إما onTap أو switchValue+onSwitch
  Widget _menuItem(IconData icon, String title, String subtitle, {VoidCallback? onTap, bool? switchValue, Function(bool)? onSwitch, bool isDanger = false}) {
    if (switchValue != null && onSwitch != null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 4), elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SwitchListTile(
          secondary: Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.primary, size: 20)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.grey)),
          value: switchValue,
          activeColor: AppColors.primary,
          onChanged: onSwitch,
        ),
      );
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 4), elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: isDanger ? AppColors.error.withOpacity(0.08) : AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: isDanger ? AppColors.error : AppColors.primary, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: isDanger ? AppColors.error : null)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.grey)),
        trailing: const Icon(Icons.arrow_back_ios, size: 12, color: AppColors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('اختر اللغة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _langOption('العربية', '🇸🇦'),
          _langOption('English', '🇬🇧'),
          _langOption('Français', '🇫🇷'),
          _langOption('اردو', '🇵🇰'),
        ]),
      ),
    );
  }

  Widget _langOption(String lang, String flag) {
    final selected = _selectedLanguage == lang;
    return ListTile(leading: Text(flag, style: const TextStyle(fontSize: 24)), title: Text(lang, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? AppColors.primary : null)), trailing: selected ? const Icon(Icons.check, color: AppColors.primary) : null, onTap: () { setState(() => _selectedLanguage = lang); Navigator.pop(context); });
  }
}
