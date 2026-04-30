import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/widgets/common_widgets.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pharmacy'), actions: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CustomSearchBar(hint: 'Search medicines, brands, and more...'),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(10)), child: const Row(children: [Icon(Icons.location_on, color: AppColors.primary, size: 16), SizedBox(width: 4), Text('Deliver to: Home - Block 7, Clifton, Karachi', style: TextStyle(fontSize: 11)), Spacer(), Icon(Icons.edit, size: 14, color: AppColors.grey)])),
          const SizedBox(height: 16),
          // التصنيفات
          SizedBox(
            height: 40,
            child: ListView(scrollDirection: Axis.horizontal, children: ['All', 'Prescription', 'OTC', 'Vitamins', 'Personal Care', 'Baby Care'].map((e) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(e), selected: e == 'All', selectedColor: AppColors.primary, labelStyle: TextStyle(color: e == 'All' ? Colors.white : AppColors.darkGrey, fontSize: 12), backgroundColor: AppColors.surfaceContainerLow, onSelected: (_) {}))).toList()),
          ),
          const SizedBox(height: 16),
          // شبكة الأدوية
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
            children: [
              MedicineCard(name: 'Panadol Extra', description: 'Paracetamol 500mg\n24 Tablets', price: '120', discount: '20% OFF', onAddToCart: () {}),
              MedicineCard(name: 'Supradyn Daily', description: 'Multivitamin\n30 Tablets', price: '1,275', discount: '15% OFF', onAddToCart: () {}),
              MedicineCard(name: 'Augmentin 625mg', description: 'Amoxicillin + Clavulanic\n10 Tablets', price: '1,162', discount: '25% OFF', onAddToCart: () {}),
              MedicineCard(name: 'Voltral Emulgel', description: 'Diclofenac Gel\n50g', price: '585', discount: '10% OFF', onAddToCart: () {}),
              MedicineCard(name: 'Becovit', description: 'Vitamin B-Complex\n20 Tablets', price: '280', discount: '20% OFF', onAddToCart: () {}),
              MedicineCard(name: 'Calci-D', description: 'Calcium + Vitamin D3\n30 Tablets', price: '850', discount: '15% OFF', onAddToCart: () {}),
            ],
          ),
          const SizedBox(height: 24),
          // ضمانات
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(14)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _guaranteeItem(Icons.verified, '100% Genuine\nAuthentic Medicines'),
            _guaranteeItem(Icons.delivery_dining, 'Fast Delivery\nOn time, every time'),
            _guaranteeItem(Icons.support_agent, '24/7 Support\nWe\'re here to help'),
          ])),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _guaranteeItem(IconData icon, String text) {
    return Column(children: [Icon(icon, color: AppColors.primary), const SizedBox(height: 4), Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))]);
  }
}
