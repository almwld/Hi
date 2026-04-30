import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/screens/chat/chat_screen.dart';
import 'package:sehatak/presentation/screens/pharmacy/pharmacy_screen.dart';
import 'package:sehatak/presentation/screens/doctor/doctor_details_screen.dart';
import 'package:sehatak/presentation/screens/patient/patient_medical_history.dart';
import 'package:sehatak/presentation/screens/patient/patient_prescriptions.dart';
import 'package:sehatak/presentation/screens/patient/patient_appointments.dart';
import 'package:sehatak/presentation/screens/shared/notifications_screen.dart';
import 'package:sehatak/presentation/screens/settings/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // خدمات سريعة
            Text('Quick Services', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _serviceItem(context, Icons.emergency_share, 'Emergency', AppColors.error,
                    () {}),
                _serviceItem(context, Icons.local_hospital, 'Hospitals', AppColors.teal,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctorId: '')))),
                _serviceItem(context, Icons.medical_services, 'Clinics', AppColors.info,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctorId: '')))),
                _serviceItem(context, Icons.science_rounded, 'Labs', AppColors.purple,
                    () {}),
                _serviceItem(context, Icons.shield_moon, 'Insurance', AppColors.indigo,
                    () {}),
                _serviceItem(context, Icons.local_hospital, 'Ambulance', AppColors.error,
                    () {}),
              ],
            ),
            const SizedBox(height: 24),

            // خدمات صحية
            Text('Healthcare Services', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _menuItem(context, Icons.calendar_month_rounded, 'My Appointments', 'View and manage your appointments', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientAppointments()));
            }),
            _menuItem(context, Icons.receipt_long, 'My Prescriptions', 'View your prescriptions', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientPrescriptions()));
            }),
            _menuItem(context, Icons.folder_shared, 'Medical History', 'Your complete health record', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientMedicalHistory()));
            }),
            _menuItem(context, Icons.chat_bubble_rounded, 'Consultations', 'Chat with a doctor', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
            }),
            _menuItem(context, Icons.local_pharmacy_rounded, 'Pharmacy', 'Order medicines online', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyScreen()));
            }),
            const SizedBox(height: 24),

            // عام
            Text('General', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _menuItem(context, Icons.notifications_active, 'Notifications', 'Check your alerts', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            }),
            _menuItem(context, Icons.settings_rounded, 'Settings', 'App preferences', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            }),
            _menuItem(context, Icons.help_outline, 'Help & Support', 'FAQs and contact us', () {}),
            _menuItem(context, Icons.info_outline, 'About Sehatak', 'Version 1.0.0', () {}),
            _menuItem(context, Icons.star_outline_rounded, 'Rate Us', 'Rate on Play Store', () {}),
            _menuItem(context, Icons.share_rounded, 'Share with Friends', 'Spread the word', () {}),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _serviceItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.grey),
        onTap: onTap,
      ),
    );
  }
}
