import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class DueDateCalculatorScreen extends StatefulWidget {
  const DueDateCalculatorScreen({super.key});
  @override
  State<DueDateCalculatorScreen> createState() => _DueDateCalculatorScreenState();
}

class _DueDateCalculatorScreenState extends State<DueDateCalculatorScreen> {
  DateTime? _lastPeriodDate;
  DateTime? _dueDate;
  int _gestationalWeeks = 0;
  int _gestationalDays = 0;
  String _trimester = '';

  void _calculateDueDate() {
    if (_lastPeriodDate == null) return;
    _dueDate = _lastPeriodDate!.add(const Duration(days: 280));
    final diff = DateTime.now().difference(_lastPeriodDate!);
    _gestationalWeeks = diff.inDays ~/ 7;
    _gestationalDays = diff.inDays % 7;

    if (_gestationalWeeks < 13) {
      _trimester = 'الثلث الأول';
    } else if (_gestationalWeeks < 27) {
      _trimester = 'الثلث الثاني';
    } else {
      _trimester = 'الثلث الثالث';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = _dueDate != null ? _dueDate!.difference(DateTime.now()).inDays : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('حاسبة موعد الولادة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade300, Colors.purple.shade400]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [const Icon(Icons.cake, color: Colors.white, size: 40), const SizedBox(height: 8), const Text('حاسبة موعد الولادة', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const Text('أدخل تاريخ آخر دورة شهرية', style: TextStyle(color: Colors.white70, fontSize: 12))]),
          ),
          const SizedBox(height: 20),
          // اختيار التاريخ
          ListTile(
            title: const Text('تاريخ آخر دورة شهرية'),
            subtitle: Text(_lastPeriodDate != null ? '${_lastPeriodDate!.day}/${_lastPeriodDate!.month}/${_lastPeriodDate!.year}' : 'اضغط للاختيار'),
            leading: const Icon(Icons.calendar_today, color: AppColors.primary),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: DateTime.now().subtract(const Duration(days: 30)), firstDate: DateTime(2025), lastDate: DateTime.now());
              if (picked != null) {
                _lastPeriodDate = picked;
                _calculateDueDate();
              }
            },
          ),
          const SizedBox(height: 20),
          if (_dueDate != null) ...[
            // النتيجة
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
              child: Column(children: [
                const Text('🎉 موعد الولادة المتوقع', style: TextStyle(color: AppColors.grey, fontSize: 14)),
                const SizedBox(height: 8),
                Text('${_dueDate!.day} ${_getMonthName(_dueDate!.month)} ${_dueDate!.year}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year} م', style: const TextStyle(color: AppColors.grey)),
              ]),
            ),
            const SizedBox(height: 16),
            // معلومات الحمل
            Row(children: [
              _infoCard('عمر الحمل', '$_gestationalWeeks أسبوع\nو $_gestationalDays يوم', Icons.pregnant_woman, Colors.pink),
              const SizedBox(width: 10),
              _infoCard('الثلث', _trimester, Icons.baby_changing_station, AppColors.purple),
              const SizedBox(width: 10),
              _infoCard('متبقي', '$daysLeft يوم', Icons.hourglass_bottom, AppColors.info),
            ]),
            const SizedBox(height: 16),
            // جدول المتابعة
            Text('جدول المتابعة المقترح', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _appointmentCard('الزيارة الأولى', 'الأسبوع 8-10', 'تأكيد الحمل، فحوصات شاملة', true),
            _appointmentCard('فحص السونار', 'الأسبوع 12-14', 'السونار التفصيلي الأول', false),
            _appointmentCard('فحص السكر', 'الأسبوع 24-28', 'فحص سكر الحمل', false),
            _appointmentCard('متابعة شهرية', 'الأسبوع 28-36', 'زيارة كل أسبوعين', false),
            _appointmentCard('متابعة أسبوعية', 'الأسبوع 36-40', 'زيارة كل أسبوع', false),
          ],
        ]),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['', 'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return months[month];
  }

  Widget _infoCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(14)),
        child: Column(children: [Icon(icon, color: color, size: 24), const SizedBox(height: 6), Text(value, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)), Text(label, style: const TextStyle(fontSize: 9, color: AppColors.grey))]),
      ),
    );
  }

  Widget _appointmentCard(String title, String timing, String description, bool done) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: done ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1), child: Icon(done ? Icons.check : Icons.schedule, color: done ? AppColors.success : AppColors.warning, size: 18)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        subtitle: Text('$timing • $description', style: const TextStyle(fontSize: 10, color: AppColors.grey)),
      ),
    );
  }
}
