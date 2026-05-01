import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehatak/presentation/bloc/theme_bloc/theme_bloc.dart' hide ThemeMode;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _buildSectionTitle(context, 'الحساب'),
          _buildSettingItem(context, Icons.person_outline, 'الملف الشخصي', () {}),
          _buildSettingItem(context, Icons.notifications_outlined, 'الإشعارات', () {}),
          _buildSettingItem(context, Icons.lock_outline, 'الأمان', () {}),
          _buildSettingItem(context, Icons.privacy_tip_outlined, 'الخصوصية', () {}),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'التفضيلات'),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              bool isDark = false;
              if (state is ThemeLoadedState) {
                isDark = state.themeMode == ThemeMode.dark;
              }
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
                title: const Text('الوضع الليلي'),
                value: isDark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(SetThemeEvent(value));
                },
              );
            },
          ),
          _buildSettingItem(context, Icons.language, 'اللغة', () {}),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'المساعدة'),
          _buildSettingItem(context, Icons.help_outline, 'المساعدة والدعم', () {}),
          _buildSettingItem(context, Icons.info_outline, 'عن التطبيق', () {}),
          _buildSettingItem(context, Icons.description_outlined, 'الشروط والأحكام', () {}),
          _buildSettingItem(context, Icons.policy_outlined, 'سياسة الخصوصية', () {}),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'الخروج'),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.grey, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_back_ios, size: 14, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
