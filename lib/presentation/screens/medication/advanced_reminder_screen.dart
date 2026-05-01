import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class AdvancedReminderScreen extends StatefulWidget {
  const AdvancedReminderScreen({super.key});
  @override
  State<AdvancedReminderScreen> createState() => _AdvancedReminderScreenState();
}

class _AdvancedReminderScreenState extends State<AdvancedReminderScreen> {
  final List<Map<String, dynamic>> _medications = [
    {'name': 'باراسيتامول', 'dose': '500mg', 'time': '8:00 ص', 'days': ['يومياً'], 'food': 'بعد الأكل', 'quantity': '30 قرص', 'remaining': '12', 'refill': '18/6', 'icon': '💊', 'color': AppColors.primary},
    {'name': 'أوميبرازول', 'dose': '40mg', 'time': '9:00 ص', 'days': ['يومياً'], 'food': 'قبل الأكل', 'quantity': '14 كبسولة', 'remaining': '3', 'refill': '10/6', 'icon': '💊', 'color': AppColors.success},
    {'name': 'فيتامين د', 'dose': '1000IU', 'time': '2:00 م', 'days': ['أحد', 'أربعاء', 'جمعة'], 'food': 'مع الأكل', 'quantity': '60 قرص', 'remaining': '45', 'refill': '30/8', 'icon': '💊', 'color': AppColors.amber},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تذكير الأدوية المتقدم')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [_summaryCard('أدوية نشطة', '3', AppColors.primary), const SizedBox(width: 10), _summaryCard('جرعات اليوم', '5/6', AppColors.success), const SizedBox(width: 10), _summaryCard('يحتاج إعادة', '1', AppColors.error)]),
          const SizedBox(height: 16),
          ..._medications.map((m) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: (m['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(m['icon'], style: const TextStyle(fontSize: 20)))), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('${m['dose']} • ${m['time']}', style: const TextStyle(fontSize: 11, color: AppColors.grey))])), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('متبقي: ${m['remaining']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text('إعادة: ${m['refill']}', style: const TextStyle(fontSize: 9, color: AppColors.grey))])]),
              const SizedBox(height: 8),
              Wrap(spacing: 4, children: [
                _tag(m['food'], Icons.restaurant, AppColors.warning),
                _tag('${m['quantity']}', Icons.inventory, AppColors.info),
                ...(m['days'] as List).map((d) => _tag(d, Icons.calendar_today, AppColors.success)),
              ]),
              if ((m['remaining'] as String).compareTo('5') < 0) Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.05), borderRadius: BorderRadius.circular(8)), child: const Row(children: [Icon(Icons.warning, color: AppColors.error, size: 14), SizedBox(width: 4), Text('يحتاج إعادة تعبئة قريباً', style: TextStyle(color: AppColors.error, fontSize: 10))])),
            ]),
          )),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, backgroundColor: AppColors.primary, icon: const Icon(Icons.add), label: const Text('إضافة دواء')),
    );
  }

  Widget _tag(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 10, color: color), const SizedBox(width: 3), Text(text, style: TextStyle(fontSize: 9, color: color))]),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)), Text(label, style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
    );
  }
}
