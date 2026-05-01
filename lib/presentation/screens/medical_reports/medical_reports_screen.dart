import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class MedicalReportsScreen extends StatelessWidget {
  const MedicalReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('تقارير طبية')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.description, size: 80, color: AppColors.primary), SizedBox(height: 20), Text('التقارير الطبية', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('7 تقارير مخزنة')])));
  }
}
