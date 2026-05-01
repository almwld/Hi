import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class DrugDictionaryScreen extends StatefulWidget {
  const DrugDictionaryScreen({super.key});
  @override
  State<DrugDictionaryScreen> createState() => _DrugDictionaryScreenState();
}

class _DrugDictionaryScreenState extends State<DrugDictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _drugs = const [
    {'name': 'باراسيتامول (Paracetamol)', 'category': 'مسكن ألم', 'usage': 'لتسكين الألم وخفض الحرارة', 'dose': '500mg - 1000mg كل 6-8 ساعات', 'sideEffects': 'نادر: حساسية جلدية', 'pregnancy': 'آمن', 'icon': '💊', 'color': AppColors.primary},
    {'name': 'إيبوبروفين (Ibuprofen)', 'category': 'مضاد التهاب', 'usage': 'للالتهابات وآلام المفاصل', 'dose': '200-400mg كل 6-8 ساعات', 'sideEffects': 'حرقة معدة، قرحة', 'pregnancy': 'غير آمن', 'icon': '💊', 'color': AppColors.error},
    {'name': 'أوميبرازول (Omeprazole)', 'category': 'مضاد حموضة', 'usage': 'لعلاج حرقة المعدة والقرحة', 'dose': '20-40mg يومياً', 'sideEffects': 'صداع، إسهال', 'pregnancy': 'باستشارة', 'icon': '💊', 'color': AppColors.success},
    {'name': 'أموكسيسيلين (Amoxicillin)', 'category': 'مضاد حيوي', 'usage': 'للالتهابات البكتيرية', 'dose': '500mg كل 8 ساعات', 'sideEffects': 'إسهال، حساسية', 'pregnancy': 'باستشارة', 'icon': '💊', 'color': AppColors.warning},
    {'name': 'ميتفورمين (Metformin)', 'category': 'خافض سكر', 'usage': 'لعلاج السكري النوع الثاني', 'dose': '500-850mg مع الأكل', 'sideEffects': 'غثيان، إسهال', 'pregnancy': 'باستشارة', 'icon': '💊', 'color': AppColors.info},
    {'name': 'أملوديبين (Amlodipine)', 'category': 'خافض ضغط', 'usage': 'لعلاج ارتفاع ضغط الدم', 'dose': '5-10mg يومياً', 'sideEffects': 'تورم القدمين، صداع', 'pregnancy': 'غير آمن', 'icon': '💊', 'color': AppColors.purple},
    {'name': 'سيتريزين (Cetirizine)', 'category': 'مضاد حساسية', 'usage': 'للحساسية الموسمية والجلدية', 'dose': '10mg يومياً', 'sideEffects': 'نعاس، جفاف فم', 'pregnancy': 'باستشارة', 'icon': '💊', 'color': AppColors.teal},
    {'name': 'سالبيوتامول (Salbutamol)', 'category': 'موسع شعب', 'usage': 'لعلاج أزمة الربو', 'dose': 'بختين عند الحاجة', 'sideEffects': 'رجفة، تسارع قلب', 'pregnancy': 'باستشارة', 'icon': '💊', 'color': AppColors.amber},
    {'name': 'ديكلوفيناك (Diclofenac)', 'category': 'مسكن ألم', 'usage': 'لآلام العضلات والمفاصل', 'dose': '50mg كل 8 ساعات', 'sideEffects': 'ألم معدة، دوخة', 'pregnancy': 'غير آمن', 'icon': '💊', 'color': AppColors.orange},
    {'name': 'فيتامين د (Vitamin D)', 'category': 'فيتامين', 'usage': 'لتقوية العظام والمناعة', 'dose': '1000-4000 IU يومياً', 'sideEffects': 'نادر بجرعات طبيعية', 'pregnancy': 'آمن', 'icon': '💊', 'color': AppColors.success},
    {'name': 'أزيثرومايسين (Azithromycin)', 'category': 'مضاد حيوي', 'usage': 'لالتهابات الجهاز التنفسي', 'dose': '500mg يومياً 3 أيام', 'sideEffects': 'إسهال، غثيان', 'pregnancy': 'باستشارة', 'icon': '💊', 'color': AppColors.info},
    {'name': 'ليفوثيروكسين (Levothyroxine)', 'category': 'هرمون الغدة', 'usage': 'لعلاج قصور الغدة الدرقية', 'dose': '25-100mcg صباحاً', 'sideEffects': 'خفقان، أرق', 'pregnancy': 'باستشارة', 'icon': '💊', 'color': AppColors.purple},
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _searchQuery.isEmpty ? _drugs : _drugs.where((d) => (d['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) || (d['category'] as String).contains(_searchQuery)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('قاموس الأدوية')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(hintText: 'ابحث عن دواء...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: AppColors.surfaceContainerLow, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final d = filtered[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
                child: ExpansionTile(
                  leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: (d['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(d['icon'], style: const TextStyle(fontSize: 20)))),
                  title: Text(d['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(d['category'], style: TextStyle(fontSize: 10, color: d['color'])),
                  children: [
                    _drugDetail('الاستخدام', d['usage']),
                    _drugDetail('الجرعة', d['dose']),
                    _drugDetail('آثار جانبية', d['sideEffects']),
                    _drugDetail('الحمل', d['pregnancy']),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _drugDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: AppColors.darkGrey))),
      ]),
    );
  }
}
