import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/screens/chat/chat_screen.dart';
import 'package:sehatak/presentation/screens/pharmacy/pharmacy_screen.dart';
import 'package:sehatak/presentation/screens/patient/patient_medical_history.dart';
import 'package:sehatak/presentation/screens/patient/patient_prescriptions.dart';
import 'package:sehatak/presentation/screens/patient/patient_appointments.dart';
import 'package:sehatak/presentation/screens/shared/notifications_screen.dart';
import 'package:sehatak/presentation/screens/settings/settings_screen.dart';
import 'package:sehatak/presentation/screens/about/about_screen.dart';
import 'package:sehatak/presentation/screens/emergencies/emergency_numbers.dart';
import 'package:sehatak/presentation/screens/insurance/insurance_companies.dart';
import 'package:sehatak/presentation/screens/lab/labs_list_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المزيد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('خدمات سريعة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, crossAxisSpacing: 10,
            children: [
              _serviceItem(context, Icons.emergency_share, 'الطوارئ', AppColors.error, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyNumbers()))),
              _serviceItem(context, Icons.local_hospital, 'مستشفيات', AppColors.teal, () {}),
              _serviceItem(context, Icons.science_rounded, 'مختبرات', AppColors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LabsListScreen()))),
              _serviceItem(context, Icons.shield_moon, 'تأمين', AppColors.indigo, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsuranceCompanies()))),
              _serviceItem(context, Icons.local_pharmacy, 'صيدلية', AppColors.success, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyScreen()))),
              _serviceItem(context, Icons.local_hospital, 'إسعاف', AppColors.error, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyNumbers()))),
            ],
          ),
          const SizedBox(height: 22),
          Text('الرعاية الصحية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _menuItem(context, Icons.calendar_month_rounded, 'مواعيدي', 'عرض وإدارة المواعيد', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientAppointments()))),
          _menuItem(context, Icons.receipt_long, 'الوصفات الطبية', 'عرض الوصفات', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientPrescriptions()))),
          _menuItem(context, Icons.folder_shared, 'السجل الطبي', 'سجل صحي كامل', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientMedicalHistory()))),
          _menuItem(context, Icons.chat_bubble_rounded, 'استشارات', 'تحدث مع طبيب', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
          const SizedBox(height: 22),
          Text('عام', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _menuItem(context, Icons.notifications_active, 'الإشعارات', 'تنبيهاتك', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
          _menuItem(context, Icons.settings_rounded, 'الإعدادات', 'تفضيلات التطبيق', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          _menuItem(context, Icons.help_outline, 'المساعدة', 'أسئلة شائعة وتواصل', () {}),
          _menuItem(context, Icons.info_outline, 'عن صحتك', 'الإصدار 1.0.0', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
          _menuItem(context, Icons.star_outline_rounded, 'تقييم التطبيق', 'قيمنا على المتجر', () {}),
          _menuItem(context, Icons.share_rounded, 'مشاركة', 'شارك التطبيق', () {}),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _serviceItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.08), shape: BoxShape.circle), child: Icon(icon, color: color, size: 26)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 5), elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.grey)),
        trailing: const Icon(Icons.arrow_back_ios, size: 12, color: AppColors.grey),
        onTap: onTap,
      ),
    );
  }
}
