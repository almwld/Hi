import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class PeriodTrackerScreen extends StatelessWidget {
  const PeriodTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('الدورة الشهرية')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.female, size: 80, color: Colors.pink), SizedBox(height: 20), Text('تتبع الدورة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('15 يوم حتى الدورة القادمة')])));
  }
}
