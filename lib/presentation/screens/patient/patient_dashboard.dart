import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import 'patient_profile.dart';
import 'patient_medical_history.dart';
import 'patient_appointments.dart';
import 'patient_prescriptions.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.healthFile),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientProfile()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context),
            const SizedBox(height: 24),
            _buildQuickStats(context),
            const SizedBox(height: 24),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.white.withOpacity(0.2),
            child: const Icon(Icons.person, size: 40, color: AppColors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحمد محمد',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الدم: O+ | العمر: 32 سنة',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'نسبة اكتمال الملف: 85%',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(context, Icons.calendar_today, '12', 'موعد', AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(context, Icons.medication, '5', 'دواء', AppColors.warning)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(context, Icons.folder_open, '8', 'تقرير', AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(context, Icons.science, '3', 'تحليل', AppColors.info)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {'icon': Icons.folder_open, 'title': AppStrings.medicalHistory, 'color': AppColors.primary, 'screen': const PatientMedicalHistory()},
      {'icon': Icons.calendar_today, 'title': AppStrings.myAppointments, 'color': AppColors.purple, 'screen': const PatientAppointments()},
      {'icon': Icons.medication, 'title': AppStrings.prescriptions, 'color': AppColors.warning, 'screen': const PatientPrescriptions()},
      {'icon': Icons.science, 'title': AppStrings.labTests, 'color': AppColors.info, 'screen': null},
      {'icon': Icons.vaccines, 'title': AppStrings.vaccinations, 'color': AppColors.success, 'screen': null},
      {'icon': Icons.warning_amber, 'title': AppStrings.allergies, 'color': AppColors.error, 'screen': null},
      {'icon': Icons.favorite_border, 'title': AppStrings.chronicDiseases, 'color': AppColors.pink, 'screen': null},
      {'icon': Icons.people_outline, 'title': AppStrings.familyMembers, 'color': AppColors.teal, 'screen': null},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'القائمة',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...menuItems.map((item) => _buildMenuItem(
          context,
          item['icon'] as IconData,
          item['title'] as String,
          item['color'] as Color,
          item['screen'] as Widget?,
        )),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color color, Widget? screen) {
    return GestureDetector(
      onTap: screen != null ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
