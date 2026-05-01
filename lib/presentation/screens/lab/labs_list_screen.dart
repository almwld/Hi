import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class LabsListScreen extends StatefulWidget {
  const LabsListScreen({super.key});
  @override
  State<LabsListScreen> createState() => _LabsListScreenState();
}

class _LabsListScreenState extends State<LabsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCity = 'All';

  final List<String> _cities = ['All', 'Karachi', 'Lahore', 'Islamabad', 'Peshawar', 'Quetta'];

  final List<Map<String, dynamic>> _labs = [
    {'name': 'Aga Khan Lab', 'city': 'Karachi', 'rating': 4.9, 'tests': '500+', 'accredited': true, 'homeService': true, 'price': 'From Rs. 500', 'time': '24 Hours', 'image': '🔬'},
    {'name': 'Chughtai Lab', 'city': 'Lahore', 'rating': 4.8, 'tests': '400+', 'accredited': true, 'homeService': true, 'price': 'From Rs. 400', 'time': '8 AM - 10 PM', 'image': '🧪'},
    {'name': 'IDC Lab', 'city': 'Islamabad', 'rating': 4.7, 'tests': '350+', 'accredited': true, 'homeService': true, 'price': 'From Rs. 450', 'time': '24 Hours', 'image': '🩸'},
    {'name': 'Excel Lab', 'city': 'Karachi', 'rating': 4.5, 'tests': '300+', 'accredited': true, 'homeService': false, 'price': 'From Rs. 350', 'time': '9 AM - 9 PM', 'image': '💉'},
    {'name': 'Islamabad Diagnostic', 'city': 'Islamabad', 'rating': 4.6, 'tests': '280+', 'accredited': true, 'homeService': true, 'price': 'From Rs. 380', 'time': '24 Hours', 'image': '🧫'},
    {'name': 'Rehman Lab', 'city': 'Peshawar', 'rating': 4.4, 'tests': '200+', 'accredited': false, 'homeService': true, 'price': 'From Rs. 300', 'time': '8 AM - 8 PM', 'image': '🔬'},
    {'name': 'Bolan Lab', 'city': 'Quetta', 'rating': 4.3, 'tests': '150+', 'accredited': true, 'homeService': false, 'price': 'From Rs. 280', 'time': '9 AM - 7 PM', 'image': '🧪'},
    {'name': 'Lahore Diagnostic', 'city': 'Lahore', 'rating': 4.7, 'tests': '450+', 'accredited': true, 'homeService': true, 'price': 'From Rs. 420', 'time': '24 Hours', 'image': '🩸'},
  ];

  List<Map<String, dynamic>> get _filteredLabs {
    var labs = _labs;
    if (_selectedCity != 'All') labs = labs.where((l) => l['city'] == _selectedCity).toList();
    final q = _searchController.text.toLowerCase();
    if (q.isNotEmpty) labs = labs.where((l) => l['name'].toString().toLowerCase().contains(q) || l['city'].toString().toLowerCase().contains(q)).toList();
    return labs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostic Labs', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: 'Search labs...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: AppColors.surfaceContainerLow, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: _cities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, index) {
              final city = _cities[index];
              final selected = _selectedCity == city;
              return ChoiceChip(label: Text(city), selected: selected, selectedColor: AppColors.primary, labelStyle: TextStyle(color: selected ? Colors.white : AppColors.darkGrey, fontSize: 11), onSelected: (_) => setState(() => _selectedCity = city));
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _filteredLabs.length,
            itemBuilder: (context, index) => _buildLabCard(_filteredLabs[index]),
          ),
        ),
      ]),
    );
  }

  Widget _buildLabCard(Map<String, dynamic> lab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
      child: Row(children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(lab['image'], style: const TextStyle(fontSize: 24)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(lab['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            if (lab['accredited'] == true) ...[const SizedBox(width: 6), const Icon(Icons.verified, color: AppColors.info, size: 16)],
          ]),
          Text(lab['city'], style: const TextStyle(fontSize: 11, color: AppColors.grey)),
          Row(children: [
            const Icon(Icons.star, color: AppColors.amber, size: 14),
            Text(' ${lab['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 8),
            const Icon(Icons.science, size: 14, color: AppColors.grey),
            Text(' ${lab['tests']} tests', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
          ]),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (lab['homeService'] == true) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: const Text('Home', style: TextStyle(fontSize: 8, color: AppColors.success))),
          const SizedBox(height: 4),
          Text(lab['price'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
          Text(lab['time'], style: const TextStyle(fontSize: 9, color: AppColors.grey)),
        ]),
      ]),
    );
  }
}
