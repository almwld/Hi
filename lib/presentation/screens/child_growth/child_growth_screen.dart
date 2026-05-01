import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class ChildGrowthScreen extends StatelessWidget {
  const ChildGrowthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('نمو الطفل')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.child_care, size: 80, color: Colors.pink), SizedBox(height: 20), Text('مراحل نمو الطفل', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('6 مراحل عمرية')])));
  }
}
