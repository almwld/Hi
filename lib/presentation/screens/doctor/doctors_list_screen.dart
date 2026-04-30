import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/doctor_models/doctor_model.dart';
import '../../bloc/doctor_bloc/doctor_bloc.dart';
import 'doctor_details_screen.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(const LoadDoctors());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.doctors),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<DoctorBloc>().add(SearchDoctors(value));
              },
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          context.read<DoctorBloc>().add(const LoadDoctors());
                        },
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              children: [
                _buildFilterChip('all', 'الكل'),
                _buildFilterChip('cardiology', 'القلب'),
                _buildFilterChip('pediatrics', 'الأطفال'),
                _buildFilterChip('surgery', 'الجراحة'),
                _buildFilterChip('dermatology', 'الجلدية'),
                _buildFilterChip('gynecology', 'النساء'),
                _buildFilterChip('neurology', 'الأعصاب'),
                _buildFilterChip('orthopedics', 'العظام'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DoctorsLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    itemCount: state.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = state.doctors[index];
                      return _buildDoctorCard(context, doctor);
                    },
                  );
                } else if (state is DoctorError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('لا توجد بيانات'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
          context.read<DoctorBloc>().add(LoadDoctors(specialization: value == 'all' ? null : value));
        },
        selectedColor: AppColors.primary.withOpacity(0.1),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.darkGrey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctorId: doctor.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 32, color: AppColors.primary),
                ),
                if (doctor.isVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, color: AppColors.primary, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialization,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.rating}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${doctor.reviewCount})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.work_outline, size: 16, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.experience} ${AppStrings.experience}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${doctor.consultationPrice} ${AppStrings.currencyYER}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: doctor.isAvailable ? AppColors.success.withOpacity(0.1) : AppColors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          doctor.isAvailable ? AppStrings.availableNow : AppStrings.notAvailable,
                          style: TextStyle(
                            fontSize: 12,
                            color: doctor.isAvailable ? AppColors.success : AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
