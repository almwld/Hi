import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class EyeCareScreen extends StatefulWidget {
  const EyeCareScreen({super.key});
  @override
  State<EyeCareScreen> createState() => _EyeCareScreenState();
}

class _EyeCareScreenState extends State<EyeCareScreen> {
  final List<Map<String, dynamic>> _tests = const [
    {'name': 'اختبار حدة البصر', 'desc': 'اختبر قوة نظرك', 'icon': '👁️', 'color': AppColors.primary},
    {'name': 'اختبار عمى الألوان', 'desc': 'هل تميز الألوان؟', 'icon': '🎨', 'color': AppColors.purple},
    {'name': 'فحص قاع العين', 'desc': 'صورة شبكية العين', 'icon': '📸', 'color': AppColors.info},
    {'name': 'قياس ضغط العين', 'desc': 'فحص الجلوكوما', 'icon': '🔬', 'color': AppColors.warning},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طب العيون')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.indigo.shade300, Colors.indigo.shade600]), borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [Text('👁️', style: TextStyle(fontSize: 48)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('صحة عيونك', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text('الفحص الدوري يحمي بصرك', style: TextStyle(color: Colors.white70, fontSize: 12))]))]),
          ),
          const SizedBox(height: 16),
          GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.3,
            children: _tests.map((t) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(t['icon'], style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(t['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(t['desc'], style: const TextStyle(fontSize: 9, color: AppColors.grey)),
              ]),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('👓 نصائح للعناية بالعيون', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 8),
            Text('• استخدم قاعدة 20-20-20: كل 20 دقيقة، انظر لمسافة 20 قدماً لمدة 20 ثانية', style: TextStyle(fontSize: 12)),
            Text('• ارتدِ نظارات شمسية واقية من الأشعة فوق البنفسجية', style: TextStyle(fontSize: 12)),
            Text('• حافظ على إضاءة مناسبة عند القراءة', style: TextStyle(fontSize: 12)),
            Text('• تناول أطعمة غنية بفيتامين A والأوميغا 3', style: TextStyle(fontSize: 12)),
            Text('• افحص عينيك سنوياً', style: TextStyle(fontSize: 12)),
          ])),
        ]),
      ),
    );
  }
}
