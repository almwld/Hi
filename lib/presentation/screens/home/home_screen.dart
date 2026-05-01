import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/widgets/common_widgets.dart';
import 'package:sehatak/presentation/screens/doctor/doctors_list_screen.dart';
import 'package:sehatak/presentation/screens/more/more_screen.dart';
import 'package:sehatak/presentation/screens/pharmacy/pharmacy_screen.dart';
import 'package:sehatak/presentation/screens/emergencies/emergency_numbers.dart';
import 'package:sehatak/presentation/screens/consultation/consultation_screen.dart';
import 'package:sehatak/presentation/screens/patient/patient_medical_history.dart';
import 'package:sehatak/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:sehatak/presentation/screens/about/about_screen.dart';
import 'package:sehatak/presentation/screens/health_tips/health_tips_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    DoctorsListScreen(),
    PatientAppointments(),
    PatientDashboard(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.person_search_rounded), label: 'الأطباء'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'المواعيد'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_rounded), label: 'الملف الصحي'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [Text('👋'), SizedBox(width: 8), Text('صباح الخير، أحمد')]),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              bool isDark = false;
              if (state is ThemeLoadedState) isDark = state.themeMode == ThemeMode.dark;
              return IconButton(icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode), onPressed: () => context.read<ThemeBloc>().add(SetThemeEvent(!isDark)), tooltip: isDark ? 'الوضع النهاري' : 'الوضع الليلي');
            },
          ),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // شريط البحث
          const CustomSearchBar(hint: 'بحث عن خدمات، أطباء، مقالات...'),
          const SizedBox(height: 16),

          // بطاقة صحتك أولويتنا
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00796B), Color(0xFF004D40)]), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('صحتك، أولويتنا', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('رعاية موثوقة في أي وقت وأي مكان', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
                icon: const Icon(Icons.explore),
                label: const Text('استكشف الآن'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              ),
            ]),
          ),
          const SizedBox(height: 22),

          // ========= خدمات سريعة =========
          Text('خدمات سريعة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _quickService(context, Icons.local_pharmacy, 'الصيدلية', AppColors.success, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyScreen()))),
            _quickService(context, Icons.emergency, 'الطوارئ', AppColors.error, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyNumbers()))),
            _quickService(context, Icons.video_call, 'استشارات', AppColors.info, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsultationScreen()))),
            _quickService(context, Icons.science, 'التحاليل', AppColors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientMedicalHistory()))),
          ]),
          const SizedBox(height: 22),

          // ========= أفضل الأطباء =========
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('أفضل الأطباء', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                // الانتقال لتبويب الأطباء في الـ BottomNavigation
                final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                homeState?.setState(() {});
                // أو ننتقل مباشرة
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorsListScreen()));
              },
              child: const Text('عرض الكل ›'),
            ),
          ]),
          const SizedBox(height: 8),

          // د. علي المولد - الطبيب الأول
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.05), AppColors.primary.withOpacity(0.02)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(children: [
              Container(
                width: 65, height: 65,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text('👨‍⚕️', style: TextStyle(fontSize: 34))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Text('د. علي المولد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 6),
                  Icon(Icons.verified, color: AppColors.info, size: 18),
                ]),
                const Text('استشاري باطنية وأطفال', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                const Text('خبرة 20+ سنة', style: TextStyle(fontSize: 11, color: AppColors.darkGrey)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star, color: AppColors.amber, size: 16),
                  const Text(' 4.9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Text(' (328 تقييم)', style: TextStyle(fontSize: 10, color: AppColors.grey)),
                  const SizedBox(width: 10),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: const Text('متاح اليوم', style: TextStyle(fontSize: 9, color: Colors.green))),
                ]),
              ])),
            ]),
          ),
          const SizedBox(height: 8),

          // أطباء آخرين
          DoctorCard(name: 'د. حسن رضا', specialty: 'طبيب عام', experience: 'خبرة 8+ سنوات', rating: 4.8, reviews: 235, onTap: () {}),
          const SizedBox(height: 6),
          DoctorCard(name: 'د. عائشة ملك', specialty: 'طبيبة جلدية', experience: 'خبرة 6+ سنوات', rating: 4.9, reviews: 189, onTap: () {}),
          const SizedBox(height: 6),
          DoctorCard(name: 'د. عثمان خان', specialty: 'طبيب قلب', experience: 'خبرة 10+ سنوات', rating: 4.7, reviews: 312, onTap: () {}),
          const SizedBox(height: 22),

          // ========= منشورات ونصائح =========
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('نصائح ومقالات', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthTipsScreen())), child: const Text('المزيد ›')),
          ]),
          const SizedBox(height: 8),

          // بطاقة نصيحة مميزة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber.shade100, Colors.orange.shade100]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.3), shape: BoxShape.circle),
                child: const Center(child: Text('💡', style: TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('نصيحة اليوم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.dark)),
                SizedBox(height: 2),
                Text('اشرب 8 أكواب من الماء يومياً للحفاظ على صحة الكلى والجسم', style: TextStyle(fontSize: 12, color: AppColors.darkGrey, height: 1.4)),
              ])),
            ]),
          ),
          const SizedBox(height: 8),

          // منشورات
          _postCard('د. علي المولد', 'استشاري باطنية وأطفال', 'منذ 3 ساعات', '👨‍⚕️', '🫀 ارتفاع ضغط الدم مرض صامت.. أنصح الجميع بقياس الضغط دورياً والمشي 30 دقيقة يومياً للحفاظ على صحة القلب.', 45, 12),
          _postCard('د. عائشة ملك', 'طبيبة جلدية', 'منذ 5 ساعات', '👩‍⚕️', '☀️ مع دخول الصيف.. لا تنسوا استخدام واقي الشمس وتجديده كل ساعتين. بشرة صحية = حماية من التجاعيد والسرطان.', 32, 8),
          const SizedBox(height: 22),

          // ========= السجل الطبي =========
          Text('السجل الطبي', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _historyItem(context, 'ارتفاع ضغط الدم', 'تم التشخيص: 15 مارس 2023', AppColors.error),
          _historyItem(context, 'الربو', 'تم التشخيص: 10 يناير 2021', AppColors.warning),
          _historyItem(context, 'التهاب المعدة', 'تم التشخيص: 5 أغسطس 2019', AppColors.info),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  // ========= ويدجت خدمة سريعة =========
  Widget _quickService(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: color.withOpacity(0.08), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ========= ويدجت منشور =========
  Widget _postCard(String name, String title, String time, String avatar, String content, int likes, int comments) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 20, backgroundColor: AppColors.primary.withOpacity(0.1), child: Text(avatar, style: const TextStyle(fontSize: 20))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text(title, style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
          Text(time, style: const TextStyle(fontSize: 9, color: AppColors.grey)),
        ]),
        const SizedBox(height: 10),
        Text(content, style: const TextStyle(fontSize: 12, height: 1.5, color: AppColors.darkGrey)),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.favorite_border, size: 16, color: AppColors.error), const SizedBox(width: 4), Text('$likes', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
          const SizedBox(width: 16),
          const Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.info), const SizedBox(width: 4), Text('$comments تعليق', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
          const Spacer(),
          const Icon(Icons.share, size: 16, color: AppColors.grey),
        ]),
      ]),
    );
  }

  // ========= ويدجت سجل طبي =========
  Widget _historyItem(BuildContext context, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4))),
      child: Row(children: [
        Container(width: 4, height: 38, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
        const Icon(Icons.chevron_left, color: AppColors.grey),
      ]),
    );
  }
}

// ========= عناصر نائبة =========
// PatientAppointmentsPlaceholder removed
  const PatientAppointmentsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('المواعيد'));
}

// placeholder removed
