import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

class EmergencyNumbers extends StatelessWidget {
  const EmergencyNumbers({super.key});

  @override
  Widget build(BuildContext context) {
    final emergencies = [
      {'name': 'الإسعاف', 'number': '191', 'icon': Icons.emergency, 'color': AppColors.error},
      {'name': 'الشرطة', 'number': '194', 'icon': Icons.local_police, 'color': AppColors.primary},
      {'name': 'الدفاع المدني', 'number': '199', 'icon': Icons.fire_truck, 'color': AppColors.deepOrange},
      {'name': 'طوارئ الكهرباء', 'number': '181', 'icon': Icons.electrical_services, 'color': AppColors.warning},
      {'name': 'طوارئ المياه', 'number': '187', 'icon': Icons.water_damage, 'color': AppColors.info},
      {'name': 'الخط الساخن الصحي', 'number': '123', 'icon': Icons.local_hospital, 'color': AppColors.success},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.emergencyNumbers)),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        itemCount: emergencies.length,
        itemBuilder: (context, index) {
          final emergency = emergencies[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: (emergency['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                  child: Icon(emergency['icon'] as IconData, color: emergency['color'] as Color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emergency['name'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        emergency['number'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: emergency['color'] as Color),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('tel:${emergency['number']}');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('اتصل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emergency['color'] as Color,
                    foregroundColor: AppColors.white,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
