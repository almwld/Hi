import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class GlucoseTrackerScreen extends StatelessWidget {
  const GlucoseTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('تتبع السكر')), body: const Center(child: Text('قراءات الجلوكوز')));
}
