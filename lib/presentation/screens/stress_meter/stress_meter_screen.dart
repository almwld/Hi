import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class StressMeterScreen extends StatelessWidget {
  const StressMeterScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('مقياس التوتر')), body: const Center(child: Text('اختبار التوتر')));
}
