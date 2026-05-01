import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/screens/doctor/doctor_details_screen.dart';
import 'package:sehatak/presentation/screens/chat/chat_screen.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';
  String _sortBy = 'rating';
  bool _showAvailableOnly = false;

  final List<Map<String, String>> _specialties = [
    {'icon': '🫀', 'name': 'All'},
    {'icon': '👨‍⚕️', 'name': 'General'},
    {'icon': '🫀', 'name': 'Cardiology'},
    {'icon': '🫁', 'name': 'Pulmonology'},
    {'icon': '🧠', 'name': 'Neurology'},
    {'icon': '🦴', 'name': 'Orthopedics'},
    {'icon': '👶', 'name': 'Pediatrics'},
    {'icon': '👩‍🦰', 'name': 'Dermatology'},
    {'icon': '👁️', 'name': 'Ophthalmology'},
    {'icon': '🦷', 'name': 'Dental'},
    {'icon': '🧘', 'name': 'Psychiatry'},
    {'icon': '🤰', 'name': 'Gynecology'},
    {'icon': '🩺', 'name': 'ENT'},
    {'icon': '🩻', 'name': 'Radiology'},
    {'icon': '💊', 'name': 'Pharmacology'},
  ];

  final List<Map<String, dynamic>> _allDoctors = [
    {
      'id': '1', 'name': 'Dr. Ayesha Rahman', 'specialty': 'General', 'subspecialty': 'Internal Medicine',
      'qualification': 'MBBS, FCPS (Internal Medicine)', 'experience': '12+ Years', 'rating': 4.9, 'reviews': 128,
      'fee': '500', 'available': true, 'online': true, 'languages': 'English, Urdu, Bengali',
      'hospital': 'City Medical Center', 'patients': '5,000+', 'image': '👩‍⚕️', 'nextAvailable': 'Today 3:00 PM',
    },
    {
      'id': '2', 'name': 'Dr. Hassan Raza', 'specialty': 'General', 'subspecialty': 'General Physician',
      'qualification': 'MBBS, MD', 'experience': '8+ Years', 'rating': 4.8, 'reviews': 235,
      'fee': '300', 'available': true, 'online': true, 'languages': 'English, Urdu',
      'hospital': 'Health Plus Clinic', 'patients': '3,200+', 'image': '👨‍⚕️', 'nextAvailable': 'Today 4:30 PM',
    },
    {
      'id': '3', 'name': 'Dr. Usman Khan', 'specialty': 'Cardiology', 'subspecialty': 'Interventional Cardiology',
      'qualification': 'MBBS, FCPS (Cardiology), FACC', 'experience': '10+ Years', 'rating': 4.7, 'reviews': 312,
      'fee': '1000', 'available': true, 'online': true, 'languages': 'English, Urdu, Pashto',
      'hospital': 'National Heart Institute', 'patients': '8,000+', 'image': '👨‍⚕️', 'nextAvailable': 'Today 5:00 PM',
    },
    {
      'id': '4', 'name': 'Dr. Sarah Ahmed', 'specialty': 'Cardiology', 'subspecialty': 'Pediatric Cardiology',
      'qualification': 'MBBS, FCPS (Cardiology)', 'experience': '7+ Years', 'rating': 4.8, 'reviews': 156,
      'fee': '1200', 'available': false, 'online': false, 'languages': 'English, Urdu, Arabic',
      'hospital': 'Children Heart Center', 'patients': '2,500+', 'image': '👩‍⚕️', 'nextAvailable': 'Tomorrow 11:00 AM',
    },
    {
      'id': '5', 'name': 'Dr. Imran Sheikh', 'specialty': 'Pulmonology', 'subspecialty': 'Respiratory Medicine',
      'qualification': 'MBBS, FCPS (Pulmonology)', 'experience': '9+ Years', 'rating': 4.6, 'reviews': 189,
      'fee': '900', 'available': true, 'online': true, 'languages': 'English, Urdu, Sindhi',
      'hospital': 'Lung Care Hospital', 'patients': '4,000+', 'image': '👨‍⚕️', 'nextAvailable': 'Today 6:00 PM',
    },
    {
      'id': '6', 'name': 'Dr. Nadia Hussain', 'specialty': 'Neurology', 'subspecialty': 'Stroke Specialist',
      'qualification': 'MBBS, FCPS (Neurology), MRCP', 'experience': '11+ Years', 'rating': 4.9, 'reviews': 201,
      'fee': '1500', 'available': true, 'online': false, 'languages': 'English, Urdu',
      'hospital': 'Neuro Care Institute', 'patients': '6,000+', 'image': '👩‍⚕️', 'nextAvailable': 'Today 2:00 PM',
    },
    {
      'id': '7', 'name': 'Dr. Kamran Ahmed', 'specialty': 'Orthopedics', 'subspecialty': 'Joint Replacement',
      'qualification': 'MBBS, MS (Orthopedics), FRCS', 'experience': '15+ Years', 'rating': 4.6, 'reviews': 98,
      'fee': '1200', 'available': false, 'online': false, 'languages': 'English, Urdu',
      'hospital': 'Bone & Joint Hospital', 'patients': '10,000+', 'image': '👨‍⚕️', 'nextAvailable': 'Day after tomorrow',
    },
    {
      'id': '8', 'name': 'Dr. Fatima Siddiqui', 'specialty': 'Pediatrics', 'subspecialty': 'Neonatology',
      'qualification': 'MBBS, FCPS (Pediatrics)', 'experience': '7+ Years', 'rating': 4.9, 'reviews': 167,
      'fee': '600', 'available': true, 'online': true, 'languages': 'English, Urdu, Sindhi',
      'hospital': 'Children Hospital', 'patients': '7,000+', 'image': '👩‍⚕️', 'nextAvailable': 'Today 2:30 PM',
    },
    {
      'id': '9', 'name': 'Dr. Ayesha Malik', 'specialty': 'Dermatology', 'subspecialty': 'Cosmetic Dermatology',
      'qualification': 'MBBS, DDerm, MSc', 'experience': '6+ Years', 'rating': 4.9, 'reviews': 189,
      'fee': '800', 'available': false, 'online': false, 'languages': 'English, Urdu, Punjabi',
      'hospital': 'Skin Aesthetics Clinic', 'patients': '4,500+', 'image': '👩‍⚕️', 'nextAvailable': 'Tomorrow 10:00 AM',
    },
    {
      'id': '10', 'name': 'Dr. Omar Farooq', 'specialty': 'Ophthalmology', 'subspecialty': 'Retina Specialist',
      'qualification': 'MBBS, FCPS (Ophthalmology)', 'experience': '13+ Years', 'rating': 4.7, 'reviews': 145,
      'fee': '1000', 'available': true, 'online': true, 'languages': 'English, Urdu',
      'hospital': 'Eye Care Center', 'patients': '9,000+', 'image': '👨‍⚕️', 'nextAvailable': 'Today 7:00 PM',
    },
    {
      'id': '11', 'name': 'Dr. Zara Tariq', 'specialty': 'Dental', 'subspecialty': 'Orthodontics',
      'qualification': 'BDS, MDS (Orthodontics)', 'experience': '5+ Years', 'rating': 4.5, 'reviews': 112,
      'fee': '700', 'available': true, 'online': false, 'languages': 'English, Urdu',
      'hospital': 'Smile Dental Clinic', 'patients': '2,000+', 'image': '👩‍⚕️', 'nextAvailable': 'Today 3:30 PM',
    },
    {
      'id': '12', 'name': 'Dr. Bilal Mahmood', 'specialty': 'Psychiatry', 'subspecialty': 'Adult Psychiatry',
      'qualification': 'MBBS, FCPS (Psychiatry)', 'experience': '8+ Years', 'rating': 4.8, 'reviews': 134,
      'fee': '1000', 'available': true, 'online': true, 'languages': 'English, Urdu, Punjabi',
      'hospital': 'Mind Wellness Center', 'patients': '3,500+', 'image': '👨‍⚕️', 'nextAvailable': 'Today 5:30 PM',
    },
    {
      'id': '13', 'name': 'Dr. Sana Tariq', 'specialty': 'Gynecology', 'subspecialty': 'Obstetrics',
      'qualification': 'MBBS, FCPS (Gynecology)', 'experience': '10+ Years', 'rating': 4.9, 'reviews': 278,
      'fee': '800', 'available': true, 'online': false, 'languages': 'English, Urdu, Pashto',
      'hospital': 'Women Health Center', 'patients': '12,000+', 'image': '👩‍⚕️', 'nextAvailable': 'Today 1:00 PM',
    },
    {
      'id': '14', 'name': 'Dr. Rashid Ali', 'specialty': 'ENT', 'subspecialty': 'Head & Neck Surgery',
      'qualification': 'MBBS, FCPS (ENT)', 'experience': '14+ Years', 'rating': 4.6, 'reviews': 167,
      'fee': '900', 'available': false, 'online': false, 'languages': 'English, Urdu, Arabic',
      'hospital': 'ENT Specialized Hospital', 'patients': '11,000+', 'image': '👨‍⚕️', 'nextAvailable': 'Tomorrow 9:00 AM',
    },
    {
      'id': '15', 'name': 'Dr. Hira Sheikh', 'specialty': 'Radiology', 'subspecialty': 'Diagnostic Radiology',
      'qualification': 'MBBS, FCPS (Radiology)', 'experience': '9+ Years', 'rating': 4.7, 'reviews': 89,
      'fee': '600', 'available': true, 'online': true, 'languages': 'English, Urdu',
      'hospital': 'Advanced Imaging Center', 'patients': '15,000+', 'image': '👩‍⚕️', 'nextAvailable': 'Today 4:00 PM',
    },
    {
      'id': '16', 'name': 'Dr. Faisal Qureshi', 'specialty': 'Pharmacology', 'subspecialty': 'Clinical Pharmacology',
      'qualification': 'PharmD, PhD (Pharmacology)', 'experience': '11+ Years', 'rating': 4.5, 'reviews': 76,
      'fee': '500', 'available': true, 'online': true, 'languages': 'English, Urdu',
      'hospital': 'Drug Information Center', 'patients': '1,500+', 'image': '👨‍⚕️', 'nextAvailable': 'Today 3:00 PM',
    },
  ];

  List<Map<String, dynamic>> get _filteredDoctors {
    var doctors = _allDoctors;
    if (_selectedSpecialty != 'All') {
      doctors = doctors.where((d) => d['specialty'] == _selectedSpecialty).toList();
    }
    if (_showAvailableOnly) {
      doctors = doctors.where((d) => d['available'] == true).toList();
    }
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      doctors = doctors.where((d) => d['name'].toString().toLowerCase().contains(query) || d['subspecialty'].toString().toLowerCase().contains(query) || d['hospital'].toString().toLowerCase().contains(query)).toList();
    }
    if (_sortBy == 'rating') {
      doctors.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    } else if (_sortBy == 'fee_low') {
      doctors.sort((a, b) => int.parse(a['fee']).compareTo(int.parse(b['fee'])));
    } else if (_sortBy == 'fee_high') {
      doctors.sort((a, b) => int.parse(b['fee']).compareTo(int.parse(a['fee'])));
    } else if (_sortBy == 'experience') {
      doctors.sort((a, b) => (b['experience'] as String).compareTo(a['experience'] as String));
    }
    return doctors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Doctors', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortOptions),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () => setState(() => _showAvailableOnly = !_showAvailableOnly), color: _showAvailableOnly ? AppColors.primary : null),
        ],
      ),
      body: Column(children: [
        // شريط البحث
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by name, specialty, hospital...',
              prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); setState(() {}); }) : null,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
            ),
          ),
        ),
        // التخصصات أفقية
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: _specialties.length,
            separatorBuilder: (_, __) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final s = _specialties[index];
              final selected = _selectedSpecialty == s['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedSpecialty = s['name']!),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.primary.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Text(s['icon']!, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(height: 4),
                  Text(s['name']!, style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? AppColors.primary : AppColors.darkGrey)),
                ]),
              );
            },
          ),
        ),
        const Divider(height: 1),
        // نتائج
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${_filteredDoctors.length} doctors found', style: const TextStyle(fontSize: 12, color: AppColors.grey)),
            if (_showAvailableOnly)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check, size: 12, color: Colors.green), SizedBox(width: 2), Text('Available Only', style: TextStyle(fontSize: 10, color: Colors.green))]),
              ),
          ]),
        ),
        Expanded(
          child: _filteredDoctors.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search_off, size: 60, color: AppColors.grey), SizedBox(height: 12), Text('No doctors found', style: TextStyle(color: AppColors.grey, fontSize: 16))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _filteredDoctors.length,
                  itemBuilder: (context, index) => _buildDoctorCard(_filteredDoctors[index]),
                ),
        ),
      ]),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // صورة الطبيب
          Stack(children: [
            Container(
              width: 65, height: 65,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text(doc['image'], style: const TextStyle(fontSize: 32))),
            ),
            if (doc['online'] == true)
              Positioned(bottom: 2, right: 2, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.check, size: 8, color: Colors.white))),
          ]),
          const SizedBox(width: 14),
          // معلومات الطبيب
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(doc['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              if (doc['available'] == true)
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Text('Available', style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 3),
            Text(doc['qualification'], style: const TextStyle(fontSize: 11, color: AppColors.darkGrey)),
            const SizedBox(height: 3),
            Text(doc['subspecialty'], style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            // تقييم وخبرة
            Row(children: [
              const Icon(Icons.star, color: AppColors.amber, size: 16),
              Text(' ${doc['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(' (${doc['reviews']})', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
              const SizedBox(width: 12),
              const Icon(Icons.work_outline, size: 14, color: AppColors.grey),
              Text(' ${doc['experience']}', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
              const SizedBox(width: 12),
              const Icon(Icons.people, size: 14, color: AppColors.grey),
              Text(' ${doc['patients']}', style: const TextStyle(fontSize: 11, color: AppColors.grey)),
            ]),
          ])),
          // السعر
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Rs. ${doc['fee']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18)),
            const Text('Consultation', style: TextStyle(fontSize: 9, color: AppColors.grey)),
          ]),
        ]),
        const SizedBox(height: 10),
        // معلومات إضافية
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const Icon(Icons.local_hospital, size: 14, color: AppColors.darkGrey),
            const SizedBox(width: 4),
            Expanded(child: Text(doc['hospital'], style: const TextStyle(fontSize: 11, color: AppColors.darkGrey))),
            const Icon(Icons.language, size: 14, color: AppColors.darkGrey),
            const SizedBox(width: 4),
            Text(doc['languages'], style: const TextStyle(fontSize: 10, color: AppColors.darkGrey)),
          ]),
        ),
        const SizedBox(height: 10),
        Row(children: [
          // الموعد التالي
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: doc['online'] == true ? Colors.green.withOpacity(0.06) : Colors.orange.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(doc['online'] == true ? Icons.videocam : Icons.schedule, size: 14, color: doc['online'] == true ? Colors.green : Colors.orange),
                const SizedBox(width: 4),
                Text(doc['nextAvailable'], style: TextStyle(fontSize: 11, color: doc['online'] == true ? Colors.green : Colors.orange, fontWeight: FontWeight.w500)),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctorId: doc['id']))),
            icon: const Icon(Icons.person, size: 16),
            label: const Text('Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
            icon: const Icon(Icons.message, size: 16),
            label: const Text('Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ]),
      ]),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _sortOption('Rating - Highest', 'rating', Icons.star),
          _sortOption('Fee - Low to High', 'fee_low', Icons.arrow_upward),
          _sortOption('Fee - High to Low', 'fee_high', Icons.arrow_downward),
          _sortOption('Experience', 'experience', Icons.work),
        ]),
      ),
    );
  }

  Widget _sortOption(String title, String value, IconData icon) {
    final selected = _sortBy == value;
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : AppColors.grey),
      title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? AppColors.primary : null)),
      trailing: selected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        setState(() => _sortBy = value);
        Navigator.pop(context);
      },
    );
  }
}
