import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          _buildSectionTitle(context, 'الحساب'),
          _buildSettingItem(context, Icons.person_outline, AppStrings.profile, () {}),
          _buildSettingItem(context, Icons.notifications_outlined, AppStrings.notifications, () {}),
          _buildSettingItem(context, Icons.lock_outline, AppStrings.security, () {}),
          _buildSettingItem(context, Icons.privacy_tip_outlined, AppStrings.privacy, () {}),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'التفضيلات'),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              bool isDark = false;
              if (state is ThemeLoadedState) {
                isDark = state.themeMode == ThemeMode.dark;
              }
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
                title: Text(AppStrings.darkMode),
                value: isDark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(SetThemeEvent(value));
                },
              );
            },
          ),
          _buildSettingItem(context, Icons.language, AppStrings.language, () {}),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'المساعدة'),
          _buildSettingItem(context, Icons.help_outline, AppStrings.helpSupport, () {}),
          _buildSettingItem(context, Icons.info_outline, AppStrings.about, () {}),
          _buildSettingItem(context, Icons.description_outlined, AppStrings.termsConditions, () {}),
          _buildSettingItem(context, Icons.policy_outlined, AppStrings.privacyPolicy, () {}),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'الخروج'),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(AppStrings.logout, style: const TextStyle(color: AppColors.error)),
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
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.grey, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
