import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../delivery/delivery_options_screen.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});
  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _category = 'الكل';
  final Map<String, int> _cart = {};

  final List<Map<String, dynamic>> _meds = [
    {'id': 'med-1', 'name': 'باراسيتامول 500mg', 'price': 500, 'category': 'مسكنات', 'inStock': true, 'requiresPrescription': false, 'image': '💊'},
    {'id': 'med-2', 'name': 'إيبوبروفين 400mg', 'price': 800, 'category': 'مسكنات', 'inStock': true, 'requiresPrescription': false, 'image': '💊'},
    {'id': 'med-3', 'name': 'أموكسيسيلين 500mg', 'price': 1500, 'category': 'مضادات', 'inStock': true, 'requiresPrescription': true, 'image': '🧬'},
    {'id': 'med-4', 'name': 'فيتامين د3 1000IU', 'price': 1200, 'category': 'فيتامينات', 'inStock': true, 'requiresPrescription': false, 'image': '💪'},
    {'id': 'med-5', 'name': 'أملوديبين 5mg', 'price': 2000, 'category': 'قلب', 'inStock': true, 'requiresPrescription': true, 'image': '❤️'},
    {'id': 'med-6', 'name': 'ميتفورمين 500mg', 'price': 1000, 'category': 'سكري', 'inStock': true, 'requiresPrescription': true, 'image': '💉'},
    {'id': 'med-7', 'name': 'مونتيلوكاست 10mg', 'price': 2500, 'category': 'تنفسي', 'inStock': false, 'requiresPrescription': true, 'image': '🫁'},
    {'id': 'med-8', 'name': 'أزيثرومايسين 500mg', 'price': 3500, 'category': 'مضادات', 'inStock': true, 'requiresPrescription': true, 'image': '🧬'},
  ];

  int _getCartCount() => _cart.values.fold(0, (a, b) => a + b);
  int _getCartTotal() => _cart.entries.fold(0, (sum, e) => sum + (_meds.firstWhere((m) => m['id'] == e.key)['price'] * e.value));

  void _checkout() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('السلة فارغة')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryOptionsScreen(
          orderAmount: _getCartTotal().toInt().toDouble(),
        ),
      ),
    ).then((result) {
      if (result != null) {
        setState(() => _cart.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ تم الطلب! التوصيل عبر ${result['company']} - ${result['time']}'), backgroundColor: AppColors.success),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _category == 'الكل' ? _meds : _meds.where((m) => m['category'] == _category).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('الصيدلية', style: TextStyle(fontWeight: FontWeight.bold)), actions: [
        Stack(children: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: _checkout),
          if (_getCartCount() > 0) Positioned(right: 4, top: 4, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle), child: Text('${_getCartCount()}', style: const TextStyle(color: Colors.white, fontSize: 10)))),
        ]),
      ]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(10), child: TextField(controller: _searchCtrl, decoration: InputDecoration(hintText: 'ابحث عن دواء...', prefixIcon: const Icon(Icons.search), suffixIcon: const Icon(Icons.filter_list), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: AppColors.surfaceContainerLow))),
        SizedBox(height: 40, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 10), itemCount: 8, separatorBuilder: (_, __) => const SizedBox(width: 6), itemBuilder: (c, i) {
          final cats = ['الكل', 'مسكنات', 'مضادات', 'فيتامينات', 'قلب', 'سكري', 'تنفسي', 'حساسية'];
          final sel = _category == cats[i];
          return ChoiceChip(label: Text(cats[i], style: TextStyle(fontSize: 11, color: sel ? Colors.white : null)), selected: sel, selectedColor: AppColors.primary, onSelected: (v) => setState(() => _category = v! ? cats[i] : 'الكل'));
        })),
        Expanded(child: GridView.builder(padding: const EdgeInsets.all(10), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68, crossAxisSpacing: 8, mainAxisSpacing: 8), itemCount: filtered.length, itemBuilder: (c, i) {
          final m = filtered[i];
          final inCart = _cart[m['id']] ?? 0;
          return Container(
            padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(m['image'], style: const TextStyle(fontSize: 40)),
              Text(m['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              if (m['requiresPrescription']) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: const Text('بوصفة', style: TextStyle(fontSize: 8, color: AppColors.warning))),
              const Spacer(),
              Text('${m['price']} ر.ي', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
              if (m['inStock'])
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(icon: const Icon(Icons.remove_circle, color: AppColors.primary, size: 22), onPressed: inCart > 0 ? () => setState(() { if (inCart == 1) { _cart.remove(m['id']); } else { _cart[m['id']] = inCart - 1; } }) : null),
                  Text('$inCart', style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 22), onPressed: () => setState(() => _cart[m['id']] = inCart + 1)),
                ])
              else
                const Text('غير متوفر', style: TextStyle(color: AppColors.error, fontSize: 11)),
            ]),
          );
        })),
        if (_getCartCount() > 0)
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))]), child: SafeArea(child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${_getCartCount()} منتجات', style: const TextStyle(fontSize: 11, color: AppColors.grey)), Text('${_getCartTotal().toInt()} ر.ي', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))])),
            SizedBox(width: 160, height: 48, child: ElevatedButton.icon(onPressed: _checkout, icon: const Icon(Icons.delivery_dining), label: const Text('إتمام الطلب', style: TextStyle(fontSize: 14)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          ]))),
      ]),
    );
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }
}
