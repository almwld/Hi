import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'title': 'تذكير بموعد طبي', 'body': 'لديك موعد مع د. أحمد علي غداً الساعة 10:00 ص', 'time': 'منذ 5 دقائق', 'icon': Icons.calendar_today, 'color': AppColors.primary, 'read': false},
      {'title': 'نتائج تحليل جاهزة', 'body': 'نتائج تحليل CBC جاهزة للاطلاع', 'time': 'منذ ساعة', 'icon': Icons.science, 'color': AppColors.info, 'read': false},
      {'title': 'عرض خاص', 'body': 'خصم 20% على الفحوصات الشاملة في مختبر البرج', 'time': 'منذ 3 ساعات', 'icon': Icons.local_offer, 'color': AppColors.warning, 'read': true},
      {'title': 'تذكير بالدواء', 'body': 'حان وقت تناول أملوديبين', 'time': 'منذ 5 ساعات', 'icon': Icons.medication, 'color': AppColors.success, 'read': true},
      {'title': 'تم تأكيد الحجز', 'body': 'تم تأكيد حجزك مع د. سارة محمد', 'time': 'أمس', 'icon': Icons.check_circle, 'color': AppColors.success, 'read': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notifications),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('تحديد الكل مقروء', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: (notification['read'] as bool)
                  ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3)
                  : (notification['color'] as Color).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (notification['read'] as bool) ? AppColors.outlineVariant.withOpacity(0.5) : (notification['color'] as Color).withOpacity(0.3),
                width: (notification['read'] as bool) ? 1 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: (notification['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(notification['icon'] as IconData, color: notification['color'] as Color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] as String,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: (notification['read'] as bool) ? FontWeight.normal : FontWeight.w600,
                                  ),
                            ),
                          ),
                          if (!(notification['read'] as bool))
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: notification['color'] as Color, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(notification['body'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.darkGrey)),
                      const SizedBox(height: 4),
                      Text(notification['time'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey, fontSize: 10)),
                    ],
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
