import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/widgets/common_widgets.dart';
import 'package:sehatak/presentation/screens/doctor/doctors_list_screen.dart';
import 'package:sehatak/presentation/screens/consultation/consultation_screen.dart';
import 'package:sehatak/presentation/screens/more/more_screen.dart';
import 'package:sehatak/presentation/screens/pharmacy/pharmacy_screen.dart';
import 'package:sehatak/presentation/screens/profile/profile_screen.dart';

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
    PatientAppointmentsPlaceholder(),
    PatientDashboardPlaceholder(),
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
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CustomSearchBar(hint: 'بحث عن خدمات، أطباء، مقالات...'),
          const SizedBox(height: 18),
          // بطاقة ترحيبية
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00796B), Color(0xFF004D40)]), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('صحتك، أولويتنا', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('رعاية موثوقة في أي وقت وأي مكان', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary), child: const Text('استكشف الآن')),
            ]),
          ),
          const SizedBox(height: 22),
          // أفضل الأطباء
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('أفضل الأطباء', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('عرض الكل ›')),
          ]),
          const SizedBox(height: 8),
          DoctorCard(name: 'د. حسن رضا', specialty: 'طبيب عام', experience: 'خبرة 8+ سنوات', rating: 4.8, reviews: 235, onTap: () {}),
          const SizedBox(height: 8),
          DoctorCard(name: 'د. عائشة ملك', specialty: 'طبيبة جلدية', experience: 'خبرة 6+ سنوات', rating: 4.9, reviews: 189, onTap: () {}),
          const SizedBox(height: 8),
          DoctorCard(name: 'د. عثمان خان', specialty: 'طبيب قلب', experience: 'خبرة 10+ سنوات', rating: 4.7, reviews: 312, onTap: () {}),
          const SizedBox(height: 22),
          // خدمات سريعة
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _quickService(context, Icons.local_pharmacy, 'الصيدلية', () {}),
            _quickService(context, Icons.emergency, 'الطوارئ', () {}),
            _quickService(context, Icons.video_call, 'استشارات', () {}),
            _quickService(context, Icons.science, 'التحاليل', () {}),
          ]),
          const SizedBox(height: 22),
          // التاريخ الطبي
          Text('السجل الطبي', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _historyItem(context, 'ارتفاع ضغط الدم', 'تم التشخيص: 15 مارس 2023', AppColors.error),
          _historyItem(context, 'الربو', 'تم التشخيص: 10 يناير 2021', AppColors.warning),
          _historyItem(context, 'التهاب المعدة', 'تم التشخيص: 5 أغسطس 2019', AppColors.info),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _quickService(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primary, size: 26)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _historyItem(BuildContext context, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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

// عناصر نائبة للشاشات اللي في الشريط السفلي
class PatientAppointmentsPlaceholder extends StatelessWidget {
  const PatientAppointmentsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('المواعيد'));
  }
}

class PatientDashboardPlaceholder extends StatelessWidget {
  const PatientDashboardPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('الملف الصحي'));
  }
}
