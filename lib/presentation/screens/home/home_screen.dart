import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/core/constants/app_strings.dart';
import 'package:sehatak/presentation/screens/doctor/doctors_list_screen.dart';
import 'package:sehatak/presentation/screens/patient/patient_appointments.dart';
import 'package:sehatak/presentation/screens/patient/patient_dashboard.dart';
import 'package:sehatak/presentation/screens/patient/patient_prescriptions.dart';
import 'package:sehatak/presentation/screens/patient/patient_medical_history.dart';
import 'package:sehatak/presentation/screens/shared/notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صحتك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // نص ترحيبي
            Text('صباح الخير', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('أحمد محمد', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.grey)),
            const SizedBox(height: 20),
            // شريط البحث
            TextField(
              decoration: InputDecoration(
                hintText: 'بحث عن طبيب، دواء، تحليل ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            // بطاقة استشارة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('استشارة طبية', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('تحدث مع طبيب مختص بكل سهولة', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // فتح شاشة الأطباء للاستشارة
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorsListScreen()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                    child: const Text('ابدأ الاستشارة'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // شبكة الخدمات
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildServiceCard(context, Icons.medication, 'الأدوية', 'اطلب أدويتك', AppColors.teal, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientPrescriptions()));
                }),
                _buildServiceCard(context, Icons.calendar_today, 'المواعيد', 'احجز موعدك', AppColors.purple, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientAppointments()));
                }),
                _buildServiceCard(context, Icons.science, 'التحاليل', 'احجز فحصك', AppColors.orange, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientMedicalHistory()));
                }),
                _buildServiceCard(context, Icons.folder_open, 'الملف الصحي', 'جميع بياناتك', AppColors.indigo, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientDashboard()));
                }),
              ],
            ),
            const SizedBox(height: 24),
            // نصائح صحية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('نصائح صحية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('عرض الكل')),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.tips_and_updates, color: AppColors.amber),
                    const SizedBox(width: 8),
                    Text('نصائح ذهبية 5', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 8),
                  const Text('للحفاظ على صحتك', style: TextStyle(color: AppColors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.grey)),
          ],
        ),
      ),
    );
  }
}
