import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class GlucoseTrackerScreen extends StatefulWidget {
  const GlucoseTrackerScreen({super.key});
  @override
  State<GlucoseTrackerScreen> createState() => _GlucoseTrackerScreenState();
}

class _GlucoseTrackerScreenState extends State<GlucoseTrackerScreen> {
  // قراءات اليوم
  final List<Map<String, dynamic>> _todayReadings = [
    {'time': 'قبل الفطور', 'value': 95, 'status': 'طبيعي', 'icon': '☀️', 'recommended': '70-110', 'note': ''},
    {'time': 'بعد الفطور', 'value': 140, 'status': 'مرتفع', 'icon': '🍳', 'recommended': 'أقل من 140', 'note': 'تجنب الخبز الأبيض'},
    {'time': 'قبل الغداء', 'value': 88, 'status': 'طبيعي', 'icon': '🌤️', 'recommended': '70-110', 'note': ''},
    {'time': 'بعد الغداء', 'value': 155, 'status': 'مرتفع', 'icon': '🍛', 'recommended': 'أقل من 140', 'note': 'قلل كمية الرز'},
    {'time': 'قبل العشاء', 'value': 102, 'status': 'طبيعي', 'icon': '🌅', 'recommended': '70-110', 'note': ''},
    {'time': 'بعد العشاء', 'value': 180, 'status': 'عالي', 'icon': '🌙', 'recommended': 'أقل من 140', 'note': 'لا تأكل قبل النوم'},
  ];

  // قراءات الأسبوع
  final List<Map<String, dynamic>> _weekReadings = [
    {'day': 'سبت', 'morning': 95, 'evening': 140},
    {'day': 'أحد', 'morning': 102, 'evening': 135},
    {'day': 'إثنين', 'morning': 88, 'evening': 155},
    {'day': 'ثلاثاء', 'morning': 98, 'evening': 148},
    {'day': 'أربعاء', 'morning': 92, 'evening': 142},
    {'day': 'خميس', 'morning': 105, 'evening': 138},
    {'day': 'جمعة', 'morning': 100, 'evening': 180},
  ];

  double get _avgFasting {
    final vals = _weekReadings.map((r) => r['morning'] as int).toList();
    return vals.reduce((a, b) => a + b) / vals.length;
  }

  double get _avgPostMeal {
    final vals = _weekReadings.map((r) => r['evening'] as int).toList();
    return vals.reduce((a, b) => a + b) / vals.length;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'طبيعي': return AppColors.success;
      case 'مرتفع': return AppColors.warning;
      case 'عالي': return AppColors.error;
      default: return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع السكر', style: TextStyle(fontWeight: FontWeight.bold)), actions: [IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}), IconButton(icon: const Icon(Icons.add), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // بطاقة المتوسط
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade300, Colors.blue.shade700]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              const Text('متوسط السكر التراكمي المقدر', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              const Text('5.7%', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
              const Text('HbA1c تقديري', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _avgCard('صائم', '${_avgFasting.toStringAsFixed(0)} mg/dL', 'طبيعي >110'),
                _avgCard('بعد الأكل', '${_avgPostMeal.toStringAsFixed(0)} mg/dL', 'طبيعي >140'),
              ]),
            ]),
          ),
          const SizedBox(height: 18),

          // قراءات اليوم
          Text('قراءات اليوم', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._todayReadings.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)]),
            child: Row(children: [
              Text(r['icon'], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['time'], style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                if (r['note'].toString().isNotEmpty) Text(r['note'], style: const TextStyle(fontSize: 10, color: AppColors.grey)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${r['value']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primary)),
                Text('mg/dL', style: const TextStyle(fontSize: 9, color: AppColors.grey)),
                const SizedBox(height: 4),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: _statusColor(r['status']).withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text('${r['status']} (${r['recommended']})', style: TextStyle(fontSize: 9, color: _statusColor(r['status'])))),
              ]),
            ]),
          )),
          const SizedBox(height: 18),

          // رسم الأسبوع
          Text('نظرة أسبوعية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
            height: 200,
            child: Column(children: [
              Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 4), const Text('صائم', style: TextStyle(fontSize: 10, color: AppColors.grey)), const SizedBox(width: 12), Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 4), const Text('بعد الأكل', style: TextStyle(fontSize: 10, color: AppColors.grey))]),
              const SizedBox(height: 10),
              Expanded(
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: _weekReadings.map((r) {
                  final morningH =(r["morning"] as int - 70) / 110 * 120;
                  final eveningH = (r["evening"] as int - 70) / 110 * 120;
                  return Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text('${r['evening']}', style: const TextStyle(fontSize: 8, color: Colors.orange)),
                      Container(width: 14, height: eveningH, decoration: BoxDecoration(color: Colors.orange.withOpacity(0.6), borderRadius: BorderRadius.circular(3))),
                      const SizedBox(height: 2),
                      Text('${r['morning']}', style: const TextStyle(fontSize: 8, color: Colors.blue)),
                      Container(width: 14, height: morningH, decoration: BoxDecoration(color: Colors.blue.withOpacity(0.6), borderRadius: BorderRadius.circular(3))),
                      const SizedBox(height: 4),
                      Text(r['day'], style: const TextStyle(fontSize: 9, color: AppColors.grey)),
                    ]),
                  );
                }).toList()),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // نصائح
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(14)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('💡 نصائح للتحكم بالسكر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 8),
              Text('• قس السكر قبل الأكل وبعده بساعتين', style: TextStyle(fontSize: 12)),
              Text('• تجنب العصائر والمشروبات المحلاة', style: TextStyle(fontSize: 12)),
              Text('• تناول الخضروات الورقية بكثرة', style: TextStyle(fontSize: 12)),
              Text('• مارس المشي 30 دقيقة يومياً', style: TextStyle(fontSize: 12)),
              Text('• راجع الطبيب إذا تكررت القراءات المرتفعة', style: TextStyle(fontSize: 12)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _avgCard(String label, String value, String range) {
    return Column(children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      Text(range, style: const TextStyle(color: Colors.white60, fontSize: 9)),
    ]);
  }
}
