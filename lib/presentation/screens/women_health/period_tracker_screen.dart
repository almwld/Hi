import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({super.key});
  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  int _cycleDay = 15;
  final int _cycleLength = 28;

  @override
  Widget build(BuildContext context) {
    final phase = _cycleDay <= 5 ? 'حيض' : _cycleDay <= 13 ? 'جريبي' : _cycleDay <= 16 ? 'إباضة' : 'أصفري';
    final phaseColor = phase == 'حيض' ? AppColors.error : phase == 'إباضة' ? AppColors.success : AppColors.info;

    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الدورة الشهرية', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade300, Colors.purple.shade400]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Text("اليوم $_cycleDay من $_cycleLength", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(12)), child: Text('مرحلة: $phase', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: _cycleDay / _cycleLength, backgroundColor: Colors.white24, color: Colors.white, minHeight: 6, borderRadius: BorderRadius.circular(3)),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            _infoCard('الدورة القادمة', '${28 - _cycleDay} يوم', Icons.event, AppColors.primary),
            const SizedBox(width: 8),
            _infoCard('الإباضة', _cycleDay <= 14 ? '${14 - _cycleDay} يوم' : 'تمت', Icons.star, AppColors.success),
            const SizedBox(width: 8),
            _infoCard('المرحلة', phase, Icons.info, phaseColor),
          ]),
          const SizedBox(height: 16),
          Text('أعراض اليوم', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            _symptomChip('😊', 'طبيعي', false),
            _symptomChip('😣', 'تقلصات', true),
            _symptomChip('😴', 'تعب', false),
            _symptomChip('😤', 'انتفاخ', true),
            _symptomChip('🤕', 'صداع', false),
            _symptomChip('🍫', 'اشتهاء', true),
            _symptomChip('😢', 'مزاجية', false),
            _symptomChip('💤', 'أرق', false),
          ]),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(14)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('💡 نصائح لهذه المرحلة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 8),
            Text('• اشربي الماء الدافئ', style: TextStyle(fontSize: 12)),
            Text('• مارسي المشي الخفيف', style: TextStyle(fontSize: 12)),
            Text('• تجنبي الكافيين', style: TextStyle(fontSize: 12)),
            Text('• تناولي الأطعمة الغنية بالحديد', style: TextStyle(fontSize: 12)),
          ])),
        ]),
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12)), child: Column(children: [Icon(icon, color: color, size: 20), const SizedBox(height: 4), Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)), Text(label, style: const TextStyle(fontSize: 9, color: AppColors.grey))])),
    );
  }

  Widget _symptomChip(String emoji, String label, bool active) {
    return FilterChip(
      label: Text('$emoji $label', style: const TextStyle(fontSize: 10)),
      selected: active,
      selectedColor: Colors.pink.shade100,
      checkmarkColor: Colors.pink,
      onSelected: (_) {},
    );
  }
}
