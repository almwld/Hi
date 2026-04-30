import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/widgets/common_widgets.dart';
import 'package:sehatak/presentation/screens/doctor/doctors_list_screen.dart';
import 'package:sehatak/presentation/screens/chat/chat_screen.dart';
import 'package:sehatak/presentation/screens/pharmacy/pharmacy_screen.dart';
import 'package:sehatak/presentation/screens/profile/profile_screen.dart';
import 'package:sehatak/presentation/screens/patient/patient_dashboard.dart';
import 'package:sehatak/presentation/screens/more/more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const ChatScreen(),
    const MoreScreen(),
    const PharmacyScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'More'),
            BottomNavigationBarItem(icon: Icon(Icons.local_pharmacy_rounded), label: 'Pharmacy'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Row(children: [Text('👋'), SizedBox(width: 8), Text('Good Morning, Ahmed')]), actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CustomSearchBar(hint: 'Search services, doctors, articles...'),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00796B), Color(0xFF004D40)]), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Your Health, Our Priority', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Trusted care anytime, anywhere.', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary), child: const Text('Explore Now')),
            ]),
          ),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Top Doctors', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), TextButton(onPressed: () {}, child: const Text('View All >'))]),
          const SizedBox(height: 8),
          DoctorCard(name: 'Dr. Hassan Raza', specialty: 'General Physician', experience: '8+ Years Experience', rating: 4.8, reviews: 235, onTap: () {}),
          const SizedBox(height: 8),
          DoctorCard(name: 'Dr. Ayesha Malik', specialty: 'Dermatologist', experience: '6+ Years Experience', rating: 4.9, reviews: 189, onTap: () {}),
          const SizedBox(height: 8),
          DoctorCard(name: 'Dr. Usman Khan', specialty: 'Cardiologist', experience: '10+ Years Experience', rating: 4.7, reviews: 312, onTap: () {}),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _quickService(context, Icons.local_pharmacy, 'Pharmacy', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyScreen()))),
            _quickService(context, Icons.emergency, 'Emergency', () {}),
            _quickService(context, Icons.video_call, 'Consultations', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
          ]),
          const SizedBox(height: 24),
          Text('Medical History', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _historyItem(context, 'Hypertension', 'Diagnosed on 15 Mar 2023', AppColors.error),
          _historyItem(context, 'Asthma', 'Diagnosed on 10 Jan 2021', AppColors.warning),
          _historyItem(context, 'Gastritis', 'Diagnosed on 05 Aug 2019', AppColors.info),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _quickService(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primary, size: 28)),
        const SizedBox(height: 8),
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
        Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.grey))])),
        const Icon(Icons.chevron_left, color: AppColors.grey),
      ]),
    );
  }
}
