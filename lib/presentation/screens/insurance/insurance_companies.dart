import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import 'insurance_plans.dart';

class InsuranceCompanies extends StatelessWidget {
  const InsuranceCompanies({super.key});

  @override
  Widget build(BuildContext context) {
    final companies = [
      {'name': 'شركة يمنية للتأمين', 'rating': 4.8, 'plans': 5, 'logo': Icons.shield},
      {'name': 'التأمين الوطني', 'rating': 4.6, 'plans': 3, 'logo': Icons.security},
      {'name': 'تأمين الصحة الأولى', 'rating': 4.9, 'plans': 7, 'logo': Icons.health_and_safety},
      {'name': 'الشركة العربية للتأمين', 'rating': 4.5, 'plans': 4, 'logo': Icons.verified_user},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.insuranceCompanies)),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InsurancePlans(companyId: 'c$index'))),
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
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(company['logo'] as IconData, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(company['name'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppColors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('${company['rating']}'),
                            const SizedBox(width: 16),
                            Text('${company['plans']} خطط', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey)),
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
