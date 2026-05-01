import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class HomeCareScreen extends StatelessWidget {
  const HomeCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = const [
      {'name': 'تمريض منزلي', 'price': '200', 'icon': '👩‍⚕️', 'desc': 'رعاية تمريضية متكاملة', 'duration': 'ساعة', 'color': AppColors.primary},
      {'name': 'علاج طبيعي', 'price': '300', 'icon': '💪', 'desc': 'جلسات إعادة تأهيل', 'duration': '45 دقيقة', 'color': AppColors.success},
      {'name': 'فحص طبي', 'price': '150', 'icon': '🩺', 'desc': 'فحص سريري شامل', 'duration': '30 دقيقة', 'color': AppColors.info},
      {'name': 'سحب عينات', 'price': '100', 'icon': '💉', 'desc': 'تحاليل منزلية', 'duration': '15 دقيقة', 'color': AppColors.error},
      {'name': 'رعاية مسنين', 'price': '500', 'icon': '👴', 'desc': 'رعاية خاصة 24 ساعة', 'duration': 'يوم', 'color': AppColors.purple},
      {'name': 'متابعة حمل', 'price': '250', 'icon': '🤰', 'desc': 'فحص دوري للحامل', 'duration': '40 دقيقة', 'color': AppColors.pink},
      {'name': 'غيار جروح', 'price': '120', 'icon': '🩹', 'desc': 'عناية بالجروح', 'duration': '20 دقيقة', 'color': AppColors.warning},
      {'name': 'توصيل أدوية', 'price': 'مجاناً', 'icon': '🚚', 'desc': 'توصيل سريع', 'duration': '30 دقيقة', 'color': AppColors.teal},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('خدمات منزلية', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(16)),
            child: const Column(children: [Icon(Icons.home, color: Colors.white, size: 40), SizedBox(height: 8), Text('رعاية صحية في منزلك', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text('خدمات طبية تصل إلى باب بيتك', style: TextStyle(color: Colors.white70, fontSize: 12))]),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.9,
            children: [
              for (final s in services)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(s['icon']!, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 6),
                    Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(s['desc']!, style: const TextStyle(fontSize: 9, color: AppColors.grey)),
                    const SizedBox(height: 4),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: (s['color'] as Color).withOpacity(0.08), borderRadius: BorderRadius.circular(4)), child: Text('${s['price']} ر.س • ${s['duration']}', style: TextStyle(fontSize: 9, color: s['color'] as Color))),
                  ]),
                ),
            ],
          ),
        ]),
      ),
    );
  }
}
