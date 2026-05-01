import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class DentalCareScreen extends StatelessWidget {
  const DentalCareScreen({super.key});

  final List<Map<String, dynamic>> _services = const [
    {'name': 'فحص أسنان', 'price': '100', 'time': '30 دقيقة', 'icon': '🦷', 'color': AppColors.primary},
    {'name': 'تنظيف أسنان', 'price': '200', 'time': '45 دقيقة', 'icon': '🪥', 'color': AppColors.info},
    {'name': 'حشو عصب', 'price': '500', 'time': '60 دقيقة', 'icon': '🔧', 'color': AppColors.error},
    {'name': 'تقويم أسنان', 'price': '5000', 'time': '12 شهر', 'icon': '😬', 'color': AppColors.purple},
    {'name': 'تبييض أسنان', 'price': '800', 'time': '45 دقيقة', 'icon': '✨', 'color': AppColors.amber},
    {'name': 'زراعة أسنان', 'price': '3000', 'time': 'جلسات', 'icon': '🏗️', 'color': AppColors.success},
    {'name': 'خلع ضرس', 'price': '300', 'time': '30 دقيقة', 'icon': '🦷', 'color': AppColors.warning},
    {'name': 'تركيبات', 'price': '1500', 'time': '3 جلسات', 'icon': '👄', 'color': AppColors.teal},
  ];

  final List<Map<String, String>> _tips = const [
    {'title': 'نظف أسنانك مرتين يومياً', 'desc': 'استخدم فرشاة ناعمة ومعجون يحتوي على الفلورايد'},
    {'title': 'استخدم خيط الأسنان', 'desc': 'مرة يومياً لإزالة البلاك بين الأسنان'},
    {'title': 'غير فرشاة أسنانك', 'desc': 'كل 3-4 أشهر أو عندما تتآكل الشعيرات'},
    {'title': 'زُر طبيب الأسنان', 'desc': 'كل 6 أشهر للفحص الدوري'},
    {'title': 'قلل من السكر', 'desc': 'المشروبات الغازية والحلويات تضر الأسنان'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طب الأسنان')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade200, Colors.blue.shade600]), borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [Text('🦷', style: TextStyle(fontSize: 48)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('صحة أسنانك', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text('ابتسامة صحية = ثقة أكبر', style: TextStyle(color: Colors.white70, fontSize: 12))]))]),
          ),
          const SizedBox(height: 16),
          Text('خدماتنا', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.2,
            children: _services.map((s) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(s['icon'], style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 6),
                Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text('${s['price']} ر.س • ${s['time']}', style: const TextStyle(fontSize: 9, color: AppColors.grey)),
              ]),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text('نصائح للعناية بالأسنان', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._tips.map((t) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
            child: Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 20), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t['title']!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)), Text(t['desc']!, style: const TextStyle(fontSize: 10, color: AppColors.grey))]))]),
          )),
        ]),
      ),
    );
  }
}
