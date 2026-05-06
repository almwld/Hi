import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../terms/terms_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _agreeTerms = false;
  bool _loading = false;

  void _register() {
    if (_nameCtrl.text.isNotEmpty && _phoneCtrl.text.isNotEmpty && _agreeTerms) {
      context.read<AuthBloc>().add(SendOTP(_phoneCtrl.text.trim()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال رمز التحقق'), backgroundColor: AppColors.success),
      );
    }
  }

  void _openTerms() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 20),
          const Icon(Icons.person_add, size: 70, color: AppColors.primary),
          const SizedBox(height: 16),
          const Text('انضم إلى منصة صحتك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const Text('أنشئ حسابك الصحي', style: TextStyle(color: AppColors.grey, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 30),
          TextField(controller: _nameCtrl, textAlign: TextAlign.right, decoration: InputDecoration(labelText: 'الاسم الكامل', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow.withOpacity(0.5))),
          const SizedBox(height: 14),
          TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, textDirection: TextDirection.ltr, decoration: InputDecoration(labelText: 'رقم الهاتف', hintText: '777123456', prefixIcon: const Icon(Icons.phone_android), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow.withOpacity(0.5))),
          const SizedBox(height: 14),
          TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, textDirection: TextDirection.ltr, decoration: InputDecoration(labelText: 'البريد الإلكتروني (اختياري)', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow.withOpacity(0.5))),
          const SizedBox(height: 16),
          Row(children: [
            Checkbox(value: _agreeTerms, activeColor: AppColors.primary, onChanged: (v) => setState(() => _agreeTerms = v!)),
            Expanded(
              child: GestureDetector(
                onTap: _openTerms,
                child: const Text.rich(
                  TextSpan(
                    text: 'أوافق على ',
                    style: TextStyle(fontSize: 11),
                    children: [
                      TextSpan(
                        text: 'الشروط والأحكام',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          SizedBox(height: 52, child: ElevatedButton(onPressed: (_agreeTerms && !_loading) ? _register : null, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('إنشاء حساب', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))),
        ]),
      ),
    );
  }

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); _emailCtrl.dispose(); super.dispose(); }
}
