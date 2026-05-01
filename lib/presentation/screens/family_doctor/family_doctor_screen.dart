import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class FamilyDoctorScreen extends StatelessWidget {
  const FamilyDoctorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('طبيب العائلة')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.family_restroom, size: 80, color: AppColors.primary), SizedBox(height: 20), Text('عائلة محمد', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('5 أفراد')])));
  }
}
