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

  final List<Map<String, dynamic>> _weeklyTips = const [
    {'week': '1-4', 'title': 'بداية الحمل', 'tips': ['تناولي حمض الفوليك يومياً', 'تجنبي التدخين والكحول', 'راجعي الطبيب للتأكد'], 'baby': 'بحجم حبة السمسم', 'icon': '🌱'},
    {'week': '5-8', 'title': 'تكوين الأعضاء', 'tips': ['استمري على الفيتامينات', 'تناولي وجبات صغيرة متكررة', 'اشربي الماء بكثرة'], 'baby': 'بحجم حبة الفاصوليا', 'icon': '🫘'},
    {'week': '9-12', 'title': 'نمو سريع', 'tips': ['مارسي المشي الخفيف', 'تجنبي رفع الأشياء الثقيلة', 'نامي على جانبك الأيسر'], 'baby': 'بحجم الليمونة', 'icon': '🍋'},
    {'week': '13-16', 'title': 'الثلث الثاني', 'tips': ['اهتمي بتغذيتك', 'مارسي تمارين الحمل', 'احجزي فحص السونار'], 'baby': 'بحجم الأفوكادو', 'icon': '🥑'},
    {'week': '17-20', 'title': 'الشعور بالحركة', 'tips': ['تتبعي حركات الجنين', 'تناولي الكالسيوم', 'تجنبي الوقوف الطويل'], 'baby': 'بحجم الموز', 'icon': '🍌'},
    {'week': '21-24', 'title': 'زيادة الوزن', 'tips': ['راقبي زيادة وزنك', 'تناولي الحديد', 'جهزي حقيبة المستشفى'], 'baby': 'بحجم ثمرة الذرة', 'icon': '🌽'},
    {'week': '25-28', 'title': 'فحص السكر', 'tips': ['افعلي فحص سكر الحمل', 'تجنبي التوتر', 'ابدئي دروس الولادة'], 'baby': 'بحجم الباذنجان', 'icon': '🍆'},
    {'week': '29-32', 'title': 'الثلث الأخير', 'tips': ['راقبي ضغط الدم', 'استعدي للولادة', 'تواصلي مع طبيبك'], 'baby': 'بحجم جوز الهند', 'icon': '🥥'},
    {'week': '33-36', 'title': 'اقتراب الولادة', 'tips': ['افحصي وضعية الجنين', 'تجنبي السفر', 'جهزي مسلتزمات الطفل'], 'baby': 'بحجم البطيخة الصغيرة', 'icon': '🍈'},
    {'week': '37-40', 'title': 'أي يوم!', 'tips': ['راقبي علامات الولادة', 'ابقِ هاتفك قريباً', 'لا تذهبي بعيداً عن المستشفى'], 'baby': 'بحجم البطيخة', 'icon': '🍉'},
  ];

  @override
  Widget build(BuildContext context) {
    final daysLeft = _dueDate.difference(DateTime.now()).inDays;
    final tipIndex = ((_week - 1) ~/ 4).clamp(0, 9);
    final tip = _weeklyTips[tipIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('متابعة الحمل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // بطاقة التقدم
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
          const SizedBox(height: 16),
          // معلومات الطفل
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Text(tip['icon'], style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tip['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('طفلك الآن ${tip['baby']}', style: const TextStyle(color: AppColors.darkGrey)),
              ])),
            ]),
          ),
          const SizedBox(height: 16),
          // نصائح الأسبوع
          Text('نصائح هذا الأسبوع', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...(tip['tips'] as List).map((t) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
            child: Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 18), const SizedBox(width: 8), Expanded(child: Text(t, style: const TextStyle(fontSize: 13)))])),
          ),
          const SizedBox(height: 16),
          // جدول المواعيد
          Text('مواعيد المتابعة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
            child: Column(children: [
              _appointmentItem('فحص السونار', 'الأسبوع 28', '15 يوليو 2026', true),
              const Divider(),
              _appointmentItem('فحص سكر الحمل', 'الأسبوع 26', '1 يوليو 2026', false),
              const Divider(),
              _appointmentItem('زيارة دورية', 'الأسبوع 24', 'اليوم', true),
              const Divider(),
              _appointmentItem('تحاليل شاملة', 'الأسبوع 20', '10 مايو 2026', true),
            ]),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, backgroundColor: Colors.pink, icon: const Icon(Icons.add), label: const Text('إضافة متابعة')),
    );
  }

  Widget _appointmentItem(String title, String week, String date, bool done) {
    return Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: done ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1), shape: BoxShape.circle), child: Icon(done ? Icons.check : Icons.schedule, color: done ? AppColors.success : AppColors.warning, size: 16)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), Text('$week • $date', style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
    ]);
  }
}
