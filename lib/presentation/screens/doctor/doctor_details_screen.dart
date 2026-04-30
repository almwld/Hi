import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../bloc/doctor_bloc/doctor_bloc.dart';
import 'doctor_booking_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;
  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(LoadDoctorDetails(widget.doctorId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is DoctorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DoctorDetailsLoaded) {
            final doctor = state.doctor;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.white.withOpacity(0.2),
                                  child: const Icon(Icons.person, size: 50, color: AppColors.white),
                                ),
                                if (doctor.isVerified)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.verified, color: AppColors.primary, size: 20),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              doctor.fullName,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              doctor.specialization,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.white.withOpacity(0.9),
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, color: AppColors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${doctor.rating}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${doctor.reviewCount} ${AppStrings.reviews})',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.white.withOpacity(0.8),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                Icons.work_outline,
                                '${doctor.experience}',
                                'سنوات خبرة',
                                AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                Icons.attach_money,
                                '${doctor.consultationPrice}',
                                AppStrings.currencyYER,
                                AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                Icons.people_outline,
                                '${doctor.reviewCount}',
                                'مريض',
                                AppColors.info,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'نبذة عن الطبيب',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          doctor.bio ?? 'استشاري ${doctor.specialization} بخبرة ${doctor.experience} سنة في المجال الطبي',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                        ),
                        const SizedBox(height: 24),
                        if (doctor.clinicAddress != null) ...[
                          Text(
                            'عيادة الطبيب',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(Icons.location_on_outlined, doctor.clinicAddress!),
                        ],
                        if (doctor.clinicPhone != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(Icons.phone_outlined, doctor.clinicPhone!),
                        ],
                        if (doctor.workingHours != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(Icons.access_time, doctor.workingHours!),
                        ],
                        if (doctor.languages != null && doctor.languages!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(Icons.language, doctor.languages!.join(' - ')),
                        ],
                        const SizedBox(height: 24),
                        Text(
                          AppStrings.reviews,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        ...state.reviews.map((review) => _buildReviewCard(context, review)),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('لا توجد بيانات'));
        },
      ),
      bottomNavigationBar: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is DoctorDetailsLoaded) {
            return Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DoctorBookingScreen(doctorId: widget.doctorId)),
                    );
                  },
                  child: Text('${AppStrings.bookNow} - ${state.doctor.consultationPrice} ${AppStrings.currencyYER}'),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(BuildContext context, dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating ? Icons.star : Icons.star_border,
                            color: AppColors.amber,
                            size: 14,
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${review.createdAt.day}/${review.createdAt.month}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }
}
