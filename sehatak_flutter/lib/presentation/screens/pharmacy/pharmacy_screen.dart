import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});
  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  String _cat = 'الكل';
  int _cart = 0;

  final List<Map<String, dynamic>> _meds = const [
    {'name': 'بنادول إكسترا', 'desc': 'باراسيتامول 500mg', 'price': '500', 'old': '650', 'disc': '20%', 'img': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300', 'cat': 'مسكنات'},
    {'name': 'فيتامين د', 'desc': '1000IU مكمل', 'price': '1,200', 'old': '1,500', 'disc': '20%', 'img': 'https://images.unsplash.com/photo-1577174881658-0f30ed549adc?w=300', 'cat': 'فيتامينات'},
    {'name': 'أوجمنتين', 'desc': 'أموكسيسيلين 625mg', 'price': '1,800', 'old': '2,400', 'disc': '25%', 'img': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300', 'cat': 'مضادات'},
    {'name': 'فولتارين', 'desc': 'ديكلوفيناك جل', 'price': '850', 'old': '950', 'disc': '10%', 'img': 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=300', 'cat': 'مسكنات'},
    {'name': 'سنسوداين', 'desc': 'معجون أسنان', 'price': '950', 'old': '1,200', 'disc': '20%', 'img': 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=300', 'cat': 'عناية'},
    {'name': 'كالسى-د', 'desc': 'كالسيوم + فيتامين د3', 'price': '1,500', 'old': '1,800', 'disc': '15%', 'img': 'https://images.unsplash.com/photo-1585662040415-8a6b5dc52f50?w=300', 'cat': 'فيتامينات'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _cat == 'الكل' ? _meds : _meds.where((m) => m['cat'] == _cat).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('الصيدلية', style: TextStyle(fontWeight: FontWeight.bold)), actions: [Stack(children: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}), if (_cart > 0) Positioned(right: 4, top: 4, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle), child: Text('$_cart', style: const TextStyle(color: Colors.white, fontSize: 9))))])]),
      body: Column(children: [
        SizedBox(height: 42, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), itemCount: 4, separatorBuilder: (_, __) => const SizedBox(width: 6), itemBuilder: (c, i) {
          final cats = ['الكل', 'مسكنات', 'فيتامينات', 'مضادات'];
          return ChoiceChip(label: Text(cats[i], style: const TextStyle(fontSize: 10)), selected: _cat == cats[i], selectedColor: AppColors.primary, labelStyle: TextStyle(color: _cat == cats[i] ? Colors.white : null), onSelected: (v) => setState(() => _cat = v! ? cats[i] : 'الكل'));
        })),
        Expanded(child: GridView.builder(padding: const EdgeInsets.all(10), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.62, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: filtered.length, itemBuilder: (c, i) {
          final m = filtered[i];
          return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Stack(children: [
              Image.network(m['img'], height: 110, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 110, color: AppColors.primary.withOpacity(0.08), child: const Center(child: Icon(Icons.medication, size: 40, color: AppColors.primary)))),
              Positioned(top: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)), child: Text(m['disc'], style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)))),
            ])),
            Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(m['desc'], style: const TextStyle(fontSize: 10, color: AppColors.grey)),
              const SizedBox(height: 6),
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${m['price']} ر.ي', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)), Text('${m['old']} ر.ي', style: const TextStyle(fontSize: 9, color: AppColors.grey, decoration: TextDecoration.lineThrough))]),
                const Spacer(),
                GestureDetector(onTap: () => setState(() => _cart++), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add, color: Colors.white, size: 16))),
              ]),
            ])),
          ]));
        })),
      ]),
    );
  }
}
