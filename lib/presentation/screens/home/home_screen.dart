import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/doctor_models/doctor_model.dart';
import '../../bloc/doctor_bloc/doctor_bloc.dart';
import '../doctor/doctor_details_screen.dart';
import '../doctor/doctors_list_screen.dart';
import '../shared/notifications_screen.dart';
import '../shared/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.goodMorning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                ),
                Text(
                  'أحمد محمد',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('2', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 20),
            _buildConsultationCard(context),
            const SizedBox(height: 24),
            _buildQuickServices(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, AppStrings.healthTips, () {}),
            const SizedBox(height: 12),
            _buildHealthTips(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, AppStrings.doctorsSpecialists, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorsListScreen()));
            }),
            const SizedBox(height: 12),
            _buildDoctorsList(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.grey),
            const SizedBox(width: 12),
            Text(
              AppStrings.searchHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.medicalConsultation,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تحدث مع طبيب مختص\nبكل سهولة',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorsListScreen()));
                  },
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(AppStrings.startConsultation),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.medical_services, size: 40, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickServices(BuildContext context) {
    final services = [
      {'icon': Icons.medication, 'title': AppStrings.medicines, 'subtitle': AppStrings.orderMedicines, 'color': AppColors.teal},
      {'icon': Icons.calendar_today, 'title': AppStrings.appointmentsHome, 'subtitle': AppStrings.bookAppointment, 'color': AppColors.purple},
      {'icon': Icons.science, 'title': AppStrings.labTests, 'subtitle': AppStrings.getLabTests, 'color': AppColors.orange},
      {'icon': Icons.folder_open, 'title': AppStrings.healthFile, 'subtitle': 'جميع بياناتك', 'color': AppColors.indigo},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (service['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(service['icon'] as IconData, color: service['color'] as Color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                service['title'] as String,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                service['subtitle'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        TextButton(
          onPressed: onSeeAll,
          child: Text(AppStrings.viewAll, style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildHealthTips(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.health_and_safety, color: AppColors.primary, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '5 نصائح ذهبية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'للحفاظ على صحتك\nفي نمط الحياة السريع',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget _buildDoctorsList(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          final doctors = [
            DoctorModel(id: '1', userId: 'u1', fullName: 'د. أحمد علي', specialization: 'طب القلب', rating: 4.8, reviewCount: 120, consultationPrice: 5000, isAvailable: true, isVerified: true),
            DoctorModel(id: '2', userId: 'u2', fullName: 'د. سارة محمد', specialization: 'طب الأطفال', rating: 4.9, reviewCount: 200, consultationPrice: 4500, isAvailable: true, isVerified: true),
            DoctorModel(id: '3', userId: 'u3', fullName: 'د. خالد عبدالله', specialization: 'الجراحة العامة', rating: 4.7, reviewCount: 85, consultationPrice: 6000, isAvailable: false, isVerified: true),
            DoctorModel(id: '4', userId: 'u4', fullName: 'د. فاطمة أحمد', specialization: 'أمراض النساء', rating: 4.9, reviewCount: 150, consultationPrice: 5500, isAvailable: true, isVerified: true),
            DoctorModel(id: '5', userId: 'u5', fullName: 'د. محمد صالح', specialization: 'الجلدية', rating: 4.6, reviewCount: 90, consultationPrice: 4000, isAvailable: true, isVerified: true),
          ];
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctorId: doctor.id)));
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.person, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      if (doctor.isVerified)
                        const Icon(Icons.verified, color: AppColors.primary, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor.fullName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialization,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.rating}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: doctor.isAvailable ? AppColors.success.withOpacity(0.1) : AppColors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          doctor.isAvailable ? 'متاح' : 'مغلق',
                          style: TextStyle(
                            fontSize: 10,
                            color: doctor.isAvailable ? AppColors.success : AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
