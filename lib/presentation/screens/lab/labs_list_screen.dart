import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import 'lab_tests_screen.dart';

class LabsListScreen extends StatelessWidget {
  const LabsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final labs = [
      {'name': 'مختبر البرج الطبي', 'address': 'صنعاء - شارع الستين', 'rating': 4.9, 'isOpen': true, 'homeVisit': true},
      {'name': 'مختبر الشفاء', 'address': 'عدن - المنصورة', 'rating': 4.7, 'isOpen': true, 'homeVisit': false},
      {'name': 'مختبر الصفوة', 'address': 'تعز - شارع تعز', 'rating': 4.8, 'isOpen': true, 'homeVisit': true},
      {'name': 'مختبر الرحمة', 'address': 'الحديدة - شارع صنعاء', 'rating': 4.5, 'isOpen': false, 'homeVisit': false},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.labs), actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})]),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        itemCount: labs.length,
        itemBuilder: (context, index) {
          final lab = labs[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LabTestsScreen(labId: 'l$index'))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.science, color: AppColors.info, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lab['name'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(lab['address'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppColors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('${lab['rating']}'),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: (lab['isOpen'] as bool) ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (lab['isOpen'] as bool) ? 'مفتوح' : 'مغلق',
                                style: TextStyle(fontSize: 11, color: (lab['isOpen'] as bool) ? AppColors.success : AppColors.error),
                              ),
                            ),
                            if (lab['homeVisit'] as bool) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: const Text('زيارة منزلية', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
