import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // رأس الملف
          const CircleAvatar(radius: 40, backgroundColor: AppColors.primary, child: Text('AH', style: TextStyle(fontSize: 28, color: Colors.white))),
          const SizedBox(height: 12),
          const Text('Ali Hassan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('ali.hassan@example.com', style: TextStyle(color: AppColors.grey)),
          const Text('📞 +92 300 1234567', style: TextStyle(color: AppColors.grey)),
          const SizedBox(height: 20),
          // بطاقة الصحة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Health Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('View All', style: TextStyle(color: Colors.white70, fontSize: 12))]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _healthStat('Blood Type', 'O+', Icons.bloodtype),
                _healthStat('Weight', '72 kg', Icons.monitor_weight),
                _healthStat('Height', '175 cm', Icons.height),
                _healthStat('Age', '29 Years', Icons.cake),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          // نقاط الولاء
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.amber.withOpacity(0.5))),
            child: const Row(children: [Icon(Icons.stars, color: AppColors.amber, size: 32), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Sehatak Loyalty Points', style: TextStyle(fontWeight: FontWeight.bold)), Text('1,250 Points', style: TextStyle(color: AppColors.amber, fontSize: 18, fontWeight: FontWeight.bold)), Text('Keep using Sehatak and unlock more rewards!', style: TextStyle(fontSize: 11, color: AppColors.grey))])), Icon(Icons.chevron_left)]),
          ),
          const SizedBox(height: 16),
          // التاريخ الطبي
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Medical History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('View All', style: TextStyle(color: AppColors.primary, fontSize: 12))]),
          const SizedBox(height: 8),
          _medicalItem('Hypertension', 'Diagnosed on 15 Mar 2023', AppColors.error),
          _medicalItem('Asthma', 'Diagnosed on 10 Jan 2021', AppColors.warning),
          _medicalItem('Gastritis', 'Diagnosed on 05 Aug 2019', AppColors.info),
          const SizedBox(height: 20),
          // أزرار سفلية
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _bottomAction(Icons.calendar_today, 'Appointments'),
            _bottomAction(Icons.receipt, 'Prescriptions'),
            _bottomAction(Icons.science, 'Lab Reports'),
            _bottomAction(Icons.shield, 'Insurance'),
          ]),
        ]),
      ),
    );
  }

  Widget _healthStat(String label, String value, IconData icon) {
    return Column(children: [Icon(icon, color: Colors.white70, size: 20), const SizedBox(height: 4), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10))]);
  }

  Widget _medicalItem(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [Container(width: 4, height: 36, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.grey))])), const Icon(Icons.chevron_left, color: AppColors.grey)]),
    );
  }

  Widget _bottomAction(IconData icon, String label) {
    return Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primary)), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 10))]);
  }
}
