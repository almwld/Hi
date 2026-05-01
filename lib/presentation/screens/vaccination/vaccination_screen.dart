import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class VaccinationScreen extends StatelessWidget {
  const VaccinationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('التطعيمات')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.vaccines, size: 80, color: AppColors.success), SizedBox(height: 20), Text('سجل التطعيمات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('7 تطعيمات مكتملة • 3 موصى بها')])));
  }
}
