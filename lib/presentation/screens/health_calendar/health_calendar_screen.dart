import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class HealthCalendarScreen extends StatefulWidget {
  const HealthCalendarScreen({super.key});
  @override
  State<HealthCalendarScreen> createState() => _HealthCalendarScreenState();
}

class _HealthCalendarScreenState extends State<HealthCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    if (day.day == 15 && day.month == 5) return [{'title': 'موعد د. علي المولد', 'time': '10:30 ص', 'type': 'موعد'}];
    if (day.day == 18 && day.month == 5) return [{'title': 'موعد د. حسن رضا', 'time': '2:00 م', 'type': 'موعد'}];
    if (day.day == 22 && day.month == 5) return [{'title': 'موعد د. فاطمة', 'time': '9:00 ص', 'type': 'موعد'}, {'title': 'تذكير: تجديد وصفة', 'time': 'طوال اليوم', 'type': 'تذكير'}];
    if (day.day == 25 && day.month == 5) return [{'title': 'تحليل دم شامل', 'time': '8:00 ص', 'type': 'تحليل'}];
    if (day.day == 10 && day.month == 5) return [{'title': 'تذكير: قياس الضغط', 'time': 'مساءً', 'type': 'تذكير'}];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForDay(_selectedDate);
    return Scaffold(
      appBar: AppBar(title: const Text('التقويم الصحي'), actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})]),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
          child: TableCalendar(
            firstDay: DateTime(2024),
            lastDay: DateTime(2028),
            focusedDay: _focusedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) => setState(() { _selectedDate = selectedDay; _focusedDate = focusedDay; }),
            calendarStyle: CalendarStyle(selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), todayDecoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle)),
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            locale: 'ar',
          ),
        ),
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
