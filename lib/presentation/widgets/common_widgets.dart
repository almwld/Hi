import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class DoctorCard extends StatelessWidget {
  final String name, specialty, experience;
  final double rating;
  final int reviews;
  final VoidCallback onTap;
  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.experience,
    this.rating = 4.5,
    this.reviews = 100,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        child: Row(children: [
          CircleAvatar(radius: 28, backgroundColor: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.person, color: AppColors.primary, size: 30)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(specialty, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
            const SizedBox(height: 2),
            Text(experience, style: const TextStyle(color: AppColors.darkGrey, fontSize: 11)),
            Row(children: [
              const Icon(Icons.star, color: AppColors.amber, size: 14),
              Text(' $rating ($reviews reviews)', style: const TextStyle(fontSize: 11, color: AppColors.darkGrey)),
            ]),
          ])),
          const Icon(Icons.chevron_left, color: AppColors.grey),
        ]),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String name, description, price, discount;
  final VoidCallback onAddToCart;
  const MedicineCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    this.discount = '',
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (discount.isNotEmpty)
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)), child: Text(discount, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
        const SizedBox(height: 8),
        const Icon(Icons.medication, color: AppColors.primary, size: 40),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 2),
        Text(description, style: const TextStyle(fontSize: 10, color: AppColors.grey)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Rs. $price', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
          ElevatedButton(onPressed: onAddToCart, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), minimumSize: Size.zero), child: const Text('Add to Cart', style: TextStyle(fontSize: 10))),
        ]),
      ]),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final String hint;
  const CustomSearchBar({super.key, this.hint = 'Search...'});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
