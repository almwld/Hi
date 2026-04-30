import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

class PatientPrescriptions extends StatelessWidget {
  const PatientPrescriptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.prescriptions)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          _buildPrescriptionCard(
            context,
            'د. أحمد علي',
            'طب القلب',
            '2024-01-15',
            [
              {'name': 'أملوديبين', 'dosage': '5mg', 'frequency': 'مرة يومياً'},
              {'name': 'ليسينوبريل', 'dosage': '10mg', 'frequency': 'مرة يومياً'},
            ],
          ),
          _buildPrescriptionCard(
            context,
            'د. سارة محمد',
            'طب الأطفال',
            '2024-02-20',
            [
              {'name': 'أموكسيسيلين', 'dosage': '250mg', 'frequency': '3 مرات يومياً'},
            ],
          ),
          _buildPrescriptionCard(
            context,
            'د. خالد عبدالله',
            'باطنية',
            '2024-03-10',
            [
              {'name': 'فيروسلف', 'dosage': '200mg', 'frequency': 'مرة يومياً'},
              {'name': 'فيتامين ب12', 'dosage': '1000mcg', 'frequency': 'مرة أسبوعياً'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context, String doctor, String specialty, String date, List<Map<String, String>> medications) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      specialty,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const Divider(height: 24),
          ...medications.map((med) => _buildMedicationRow(context, med)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('مشاركة'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.local_pharmacy, size: 18),
                  label: const Text('طلب دواء'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationRow(BuildContext context, Map<String, String> med) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medication, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med['name']!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${med['dosage']} - ${med['frequency']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
