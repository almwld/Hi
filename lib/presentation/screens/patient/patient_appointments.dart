import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class PatientAppointments extends StatefulWidget {
  const PatientAppointments({super.key});
  @override
  State<PatientAppointments> createState() => _PatientAppointmentsState();
}

class _PatientAppointmentsState extends State<PatientAppointments> {
  String _selectedTab = 'Upcoming';

  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'doctor': 'Dr. Ayesha Rahman',
      'specialty': 'Internal Medicine',
      'date': '15 May 2026',
      'time': '10:30 AM',
      'type': 'Video Call',
      'status': 'Confirmed',
      'image': '👩‍⚕️',
      'location': 'Online',
    },
    {
      'doctor': 'Dr. Hassan Raza',
      'specialty': 'General Physician',
      'date': '18 May 2026',
      'time': '2:00 PM',
      'type': 'In-Person',
      'status': 'Pending',
      'image': '👨‍⚕️',
      'location': 'City Hospital, Room 204',
    },
    {
      'doctor': 'Dr. Fatima Siddiqui',
      'specialty': 'Pediatrician',
      'date': '22 May 2026',
      'time': '9:00 AM',
      'type': 'Video Call',
      'status': 'Confirmed',
      'image': '👩‍⚕️',
      'location': 'Online',
    },
  ];

  final List<Map<String, dynamic>> _pastAppointments = [
    {
      'doctor': 'Dr. Usman Khan',
      'specialty': 'Cardiologist',
      'date': '28 Apr 2026',
      'time': '11:00 AM',
      'type': 'In-Person',
      'diagnosis': 'Mild Hypertension',
      'prescription': true,
      'image': '👨‍⚕️',
    },
    {
      'doctor': 'Dr. Ayesha Malik',
      'specialty': 'Dermatologist',
      'date': '15 Apr 2026',
      'time': '3:30 PM',
      'type': 'Video Call',
      'diagnosis': 'Eczema',
      'prescription': true,
      'image': '👩‍⚕️',
    },
    {
      'doctor': 'Dr. Kamran Ahmed',
      'specialty': 'Orthopedic Surgeon',
      'date': '02 Apr 2026',
      'time': '5:00 PM',
      'type': 'In-Person',
      'diagnosis': 'Back Pain',
      'prescription': false,
      'image': '👨‍⚕️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments', style: TextStyle(fontWeight: FontWeight.bold)), actions: [IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {})]),
      body: Column(children: [
        // تبويبات
        Container(
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            _tabButton('Upcoming', _selectedTab == 'Upcoming'),
            _tabButton('Past', _selectedTab == 'Past'),
          ]),
        ),
        // المحتوى
        Expanded(
          child: _selectedTab == 'Upcoming'
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: _upcomingAppointments.length,
                  itemBuilder: (context, index) => _buildUpcomingCard(_upcomingAppointments[index]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: _pastAppointments.length,
                  itemBuilder: (context, index) => _buildPastCard(_pastAppointments[index]),
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Book New'),
      ),
    );
  }

  Widget _tabButton(String title, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(title, textAlign: TextAlign.center, style: TextStyle(color: selected ? Colors.white : AppColors.darkGrey, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(Map<String, dynamic> apt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(children: [
        Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(apt['image'], style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(apt['doctor'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(apt['specialty'], style: const TextStyle(color: AppColors.primary, fontSize: 12)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: apt['status'] == 'Confirmed' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(apt['status'], style: TextStyle(color: apt['status'] == 'Confirmed' ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold))),
        ]),
        const Divider(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _aptInfo(Icons.calendar_today, apt['date']),
          _aptInfo(Icons.access_time, apt['time']),
          _aptInfo(Icons.videocam, apt['type']),
        ]),
        const SizedBox(height: 8),
        Row(children: [const Icon(Icons.location_on, size: 14, color: AppColors.grey), const SizedBox(width: 4), Text(apt['location'], style: const TextStyle(fontSize: 11, color: AppColors.grey))]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)), child: const Text('Cancel'))),
          const SizedBox(width: 8),
          Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary), child: const Text('Join Call'))),
        ]),
      ]),
    );
  }

  Widget _buildPastCard(Map<String, dynamic> apt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(apt['image'], style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(apt['doctor'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(apt['specialty'], style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
          const SizedBox(height: 4),
          Text('${apt['date']} • ${apt['time']}', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
          if (apt['diagnosis'] != null) Text('Diagnosis: ${apt['diagnosis']}', style: const TextStyle(fontSize: 11, color: AppColors.info)),
        ])),
        if (apt['prescription'] == true) const Icon(Icons.receipt, color: AppColors.primary),
      ]),
    );
  }

  Widget _aptInfo(IconData icon, String text) {
    return Row(children: [Icon(icon, size: 14, color: AppColors.primary), const SizedBox(width: 4), Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))]);
  }
}
