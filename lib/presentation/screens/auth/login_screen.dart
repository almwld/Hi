import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPhoneController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // الشعار
          const SizedBox(height: 30),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.health_and_safety, color: Colors.white, size: 45),
          ),
          const SizedBox(height: 12),
          const Text('صحتك', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const Text('صحتك، أولويتنا', style: TextStyle(fontSize: 13, color: AppColors.grey)),
          const SizedBox(height: 10),

          // التبويبات
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.darkGrey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(text: 'تسجيل الدخول'),
                Tab(text: 'إنشاء حساب'),
              ],
            ),
          ),

          // المحتوى
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoginTab(),
                _buildRegisterTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // ================ تبويب تسجيل الدخول ================
  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('مرحباً بعودتك!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('سجل دخولك للمتابعة', style: TextStyle(color: AppColors.grey, fontSize: 13)),
        const SizedBox(height: 24),

        // البريد الإلكتروني
        TextField(
          controller: _loginEmailController,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: 'البريد الإلكتروني',
            hintText: 'أدخل بريدك الإلكتروني',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 14),

        // كلمة المرور
        TextField(
          controller: _loginPasswordController,
          obscureText: _obscurePassword,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            hintText: 'أدخل كلمة المرور',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),

        // نسيت كلمة المرور
        Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () {}, child: const Text('نسيت كلمة المرور؟'))),
        const SizedBox(height: 16),

        // زر الدخول
        ElevatedButton(
          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),

        // أو
        const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('أو', style: TextStyle(color: AppColors.grey))), Expanded(child: Divider())]),
        const SizedBox(height: 16),

        // وسائل أخرى
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.error)),
          label: const Text('المتابعة باستخدام Google'),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
          label: const Text('المتابعة باستخدام Facebook'),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 20),

        // ليس لديك حساب
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('ليس لديك حساب؟', style: TextStyle(color: AppColors.darkGrey)),
          TextButton(onPressed: () => _tabController.animateTo(1), child: const Text('إنشاء حساب')),
        ]),
      ]),
    );
  }

  // ================ تبويب إنشاء حساب ================
  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('انضم إلى صحتك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('أنشئ حسابك وابدأ رحلتك الصحية', style: TextStyle(color: AppColors.grey, fontSize: 13)),
        const SizedBox(height: 20),

        // الاسم الكامل
        TextField(
          controller: _registerNameController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: 'الاسم الكامل',
            hintText: 'أدخل اسمك الكامل',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 12),

        // البريد الإلكتروني
        TextField(
          controller: _registerEmailController,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: 'البريد الإلكتروني',
            hintText: 'أدخل بريدك الإلكتروني',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 12),

        // رقم الهاتف
        TextField(
          controller: _registerPhoneController,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: 'رقم الهاتف',
            hintText: 'أدخل رقم هاتفك',
            prefixIcon: const Icon(Icons.phone_android),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 12),

        // كلمة المرور
        TextField(
          controller: _registerPasswordController,
          obscureText: _obscurePassword,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            hintText: 'أنشئ كلمة مرور',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 12),

        // تأكيد كلمة المرور
        TextField(
          controller: _registerConfirmController,
          obscureText: _obscureConfirm,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: 'تأكيد كلمة المرور',
            hintText: 'أعد كتابة كلمة المرور',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 14),

        // الموافقة على الشروط
        Row(children: [
          Checkbox(value: _agreeTerms, activeColor: AppColors.primary, onChanged: (v) => setState(() => _agreeTerms = v!)),
          const Expanded(child: Text('أوافق على الشروط والأحكام وسياسة الخصوصية', style: TextStyle(fontSize: 11, color: AppColors.darkGrey))),
        ]),
        const SizedBox(height: 14),

        // زر التسجيل
        ElevatedButton(
          onPressed: _agreeTerms ? () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false) : null,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('إنشاء حساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 18),

        // أو
        const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('أو', style: TextStyle(color: AppColors.grey))), Expanded(child: Divider())]),
        const SizedBox(height: 14),

        // وسائل أخرى
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.error)),
          label: const Text('المتابعة باستخدام Google'),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
          label: const Text('المتابعة باستخدام Facebook'),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 20),

        // مميزات
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            _featureRow(Icons.lock, 'آمن وخصوصي', 'بياناتك محمية بأعلى المعايير'),
            const SizedBox(height: 8),
            _featureRow(Icons.verified_user, 'أطباء موثوقون', 'تواصل مع أطباء معتمدين'),
            const SizedBox(height: 8),
            _featureRow(Icons.favorite, 'صحة أفضل', 'رحلتك الصحية تبدأ من هنا'),
          ]),
        ),
        const SizedBox(height: 16),

        // لديك حساب
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('لديك حساب بالفعل؟', style: TextStyle(color: AppColors.darkGrey)),
          TextButton(onPressed: () => _tabController.animateTo(0), child: const Text('تسجيل الدخول')),
        ]),
      ]),
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle) {
    return Row(children: [
      Icon(icon, color: AppColors.primary, size: 20),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)), Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.grey))]),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmController.dispose();
    super.dispose();
  }
}
