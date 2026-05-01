import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class HealthCalendarScreen extends StatefulWidget {
  const HealthCalendarScreen({super.key});
  @override
  State<HealthCalendarScreen> createState() => _HealthCalendarScreenState();
}

class _HealthCalendarScreenState extends State<HealthCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2026, 5, 15): [{'title': 'موعد د. علي المولد', 'time': '10:30 ص', 'type': 'موعد'}],
    DateTime(2026, 5, 18): [{'title': 'موعد د. حسن رضا', 'time': '2:00 م', 'type': 'موعد'}],
    DateTime(2026, 5, 22): [{'title': 'موعد د. فاطمة', 'time': '9:00 ص', 'type': 'موعد'}, {'title': 'تذكير: تجديد وصفة', 'time': 'طوال اليوم', 'type': 'تذكير'}],
    DateTime(2026, 5, 25): [{'title': 'تحليل دم شامل', 'time': '8:00 ص', 'type': 'تحليل'}],
    DateTime(2026, 5, 10): [{'title': 'تذكير: قياس الضغط', 'time': 'مساءً', 'type': 'تذكير'}],
  ];

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForDay(_selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('التقويم الصحي'), actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})]),
      body: Column(children: [
        // تقويم
        Container(
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
          child: TableCalendar(
            firstDay: DateTime(2024),
            lastDay: DateTime(2028),
            focusedDay: _focusedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) => setState(() { _selectedDate = selectedDay; _focusedDay = focusedDay; }),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
            ),
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            locale: 'ar',
          ),
        ),
        // أحداث اليوم
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const Spacer(), Text('${events.length} أحداث', style: const TextStyle(color: AppColors.grey, fontSize: 12))]),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: events.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.event_busy, size: 60, color: AppColors.grey), SizedBox(height: 8), Text('لا توجد أحداث', style: TextStyle(color: AppColors.grey))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final e = events[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                      child: Row(children: [
                        Container(width: 4, height: 36, decoration: BoxDecoration(color: e['type'] == 'موعد' ? AppColors.primary : e['type'] == 'تحليل' ? AppColors.info : AppColors.warning, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e['title']!, style: const TextStyle(fontWeight: FontWeight.w500)), Text(e['time']!, style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(6)), child: Text(e['type']!, style: const TextStyle(fontSize: 9, color: AppColors.primary))),
                      ]),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
