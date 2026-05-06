import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/screens/chat/chat_screen.dart';
import 'package:sehatak/presentation/screens/call/call_screen.dart';
import 'package:sehatak/presentation/screens/doctor/doctor_booking_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String? doctorId;
  const DoctorDetailsScreen({super.key, this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _isFavorite = false;
  bool _isFollowing = false;
  double _userRating = 0;
  final TextEditingController _reviewCtrl = TextEditingController();

  Map<String, dynamic> get _doctor {
    switch (widget.doctorId) {
      case '1': return {'name': 'د. علي المولد', 'specialty': 'استشاري باطنية وأطفال', 'qualification': 'بكالوريوس طب، زمالة الباطنية، البورد العربي', 'experience': '20+ سنة', 'rating': 4.9, 'reviews': 328, 'patients': '15,000+', 'fee': '500', 'available': true, 'online': true, 'languages': 'عربي، إنجليزي', 'hospital': 'مستشفى الثورة العام', 'about': 'استشاري باطنية وأطفال مع خبرة واسعة في تشخيص وعلاج الأمراض الباطنية للأطفال والكبار. حاصل على البورد العربي في الطب الباطني.', 'education': ['بكالوريوس طب وجراحة - جامعة صنعاء', 'زمالة الطب الباطني - المجلس العربي', 'دبلوم طب الأطفال - جامعة القاهرة'], 'services': ['استشارة باطنية', 'استشارة أطفال', 'فحص شامل', 'متابعة أمراض مزمنة'], 'availability': ['السبت - الأربعاء: 9 ص - 5 م', 'الخميس: 9 ص - 1 م', 'الجمعة: إجازة']};
      case '2': return {'name': 'د. حسن رضا', 'specialty': 'طبيب عام', 'qualification': 'بكالوريوس طب، ماجستير طب أسرة', 'experience': '8+ سنة', 'rating': 4.8, 'reviews': 235, 'patients': '8,000+', 'fee': '300', 'available': true, 'online': true, 'languages': 'عربي، إنجليزي', 'hospital': 'عيادة الصحة بلس', 'about': 'طبيب عام متخصص في طب الأسرة. أقدم رعاية صحية شاملة لجميع أفراد الأسرة.', 'education': ['بكالوريوس طب - جامعة تعز', 'ماجستير طب أسرة - جامعة صنعاء'], 'services': ['استشارة عامة', 'فحص دوري', 'تطعيمات', 'متابعة ضغط وسكر'], 'availability': ['الأحد - الخميس: 8 ص - 4 م', 'السبت: 9 ص - 2 م']};
      case '9': return {'name': 'د. عائشة ملك', 'specialty': 'طبيبة جلدية', 'qualification': 'بكالوريوس طب، دبلوم جلدية، ماجستير', 'experience': '6+ سنة', 'rating': 4.9, 'reviews': 189, 'patients': '4,500+', 'fee': '800', 'available': false, 'online': false, 'languages': 'عربي، إنجليزي', 'hospital': 'عيادة تجميل البشرة', 'about': 'طبيبة جلدية متخصصة في الأمراض الجلدية والتجميل.', 'education': ['بكالوريوس طب - جامعة صنعاء', 'دبلوم جلدية - المجلس العربي'], 'services': ['استشارة جلدية', 'علاج حب شباب', 'تقشير', 'بوتكس'], 'availability': ['السبت - الخميس: 10 ص - 6 م']};
      default: return {'name': 'د. أحمد محمد', 'specialty': 'طبيب عام', 'qualification': 'بكالوريوس طب وجراحة', 'experience': '5+ سنة', 'rating': 4.5, 'reviews': 89, 'patients': '2,000+', 'fee': '200', 'available': true, 'online': true, 'languages': 'عربي', 'hospital': 'مستشفى عام', 'about': 'طبيب عام مهتم بصحة المجتمع.', 'education': ['بكالوريوس طب - جامعة عدن'], 'services': ['استشارة عامة', 'كشف دوري'], 'availability': ['الأحد - الخميس: 8 ص - 2 م']};
    }
  }

  // تقييمات وهمية
  final List<Map<String, dynamic>> _reviews = const [
    {'user': 'محمد عبدالله', 'rating': 5.0, 'date': 'منذ 3 أيام', 'comment': 'دكتور ممتاز، تشخيص دقيق وعلاج فعال. أنصح به بشدة.'},
    {'user': 'فاطمة علي', 'rating': 4.5, 'date': 'منذ أسبوع', 'comment': 'طبيب محترم ومتفهم. شرح الحالة بالتفصيل.'},
    {'user': 'عمر حسن', 'rating': 5.0, 'date': 'منذ أسبوعين', 'comment': 'ما شاء الله، خبرة كبيرة وتشخيص سليم. جزاه الله خير.'},
    {'user': 'سارة أحمد', 'rating': 4.0, 'date': 'منذ شهر', 'comment': 'جيد جداً، لكن وقت الانتظار طويل.'},
  ];

  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }

  @override
  Widget build(BuildContext context) {
    final doc = _doctor;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 250, pinned: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary, AppColors.primaryDark]),), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 40),
              CircleAvatar(radius: 52, backgroundColor: Colors.white24, child: CircleAvatar(radius: 48, backgroundColor: AppColors.primary.withOpacity(0.2), child: Text(doc['name'][0] + doc['name'][doc['name'].length - 2], style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)))),
              const SizedBox(height: 12),
              Text(doc['name'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(doc['specialty'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _starRow(doc['rating']),
                const SizedBox(width: 6),
                Text('(${doc['reviews']} تقييم)', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
            ])),
          ),
          actions: [
            IconButton(icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? AppColors.error : Colors.white), onPressed: () => setState(() => _isFavorite = !_isFavorite), tooltip: 'المفضلة'),
            IconButton(icon: Icon(Icons.share, color: Colors.white), onPressed: () {}, tooltip: 'مشاركة'),
          ],
          bottom: TabBar(
            controller: _tab, indicatorColor: Colors.white, indicatorWeight: 3,
            labelColor: Colors.white, unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [Tab(text: 'نبذة'), Tab(text: 'تقييمات'), Tab(text: 'مواعيد'), Tab(text: 'الأسعار')],
          ),
        ),

        SliverToBoxAdapter(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(14), color: AppColors.surfaceContainerLow,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _actionBtn(Icons.chat, 'محادثة', AppColors.info, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(doctorName: doc['name'])))),
                _actionBtn(Icons.videocam, 'فيديو', AppColors.success, () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(channelName: 'call_${doc['name']}', callerName: doc['name'])))),
                _actionBtn(Icons.call, 'صوتي', AppColors.primary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(channelName: 'call_${doc['name']}', callerName: doc['name'], isVideo: false)))),
                _actionBtn(Icons.person_add, _isFollowing ? 'متابَع' : 'متابعة', AppColors.purple, () => setState(() => _isFollowing = !_isFollowing)),
                _actionBtn(Icons.calendar_today, 'حجز', AppColors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorBookingScreen(doctorId: widget.doctorId ?? '1')))),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height - 300, child: TabBarView(controller: _tab, children: [_aboutTab(doc), _reviewsTab(), _appointmentsTab(doc), _pricingTab(doc)])),
          ]),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 24)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ========== تبويب نبذة ==========
  Widget _aboutTab(Map<String, dynamic> doc) {
    return SingleChildScrollView(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('نبذة عن الطبيب'), Text(doc['about'], style: const TextStyle(fontSize: 13, height: 1.6)),
      const SizedBox(height: 16),
      _sectionTitle('المؤهلات العلمية'), ...(doc['education'] as List).map((e) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [const Icon(Icons.school, color: AppColors.primary, size: 18), const SizedBox(width: 8), Expanded(child: Text(e, style: const TextStyle(fontSize: 12)))]))),
      const SizedBox(height: 16),
      _sectionTitle('الخدمات المقدمة'), ...(doc['services'] as List).map((s) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 16), const SizedBox(width: 8), Text(s, style: const TextStyle(fontSize: 12))]))),
      const SizedBox(height: 16),
      _sectionTitle('معلومات إضافية'),
      _infoRow('اللغات', doc['languages']), _infoRow('المستشفى', doc['hospital']), _infoRow('المرضى', doc['patients']),
      const SizedBox(height: 16),
      _sectionTitle('أوقات الدوام'), ...(doc['availability'] as List).map((a) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [const Icon(Icons.access_time, size: 16, color: AppColors.grey), const SizedBox(width: 6), Text(a, style: const TextStyle(fontSize: 11, color: AppColors.darkGrey))]))),
    ]));
  }

  // ========== تبويب تقييمات ==========
  Widget _reviewsTab() {
    return SingleChildScrollView(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('تقييم الطبيب'),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Text("4.9", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _starRow(4.9),
            const SizedBox(height: 4),
            Text("${_reviews.length} تقييم", style: const TextStyle(fontSize: 12, color: AppColors.grey)),
            const SizedBox(height: 8),
            _ratingBar("5 نجوم", 0.7), _ratingBar("4 نجوم", 0.2), _ratingBar("3 نجوم", 0.05), _ratingBar("2 نجوم", 0.03), _ratingBar("1 نجمة", 0.02),
          ])),
        ])),
      const SizedBox(height: 16),
      _sectionTitle("أضف تقييمك"),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(icon: Icon(i < _userRating ? Icons.star : Icons.star_border, color: AppColors.amber, size: 36), onPressed: () => setState(() => _userRating = i + 1.0)))),
      TextField(controller: _reviewCtrl, maxLines: 3, decoration: InputDecoration(hintText: "اكتب تقييمك...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      const SizedBox(height: 8),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { if (_reviewCtrl.text.isNotEmpty) { _reviewCtrl.clear(); setState(() => _userRating = 0); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال تقييمك، شكراً!"), backgroundColor: AppColors.success)); } }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("إرسال التقييم"))),
      const SizedBox(height: 16),
      _sectionTitle("آخر التقييمات"),
    ]));
  }

  // ========== تبويب مواعيد ==========
  Widget _appointmentsTab(Map<String, dynamic> doc) {
    return Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('الأوقات المتاحة'),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: ['9:00 ص', '9:30 ص', '10:00 ص', '10:30 ص', '11:00 ص', '2:00 م', '2:30 م', '3:00 م', '4:00 م', '5:00 م'].map((t) => ChoiceChip(label: Text(t), selected: false, onSelected: (_) {})).toList()),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorBookingScreen(doctorId: widget.doctorId ?? '1'))), icon: const Icon(Icons.calendar_month), label: const Text('حجز موعد'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))),
    ]));
  }

  // ========== تبويب الأسعار ==========
  Widget _pricingTab(Map<String, dynamic> doc) {
    return Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('أسعار الخدمات'),
      _priceCard('استشارة نصية', '1,500 ر.ي', Icons.chat, AppColors.info),
      _priceCard('استشارة صوتية', '3,000 ر.ي', Icons.call, AppColors.success),
      _priceCard('استشارة فيديو', '5,000 ر.ي', Icons.videocam, AppColors.primary),
      _priceCard('كشف في العيادة', '${doc['fee']} ر.ي', Icons.local_hospital, AppColors.teal),
      _priceCard('زيارة منزلية', '10,000 ر.ي', Icons.home, AppColors.purple),
    ]));
  }

  Widget _priceCard(String name, String price, IconData icon, Color color) {
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color)), const SizedBox(width: 12), Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500))), Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color))]));
  }

  Widget _starRow(double rating) {
    return Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) => Icon(i < rating.floor() ? Icons.star : (rating - i > 0 ? Icons.star_half : Icons.star_border), color: AppColors.amber, size: 16)));
  }

  Widget _ratingBar(String label, double ratio) {
    return Padding(padding: const EdgeInsets.only(bottom: 2), child: Row(children: [SizedBox(width: 50, child: Text(label, style: const TextStyle(fontSize: 10))), Expanded(child: Container(height: 6, margin: const EdgeInsets.symmetric(horizontal: 6), decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(3)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: ratio, child: Container(decoration: BoxDecoration(color: AppColors.amber, borderRadius: BorderRadius.circular(3)))))), Text('${(ratio * 100).toInt()}%', style: const TextStyle(fontSize: 10))]));
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  Widget _infoRow(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [SizedBox(width: 100, child: Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 12))), Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)))],),);

  @override
  void dispose() { _tab.dispose(); _reviewCtrl.dispose(); super.dispose(); }
}
