import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عن التطبيق')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const SizedBox(height: 30),
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(25)),
            child: const Icon(Icons.health_and_safety, size: 55, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text('صحتك', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Text('الإصدار 1.0.0', style: TextStyle(fontSize: 13, color: AppColors.primary))),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(16)), child: const Text('تطبيقك الطبي المتكامل الذي يجمع كل احتياجاتك الصحية في مكان واحد.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.darkGrey))),
          const SizedBox(height: 30),
          _sectionTitle('مميزات التطبيق'),
          ...['🩺 استشارات طبية', '💊 صيدلية متكاملة', '📅 حجز المواعيد', '🔬 التحاليل الطبية', '📋 الملف الصحي', '🚑 الطوارئ', '🛡️ التأمين الصحي', '🌙 الوضع الليلي'].map((f) => ListTile(leading: Text(f.split(' ')[0], style: const TextStyle(fontSize: 24)), title: Text(f.substring(2)))),
          const SizedBox(height: 20),
          const Divider(),
          const Text('© 2026 صحتك. جميع الحقوق محفوظة.', style: TextStyle(color: AppColors.grey, fontSize: 12)),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(children: [Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]);
  }
}
