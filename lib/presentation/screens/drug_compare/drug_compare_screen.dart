import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class DrugCompareScreen extends StatefulWidget {
  const DrugCompareScreen({super.key});
  @override
  State<DrugCompareScreen> createState() => _DrugCompareScreenState();
}

class _DrugCompareScreenState extends State<DrugCompareScreen> {
  String _selectedDrug1 = 'باراسيتامول';
  String _selectedDrug2 = 'إيبوبروفين';

  final Map<String, Map<String, String>> _drugs = {
    'باراسيتامول': {'category': 'مسكن ألم', 'usage': 'ألم، حمى', 'onset': '30-60 دقيقة', 'duration': '4-6 ساعات', 'pregnancy': 'آمن', 'stomach': 'لطيف', 'price': 'رخيص'},
    'إيبوبروفين': {'category': 'مضاد التهاب', 'usage': 'التهاب، ألم', 'onset': '30-60 دقيقة', 'duration': '6-8 ساعات', 'pregnancy': 'خطر', 'stomach': 'قوي', 'price': 'رخيص'},
    'ديكلوفيناك': {'category': 'مضاد التهاب', 'usage': 'مفاصل، عضلات', 'onset': '20-30 دقيقة', 'duration': '8-12 ساعات', 'pregnancy': 'خطر', 'stomach': 'قوي جداً', 'price': 'متوسط'},
    'نابروكسين': {'category': 'مضاد التهاب', 'usage': 'نقرس، مفاصل', 'onset': 'ساعة', 'duration': '12 ساعة', 'pregnancy': 'خطر', 'stomach': 'قوي', 'price': 'متوسط'},
  ];

  @override
  Widget build(BuildContext context) {
    final d1 = _drugs[_selectedDrug1]!;
    final d2 = _drugs[_selectedDrug2]!;

    return Scaffold(
      appBar: AppBar(title: const Text('مقارنة الأدوية', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // اختيار الدوائين
          Row(children: [
            Expanded(child: _drugDropdown(_selectedDrug1, (v) => setState(() => _selectedDrug1 = v!))),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('VS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary))),
            Expanded(child: _drugDropdown(_selectedDrug2, (v) => setState(() => _selectedDrug2 = v!))),
          ]),
          const SizedBox(height: 16),
          // جدول المقارنة
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
            child: Table(
              border: TableBorder.all(color: AppColors.outlineVariant.withOpacity(0.3)),
              columnWidths: const {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2)},
              children: [
                _tableRow('الميزة', _selectedDrug1, _selectedDrug2, isHeader: true),
                _tableRow('التصنيف', d1['category']!, d2['category']!),
                _tableRow('الاستخدام', d1['usage']!, d2['usage']!),
                _tableRow('بدء التأثير', d1['onset']!, d2['onset']!),
                _tableRow('المدة', d1['duration']!, d2['duration']!),
                _tableRow('الحمل', d1['pregnancy']!, d2['pregnancy']!),
                _tableRow('تأثير المعدة', d1['stomach']!, d2['stomach']!),
                _tableRow('السعر', d1['price']!, d2['price']!),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.warning.withOpacity(0.2))), child: const Text('⚠️ استشر الطبيب قبل تناول أي دواء', style: TextStyle(fontSize: 12, color: AppColors.warning))),
        ]),
      ),
    );
  }

  Widget _drugDropdown(String value, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(value: value, isExpanded: true, items: _drugs.keys.map((k) => DropdownMenuItem(value: k, child: Text(k, style: const TextStyle(fontSize: 12)))).toList(), onChanged: onChanged),
      ),
    );
  }

  TableRow _tableRow(String label, String v1, String v2, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader ? BoxDecoration(color: AppColors.primary.withOpacity(0.08)) : null,
      children: [
        Padding(padding: const EdgeInsets.all(10), child: Text(label, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.w500, fontSize: 11))),
        Padding(padding: const EdgeInsets.all(10), child: Text(v1, style: TextStyle(fontSize: 11, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.center)),
        Padding(padding: const EdgeInsets.all(10), child: Text(v2, style: TextStyle(fontSize: 11, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.center)),
      ],
    );
  }
}
