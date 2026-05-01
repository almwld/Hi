import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});
  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health File', style: TextStyle(fontWeight: FontWeight.bold)), actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {}), IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // بطاقة المريض
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              const CircleAvatar(radius: 35, backgroundColor: Colors.white24, child: Text('AH', style: TextStyle(fontSize: 28, color: Colors.white))),
              const SizedBox(height: 10),
              const Text('Ahmed Hassan', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Patient ID: SH-2024-0012', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _vitalStat('🩸', 'Blood', 'O+'),
                  _vitalStat('⚖️', 'Weight', '72 kg'),
                  _vitalStat('📏', 'Height', '175 cm'),
                  _vitalStat('🎂', 'Age', '29 Yrs'),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // نقاط الولاء
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.amber.withOpacity(0.3))),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.stars, color: AppColors.amber, size: 28)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Loyalty Points', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('1,250 Points', style: TextStyle(color: AppColors.amber, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('Earn more with each visit!', style: TextStyle(fontSize: 10, color: AppColors.grey)),
              ])),
              const Icon(Icons.chevron_left),
            ]),
          ),
          const SizedBox(height: 20),

          // الأمراض المزمنة
          Text('Chronic Conditions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _conditionCard('Hypertension', 'Diagnosed: 15 Mar 2023', 'Under Control', AppColors.error, Icons.favorite_border),
          _conditionCard('Asthma', 'Diagnosed: 10 Jan 2021', 'Mild', AppColors.warning, Icons.air),
          _conditionCard('Gastritis', 'Diagnosed: 05 Aug 2019', 'Resolved', AppColors.info, Icons.restaurant),

          const SizedBox(height: 20),

          // التطعيمات
          Text('Vaccinations', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
            child: Column(children: [
              _vaccineItem('COVID-19', 'Pfizer • 2 Doses', 'Last: 15 Jan 2024', true),
              const Divider(),
              _vaccineItem('Flu Vaccine', 'Annual', 'Last: 10 Oct 2025', true),
              const Divider(),
              _vaccineItem('Hepatitis B', '3 Doses', 'Completed: 2019', true),
              const Divider(),
              _vaccineItem('Tetanus', 'Booster', 'Next: 15 Jun 2026', false),
            ]),
          ),

          const SizedBox(height: 20),

          // الحساسية
          Text('Allergies', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _allergyChip('🥜', 'Peanuts', AppColors.error),
            _allergyChip('💊', 'Penicillin', AppColors.warning),
            _allergyChip('🌿', 'Pollen', AppColors.info),
          ]),

          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _vitalStat(String emoji, String label, String value) {
    return Column(children: [Text(emoji, style: const TextStyle(fontSize: 20)), const SizedBox(height: 2), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9))]);
  }

  Widget _conditionCard(String name, String diagnosed, String status, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: Row(children: [
        Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w500)), Text(diagnosed, style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))),
      ]),
    );
  }

  Widget _vaccineItem(String name, String description, String date, bool done) {
    return Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: done ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1), shape: BoxShape.circle), child: Icon(done ? Icons.check : Icons.schedule, color: done ? AppColors.success : AppColors.warning, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)), Text('$description • $date', style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
    ]);
  }

  Widget _allergyChip(String emoji, String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Text(emoji), const SizedBox(width: 4), Text(name, style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12))]),
    );
  }
}
