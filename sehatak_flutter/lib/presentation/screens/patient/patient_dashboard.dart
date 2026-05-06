import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/screens/patient/patient_medical_history.dart';
import 'package:sehatak/presentation/screens/patient/patient_prescriptions.dart';
import 'package:sehatak/presentation/screens/patient/patient_appointments.dart';
import 'package:sehatak/presentation/screens/vaccination/vaccination_screen.dart';
import 'package:sehatak/presentation/screens/medical_reports/medical_reports_screen.dart';
import 'package:sehatak/presentation/screens/health_tools/bmi_calculator_screen.dart';
import 'package:sehatak/presentation/screens/blood_pressure/blood_pressure_screen.dart';
import 'package:sehatak/presentation/screens/glucose_tracker/glucose_tracker_screen.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صحتي', style: TextStyle(fontWeight: FontWeight.bold)), actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {}), IconButton(icon: const Icon(Icons.qr_code), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              CircleAvatar(radius: 38, backgroundColor: Colors.white24, backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200')),
              const SizedBox(height: 10),
              const Text('أحمد محمد', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('رقم المريض: SH-2024-0012', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _vital('🩸', 'O+'), _vital('⚖️', '72 كجم'), _vital('📏', '175 سم'), _vital('🎂', '29 سنة'),
              ])),
            ]),
          ),
          const SizedBox(height: 16),
          // نقاط الولاء
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.amber.withOpacity(0.25))), child: Row(children: [const Icon(Icons.stars, color: AppColors.amber, size: 28), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('نقاط الولاء', style: TextStyle(fontWeight: FontWeight.bold)), Text('1,250 نقطة', style: TextStyle(color: AppColors.amber, fontSize: 22, fontWeight: FontWeight.bold))])), const Icon(Icons.chevron_left)])),
          const SizedBox(height: 16),
          // وصول سريع
          Text('وصول سريع', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            _quick(context, 'المواعيد', Icons.calendar_month, AppColors.primary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientAppointments()))),
            _quick(context, 'الوصفات', Icons.receipt_long, AppColors.success, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientPrescriptions()))),
            _quick(context, 'التحاليل', Icons.science, AppColors.info, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientMedicalHistory()))),
            _quick(context, 'التقارير', Icons.description, AppColors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalReportsScreen()))),
            _quick(context, 'التطعيمات', Icons.vaccines, AppColors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VaccinationScreen()))),
          ]),
          const SizedBox(height: 16),
          // المؤشرات الحيوية
          Text('المؤشرات الحيوية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            _vitalCard('BMI', '23.7', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BMICalculatorScreen()))),
            const SizedBox(width: 8),
            _vitalCard('ضغط', '128/82', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BloodPressureScreen()))),
            const SizedBox(width: 8),
            _vitalCard('سكر', '127', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlucoseTrackerScreen()))),
          ]),
          const SizedBox(height: 16),
          // أمراض مزمنة
          Text('الأمراض المزمنة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          _condition('ارتفاع ضغط الدم', 'تحت السيطرة', AppColors.error),
          _condition('الربو', 'خفيف', AppColors.warning),
          _condition('التهاب المعدة', 'تم الشفاء', AppColors.info),
          const SizedBox(height: 16),
          // حساسية
          Text('الحساسية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Wrap(spacing: 8, runSpacing: 8, children: ['🥜 فول سوداني', '💊 بنسلين', '🌿 حبوب لقاح'].map((a) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.06), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.error.withOpacity(0.15))), child: Text(a, style: const TextStyle(fontSize: 12)))).toList()),
        ]),
      ),
    );
  }

  Widget _vital(String e, String v) => Column(children: [Text(e, style: const TextStyle(fontSize: 20)), Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))]);
  
  Widget _quick(BuildContext ctx, String label, IconData icon, Color color, VoidCallback tap) => GestureDetector(onTap: tap, child: Column(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 9))]));

  Widget _vitalCard(String label, String value, VoidCallback tap) => Expanded(child: GestureDetector(onTap: tap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)]), child: Column(children: [Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)), Text(label, style: const TextStyle(fontSize: 10, color: AppColors.grey))]))));

  Widget _condition(String name, String status, Color color) => Container(margin: const EdgeInsets.only(bottom: 4), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]), child: Row(children: [Container(width: 4, height: 32, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500))), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(6)), child: Text(status, style: TextStyle(fontSize: 10, color: color)))]),
  );
}
