import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
class HealthCommunityScreen extends StatelessWidget {
  const HealthCommunityScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('مجتمع صحتك')), body: const Center(child: Text('منتدى النقاشات الصحية')));
}
