import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../bloc/appointment_bloc/appointment_bloc.dart';

class PatientAppointments extends StatefulWidget {
  const PatientAppointments({super.key});

  @override
  State<PatientAppointments> createState() => _PatientAppointmentsState();
}

class _PatientAppointmentsState extends State<PatientAppointments> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<AppointmentBloc>().add(const LoadAppointments());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.myAppointments),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppStrings.upcomingAppointments),
            Tab(text: AppStrings.pastAppointments),
            Tab(text: AppStrings.cancelledAppointments),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(context, 'confirmed'),
          _buildAppointmentsList(context, 'completed'),
          _buildAppointmentsList(context, 'cancelled'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context, String status) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AppointmentsLoaded) {
          final filtered = state.appointments.where((a) => a.status == status).toList();
          if (filtered.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final appointment = filtered[index];
              return _buildAppointmentCard(context, appointment);
            },
          );
        }
        return _buildEmptyState(context);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 80, color: AppColors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'لا توجد مواعيد',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, dynamic appointment) {
    Color statusColor;
    switch (appointment.status) {
      case 'confirmed':
        statusColor = AppColors.success;
        break;
      case 'completed':
        statusColor = AppColors.info;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName ?? 'طبيب',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      appointment.doctorSpecialization ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.status == 'confirmed' ? 'مؤكد' : appointment.status == 'completed' ? 'مكتمل' : 'ملغي',
                  style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 24),
              Icon(Icons.access_time, size: 18, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                appointment.appointmentTime,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (appointment.status == 'confirmed') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(AppStrings.cancelAppointment),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_calendar, size: 18),
                    label: Text(AppStrings.reschedule),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
