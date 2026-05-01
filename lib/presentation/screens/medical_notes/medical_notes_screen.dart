import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class MedicalNotesScreen extends StatefulWidget {
  const MedicalNotesScreen({super.key});
  @override
  State<MedicalNotesScreen> createState() => _MedicalNotesScreenState();
}

class _MedicalNotesScreenState extends State<MedicalNotesScreen> {
  final List<Map<String, dynamic>> _notes = [
    {'title': 'أعراض الصداع', 'content': 'صداع في الجانب الأيمن يستمر 2-3 ساعات. يحدث عادة في المساء.', 'date': '1 مايو', 'color': AppColors.warning, 'icon': '🤕'},
    {'title': 'قراءات الضغط', 'content': 'الصباح 128/82، المساء 135/88. الطبيب نصح بمراقبة الأسبوعين القادمين.', 'date': '28 أبريل', 'color': AppColors.info, 'icon': '🩺'},
    {'title': 'موعد المختبر', 'content': 'حجزت موعد تحليل دم شامل يوم 15 مايو الساعة 8 صباحاً في مختبر الثقة.', 'date': '25 أبريل', 'color': AppColors.success, 'icon': '📅'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ملاحظاتي الطبية'), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})]),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final n = _notes[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: (n['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(n['icon'], style: const TextStyle(fontSize: 20)))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(n['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(n['date'], style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
                IconButton(icon: const Icon(Icons.edit, size: 18, color: AppColors.grey), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete, size: 18, color: AppColors.error), onPressed: () {}),
              ]),
              const SizedBox(height: 8),
              Text(n['content'], style: const TextStyle(fontSize: 13, color: AppColors.darkGrey, height: 1.4)),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, backgroundColor: AppColors.primary, child: const Icon(Icons.add)),
    );
  }
}
