import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key});
  @override
  State<MedicationReminderScreen> createState() => _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  final List<Map<String, dynamic>> _reminders = [
    {'name': 'باراسيتامول', 'dose': '500mg', 'time': '8:00 ص', 'frequency': 'كل 8 ساعات', 'icon': '💊', 'color': AppColors.primary, 'taken': true},
    {'name': 'أوميبرازول', 'dose': '40mg', 'time': '9:00 ص', 'frequency': 'قبل الأكل', 'icon': '💊', 'color': AppColors.success, 'taken': true},
    {'name': 'فيتامين د', 'dose': '1000IU', 'time': '2:00 م', 'frequency': 'يومياً', 'icon': '💊', 'color': AppColors.amber, 'taken': false},
    {'name': 'أملوديبين', 'dose': '5mg', 'time': '8:00 م', 'frequency': 'مساءً', 'icon': '💊', 'color': AppColors.error, 'taken': false},
    {'name': 'ميتفورمين', 'dose': '850mg', 'time': '9:00 م', 'frequency': 'بعد الأكل', 'icon': '💊', 'color': AppColors.info, 'taken': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تذكير الأدوية')),
      body: Column(children: [
        // شريط التقدم اليومي
        Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            const Text('اليوم', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 4),
            Text('${_reminders.where((r) => r['taken'] == true).length}/${_reminders.length} جرعات', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: _reminders.where((r) => r['taken'] == true).length / _reminders.length, backgroundColor: Colors.white24, color: Colors.white, minHeight: 6, borderRadius: BorderRadius.circular(3)),
          ]),
        ),
        // قائمة التذكيرات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: _reminders.length,
            itemBuilder: (context, index) {
              final r = _reminders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: (r['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(r['icon'], style: const TextStyle(fontSize: 22)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${r['dose']} • ${r['frequency']}', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                    Text(r['time'], style: TextStyle(fontSize: 12, color: r['taken'] ? AppColors.success : AppColors.warning, fontWeight: FontWeight.bold)),
                  ])),
                  Checkbox(value: r['taken'], activeColor: AppColors.success, onChanged: (v) => setState(() => r['taken'] = v)),
                ]),
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, backgroundColor: AppColors.primary, icon: const Icon(Icons.add), label: const Text('إضافة دواء')),
    );
  }
}
