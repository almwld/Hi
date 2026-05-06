import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // ========== هاتف + OTP ==========
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _otpSent = false;
  String? _devOtp;
  
  // ========== إيميل + باسورد ==========
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // ========== إرسال OTP ==========
  void _sendOTP() {
    if (_phoneCtrl.text.trim().length >= 9) {
      context.read<AuthBloc>().add(SendOTP(_phoneCtrl.text.trim()));
    }
  }

  // ========== تحقق OTP ==========
  void _verifyOTP() {
    if (_otpCtrl.text.trim().length == 6) {
      context.read<AuthBloc>().add(LoginWithOTP(
        phone: _phoneCtrl.text.trim(),
        otp: _otpCtrl.text.trim(),
      ));
    }
  }

  // ========== دخول بالإيميل ==========
  void _loginWithEmail() {
    // مؤقتاً - حتى نفعل API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('قيد التطوير - استخدم رقم الهاتف'), backgroundColor: AppColors.info),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OTPSent) {
          setState(() {
            _otpSent = true;
            _devOtp = state.devOtp;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إرسال رمز التحقق${state.devOtp != null ? ": ${state.devOtp}" : ""}'),
              duration: const Duration(seconds: 10),
              backgroundColor: AppColors.success,
            ),
          );
        }
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Logo
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15)],
                  ),
                  child: const Icon(Icons.health_and_safety, color: Colors.white, size: 45),
                ),
                const SizedBox(height: 12),
                const Text('منصة صحتك', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const Text('الرعاية الصحية في اليمن', style: TextStyle(fontSize: 13, color: AppColors.grey)),
                const SizedBox(height: 20),
                
                // تبويبات
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.darkGrey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    padding: const EdgeInsets.all(4),
                    tabs: const [
                      Tab(text: 'رقم الهاتف'),
                      Tab(text: 'البريد الإلكتروني'),
                    ],
                  ),
                ),
                
                // المحتوى
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPhoneTab(isDark),
                      _buildEmailTab(isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ========== تبويب الهاتف ==========
  Widget _buildPhoneTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 10),
        const Text('تسجيل الدخول برقم الهاتف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('أدخل رقم هاتفك للتحقق', style: TextStyle(color: AppColors.grey, fontSize: 13)),
        const SizedBox(height: 24),
        
        // حقل الهاتف
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: 'رقم الهاتف',
            hintText: '777123456',
            prefixIcon: const Icon(Icons.phone_android, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 16),
        
        // حقل OTP (يظهر بعد الإرسال)
        if (_otpSent) ...[
          TextField(
            controller: _otpCtrl,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: 'رمز التحقق',
              hintText: '6 أرقام',
              prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow.withOpacity(0.5),
            ),
          ),
          // عرض الرمز للتطوير
          if (_devOtp != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  const Text('رمز التحقق: ', style: TextStyle(fontSize: 14)),
                  Text(_devOtp!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.success)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _sendOTP(),
            child: const Text('إعادة إرسال الرمز'),
          ),
        ],
        
        const SizedBox(height: 20),
        
        // زر
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : (_otpSent ? _verifyOTP : _sendOTP),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(_otpSent ? 'تأكيد الرمز' : 'إرسال رمز التحقق',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }

  // ========== تبويب الإيميل ==========
  Widget _buildEmailTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 10),
        const Text('تسجيل الدخول بالإيميل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('أدخل بريدك وكلمة المرور', style: TextStyle(color: AppColors.grey, fontSize: 13)),
        const SizedBox(height: 24),
        
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: 'البريد الإلكتروني',
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 14),
        
        TextField(
          controller: _passCtrl,
          obscureText: _obscurePass,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePass = !_obscurePass),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDark ? const Color(0xFF1A2540) : AppColors.surfaceContainerLow.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(onPressed: () {}, child: const Text('نسيت كلمة المرور؟')),
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _loginWithEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
}
