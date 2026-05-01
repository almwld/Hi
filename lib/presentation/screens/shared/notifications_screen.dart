import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {'title': 'Appointment Reminder', 'message': 'You have an appointment with Dr. Ayesha Rahman tomorrow at 10:30 AM', 'time': '5 min ago', 'icon': Icons.calendar_today, 'color': AppColors.primary, 'read': false},
    {'title': 'Lab Results Ready', 'message': 'Your CBC test results are now available. Tap to view.', 'time': '1 hour ago', 'icon': Icons.science, 'color': AppColors.info, 'read': false},
    {'title': 'Prescription Renewed', 'message': 'Dr. Hassan Raza has renewed your prescription for Hypertension medication.', 'time': '3 hours ago', 'icon': Icons.receipt, 'color': AppColors.success, 'read': false},
    {'title': 'Health Tip', 'message': 'Drink 8 glasses of water daily for better health!', 'time': 'Yesterday', 'icon': Icons.tips_and_updates, 'color': AppColors.amber, 'read': true},
    {'title': 'New Offer', 'message': '20% off on all lab tests at Aga Khan Lab. Limited time!', 'time': '2 days ago', 'icon': Icons.local_offer, 'color': AppColors.purple, 'read': true},
    {'title': 'Video Call Reminder', 'message': 'Your video consultation with Dr. Usman Khan starts in 30 minutes.', 'time': '2 days ago', 'icon': Icons.videocam, 'color': AppColors.teal, 'read': true},
    {'title': 'Insurance Claim', 'message': 'Your claim #SH-2024-089 has been approved by Jubilee Insurance.', 'time': '3 days ago', 'icon': Icons.shield, 'color': AppColors.indigo, 'read': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [TextButton(onPressed: () => setState(() { for (var n in _notifications) { n['read'] = true; } }), child: const Text('Mark All Read'))],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: n['read'] ? Colors.transparent : (n['color'] as Color).withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: n['read'] ? AppColors.outlineVariant.withOpacity(0.3) : (n['color'] as Color).withOpacity(0.2)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: (n['color'] as Color).withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(n['icon'], color: n['color'], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  if (!n['read']) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                  if (!n['read']) const SizedBox(width: 6),
                  Expanded(child: Text(n['title'], style: TextStyle(fontWeight: n['read'] ? FontWeight.normal : FontWeight.bold, fontSize: 14))),
                  Text(n['time'], style: const TextStyle(fontSize: 10, color: AppColors.grey)),
                ]),
                const SizedBox(height: 4),
                Text(n['message'], style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
              ])),
            ]),
          );
        },
      ),
    );
  }
}
