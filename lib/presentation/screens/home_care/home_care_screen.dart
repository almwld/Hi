import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class HomeCareScreen extends StatelessWidget {
  const HomeCareScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('خدمات منزلية')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.home_work, size: 80, color: AppColors.primary), SizedBox(height: 20), Text('خدمات منزلية', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('8 خدمات طبية منزلية')])));
  }
}
