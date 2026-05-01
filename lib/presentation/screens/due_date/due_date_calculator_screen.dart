import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class DueDateCalculatorScreen extends StatelessWidget {
  const DueDateCalculatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('حاسبة الولادة')), body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cake, size: 80, color: Colors.pink), SizedBox(height: 20), Text('موعد الولادة المتوقع', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('280 يوم من آخر دورة')])));
  }
}
