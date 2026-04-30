import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

class PatientMedicalHistory extends StatelessWidget {
  const PatientMedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.medicalHistory)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          _buildRecordCard(
            context,
            'تشخيص: ارتفاع ضغط الدم',
            'د. أحمد علي',
            'طب القلب',
            '2024-01-15',
            AppColors.error,
            Icons.favorite_border,
          ),
          _buildRecordCard(
            context,
            'تشخيص: التهاب الجيوب الأنفية',
            'د. سارة محمد',
            'أنف وأذن وحنجرة',
            '2024-02-20',
            AppColors.warning,
            Icons.healing,
          ),
          _buildRecordCard(
            context,
            'تشخيص: فقر الدم',
            'د. خالد عبدالله',
            'باطنية',
            '2024-03-10',
            AppColors.info,
            Icons.bloodtype_outlined,
          ),
          _buildRecordCard(
            context,
            'فحص دوري',
            'د. فاطمة أحمد',
            'طب العائلة',
            '2024-04-05',
            AppColors.success,
            Icons.check_circle_outline,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, String title, String doctor, String specialty, String date, Color color, IconData icon) {
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$doctor - $specialty',
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
        ],
      ),
    );
  }
}
