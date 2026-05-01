import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('نصائح صحية')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.tips_and_updates, size: 80, color: AppColors.success), SizedBox(height: 20), Text('نصائح صحية', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('30 نصيحة في 6 تصنيفات')])));
  }
}
