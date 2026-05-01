import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  const PregnancyTrackerScreen({super.key});
  @override
  State<PregnancyTrackerScreen> createState() => _PregnancyTrackerScreenState();
}

class _PregnancyTrackerScreenState extends State<PregnancyTrackerScreen> {
  int _week = 24;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 112));

  final List<Map<String, dynamic>> _tips = const [
    {'week': '1-4', 'title': 'بداية الحمل', 'tips': ['تناولي حمض الفوليك', 'تجنبي التدخين', 'راجعي الطبيب'], 'baby': 'بحجم السمسم', 'icon': '🌱'},
    {'week': '5-8', 'title': 'تكوين الأعضاء', 'tips': ['استمري على الفيتامينات', 'وجبات صغيرة', 'اشربي الماء'], 'baby': 'بحجم الفاصوليا', 'icon': '🫘'},
    {'week': '9-12', 'title': 'نمو سريع', 'tips': ['المشي الخفيف', 'تجنبي رفع الثقيل', 'نامي على الجانب الأيسر'], 'baby': 'بحجم الليمونة', 'icon': '🍋'},
    {'week': '13-16', 'title': 'الثلث الثاني', 'tips': ['اهتمي بالتغذية', 'تمارين الحمل', 'فحص السونار'], 'baby': 'بحجم الأفوكادو', 'icon': '🥑'},
    {'week': '17-20', 'title': 'الشعور بالحركة', 'tips': ['تتبعي حركات الجنين', 'تناولي الكالسيوم', 'تجنبي الوقوف الطويل'], 'baby': 'بحجم الموز', 'icon': '🍌'},
    {'week': '21-24', 'title': 'زيادة الوزن', 'tips': ['راقبي وزنك', 'تناولي الحديد', 'جهزي حقيبة المستشفى'], 'baby': 'بحجم الذرة', 'icon': '🌽'},
    {'week': '25-28', 'title': 'فحص السكر', 'tips': ['فحص سكر الحمل', 'تجنبي التوتر', 'دروس الولادة'], 'baby': 'بحجم الباذنجان', 'icon': '🍆'},
    {'week': '29-32', 'title': 'الثلث الأخير', 'tips': ['راقبي الضغط', 'استعدي للولادة', 'تواصلي مع الطبيب'], 'baby': 'بحجم جوز الهند', 'icon': '🥥'},
    {'week': '33-36', 'title': 'اقتراب الولادة', 'tips': ['وضعية الجنين', 'تجنبي السفر', 'جهزي المستلزمات'], 'baby': 'بحجم البطيخة الصغيرة', 'icon': '🍈'},
    {'week': '37-40', 'title': 'أي يوم!', 'tips': ['علامات الولادة', 'هاتفك قريب', 'لا تذهبي بعيداً'], 'baby': 'بحجم البطيخة', 'icon': '🍉'},
  ];

  int get _tipIndex => ((_week - 1) ~/ 4).clamp(0, 9);

  @override
  Widget build(BuildContext context) {
    final daysLeft = _dueDate.difference(DateTime.now()).inDays;
    final tip = _tips[_tipIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('متابعة الحمل', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade300, Colors.purple.shade400]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('🤰', style: TextStyle(fontSize: 40)),
                Column(children: [const Text('الأسبوع', style: TextStyle(color: Colors.white70, fontSize: 12)), Text('$_week', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)), const Text('من 40', style: TextStyle(color: Colors.white70, fontSize: 12))]),
                Column(children: [const Text('متبقي', style: TextStyle(color: Colors.white70, fontSize: 12)), Text('$daysLeft', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)), const Text('يوم', style: TextStyle(color: Colors.white70, fontSize: 12))]),
              ]),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: _week / 40, backgroundColor: Colors.white24, color: Colors.white, minHeight: 6, borderRadius: BorderRadius.circular(3)),
              const SizedBox(height: 6),
              Text('الموعد المتوقع: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Text(tip['icon'], style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(tip['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('طفلك الآن ${tip['baby']}', style: const TextStyle(color: AppColors.darkGrey))])),
            ]),
          ),
          const SizedBox(height: 14),
          Text('نصائح هذا الأسبوع', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...(tip['tips'] as List).map((t) => Container(margin: const EdgeInsets.only(bottom: 4), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]), child: Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 16), const SizedBox(width: 6), Text(t, style: const TextStyle(fontSize: 12))]))),
        ]),
      ),
    );
  }
}
