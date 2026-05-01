import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class InteractiveMapScreen extends StatefulWidget {
  final String type; // hospitals, pharmacies, labs, clinics, tracking
  final String? orderId;
  const InteractiveMapScreen({super.key, this.type = 'hospitals', this.orderId});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  late final MapController _mapController;
  static const LatLng sanaaCenter = LatLng(15.3694, 44.1910);
  String _selectedLayer = 'CartoDB Voyager';
  Position? _currentPosition;
  LatLng? _selectedLocation;
  int _currentStep = 2;

  final Map<String, Map<String, String>> _mapLayers = {
    'CartoDB Voyager': {'url': 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png', 'desc': 'خرائط ملونة'},
    'CartoDB Light': {'url': 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', 'desc': 'خرائط فاتحة'},
    'CartoDB Dark': {'url': 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 'desc': 'خرائط داكنة'},
  };

  // ============ مستشفيات صنعاء ============
  final List<Map<String, dynamic>> _hospitals = [
    {'name': 'مستشفى الثورة العام', 'address': 'شارع الزبيري، باب اليمن', 'lat': 15.3500, 'lng': 44.2000, 'phone': '01-222222', 'type': 'حكومي', 'beds': '500', 'emergency': true},
    {'name': 'مستشفى الكويت الجامعي', 'address': 'شارع الخمسين، الحصبة', 'lat': 15.3800, 'lng': 44.2100, 'phone': '01-333333', 'type': 'جامعي', 'beds': '400', 'emergency': true},
    {'name': 'مستشفى السبعين للأمومة والطفولة', 'address': 'السبعين، شارع الأربعين', 'lat': 15.3100, 'lng': 44.1800, 'phone': '01-444444', 'type': 'تخصصي', 'beds': '300', 'emergency': true},
    {'name': 'مستشفى آزال', 'address': 'شارع هائل، التحرير', 'lat': 15.3600, 'lng': 44.1950, 'phone': '01-555555', 'type': 'خاص', 'beds': '150', 'emergency': true},
    {'name': 'مستشفى جامعة العلوم والتكنولوجيا', 'address': 'شارع الستين، الحديدة', 'lat': 15.3400, 'lng': 44.1700, 'phone': '01-666666', 'type': 'جامعي', 'beds': '250', 'emergency': true},
    {'name': 'المستشفى العسكري', 'address': 'شارع القاهرة، التحرير', 'lat': 15.3550, 'lng': 44.2050, 'phone': '01-777777', 'type': 'عسكري', 'beds': '600', 'emergency': true},
    {'name': 'مستشفى النقيب', 'address': 'شارع العدين، شارع الستين', 'lat': 15.3300, 'lng': 44.1850, 'phone': '01-888888', 'type': 'خاص', 'beds': '100', 'emergency': false},
    {'name': 'مستشفى العلوم الحديثة', 'address': 'شارع الخمسين، تقاطع هائل', 'lat': 15.3750, 'lng': 44.2000, 'phone': '01-999999', 'type': 'خاص', 'beds': '120', 'emergency': true},
  ];

  // ============ صيدليات صنعاء ============
  final List<Map<String, dynamic>> _pharmacies = [
    {'name': 'صيدلية الشفاء', 'address': 'شارع الزبيري، أمام مستشفى الثورة', 'lat': 15.3510, 'lng': 44.1990, 'phone': '01-123456', 'hours': '24 ساعة'},
    {'name': 'صيدلية اليمن', 'address': 'شارع التحرير، بجانب البنك المركزي', 'lat': 15.3580, 'lng': 44.1930, 'phone': '01-234567', 'hours': '8 ص - 12 م'},
    {'name': 'صيدلية الأمل', 'address': 'شارع هائل، أمام جامعة صنعاء', 'lat': 15.3650, 'lng': 44.1970, 'phone': '01-345678', 'hours': '24 ساعة'},
    {'name': 'صيدلية ابن حيان', 'address': 'شارع الستين، الحصبة', 'lat': 15.3820, 'lng': 44.2080, 'phone': '01-456789', 'hours': '8 ص - 11 م'},
    {'name': 'صيدلية الشهيد', 'address': 'شارع القاهرة، باب اليمن', 'lat': 15.3480, 'lng': 44.2020, 'phone': '01-567890', 'hours': '24 ساعة'},
    {'name': 'صيدلية النصر', 'address': 'شارع الأربعين، شارع الستين', 'lat': 15.3250, 'lng': 44.1830, 'phone': '01-678901', 'hours': '9 ص - 10 م'},
  ];

  // ============ مختبرات صنعاء ============
  final List<Map<String, dynamic>> _labs = [
    {'name': 'مختبر الثقة', 'address': 'شارع الزبيري، عمارة النعمان', 'lat': 15.3520, 'lng': 44.1980, 'phone': '01-789012', 'tests': '500+'},
    {'name': 'مختبر البرج', 'address': 'شارع هائل، جولة كنتاكي', 'lat': 15.3620, 'lng': 44.1960, 'phone': '01-890123', 'tests': '400+'},
    {'name': 'مختبر اليقين', 'address': 'شارع التحرير، عمارة البساطي', 'lat': 15.3570, 'lng': 44.1940, 'phone': '01-901234', 'tests': '350+'},
    {'name': 'المختبر الوطني', 'address': 'شارع الستين، أمام المستشفى العسكري', 'lat': 15.3540, 'lng': 44.2030, 'phone': '01-012345', 'tests': '600+'},
    {'name': 'مختبرات الحياة', 'address': 'شارع الخمسين، الحصبة', 'lat': 15.3780, 'lng': 44.2070, 'phone': '01-123789', 'tests': '300+'},
  ];

  // ============ عيادات صنعاء ============
  final List<Map<String, dynamic>> _clinics = [
    {'name': 'مجمع السلام الطبي', 'address': 'شارع الزبيري، بجانب برج زبيدة', 'lat': 15.3530, 'lng': 44.1970, 'phone': '01-456123', 'specialties': 'عام، أسنان، جلدية'},
    {'name': 'مركز ابن سينا', 'address': 'شارع هائل، أمام البريد', 'lat': 15.3630, 'lng': 44.1950, 'phone': '01-567234', 'specialties': 'باطنية، قلب، عظام'},
    {'name': 'مجمع الرازي الطبي', 'address': 'شارع التحرير، عمارة الكبوس', 'lat': 15.3590, 'lng': 44.1920, 'phone': '01-678345', 'specialties': 'أطفال، نساء، أنف وأذن'},
    {'name': 'مركز اليمن الدولي', 'address': 'شارع الستين، تقاطع هائل', 'lat': 15.3700, 'lng': 44.1990, 'phone': '01-789456', 'specialties': 'عيون، أعصاب، مسالك'},
    {'name': 'العيادة الشاملة', 'address': 'شارع الخمسين، أمام المستشفى الكويتي', 'lat': 15.3790, 'lng': 44.2090, 'phone': '01-890567', 'specialties': 'عام، طوارئ'},
  ];

  List<Map<String, dynamic>> get _currentLocations {
    switch (widget.type) {
      case 'hospitals': return _hospitals;
      case 'pharmacies': return _pharmacies;
      case 'labs': return _labs;
      case 'clinics': return _clinics;
      case 'tracking': return _hospitals;
      default: return _hospitals;
    }
  }

  String get _title {
    switch (widget.type) {
      case 'hospitals': return 'المستشفيات';
      case 'pharmacies': return 'الصيدليات';
      case 'labs': return 'المختبرات';
      case 'clinics': return 'العيادات';
      case 'tracking': return 'تتبع الطلب';
      default: return 'الخريطة';
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case 'hospitals': return Icons.local_hospital;
      case 'pharmacies': return Icons.local_pharmacy;
      case 'labs': return Icons.science;
      case 'clinics': return Icons.medical_services;
      case 'tracking': return Icons.local_shipping;
      default: return Icons.map;
    }
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        setState(() => _currentPosition = position);
      }
    } catch (_) {}
  }

  void _goToLocation(double lat, double lng) {
    _mapController.move(LatLng(lat, lng), 15);
    setState(() => _selectedLocation = LatLng(lat, lng));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final layerUrl = isDark ? _mapLayers['CartoDB Dark']!['url']! : _mapLayers[_selectedLayer]!['url']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (widget.type != 'tracking')
            PopupMenuButton<String>(
              icon: const Icon(Icons.layers, color: Colors.white),
              onSelected: (v) => setState(() => _selectedLayer = v),
              itemBuilder: (_) => _mapLayers.keys.map((k) => PopupMenuItem(value: k, child: Text(k))).toList(),
            ),
        ],
      ),
      body: Stack(
        children: [
          // الخريطة
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: sanaaCenter, initialZoom: 13),
            children: [
              TileLayer(urlTemplate: layerUrl, userAgentPackageName: 'com.sehatak.app'),
              // علامات المواقع
              MarkerLayer(
                markers: _currentLocations.map((loc) {
                  final lat = loc['lat'] as double;
                  final lng = loc['lng'] as double;
                  final isSelected = _selectedLocation?.latitude == lat && _selectedLocation?.longitude == lng;
                  return Marker(
                    point: LatLng(lat, lng),
                    width: isSelected ? 50 : 36,
                    height: isSelected ? 50 : 36,
                    child: GestureDetector(
                      onTap: () {
                        _goToLocation(lat, lng);
                        _showLocationDetails(loc);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getMarkerColor(),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5)],
                        ),
                        child: Icon(_icon, color: Colors.white, size: isSelected ? 24 : 16),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // موقع المستخدم
              if (_currentPosition != null)
                MarkerLayer(markers: [
                  Marker(
                    point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    width: 30, height: 30,
                    child: Container(decoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle), child: const Icon(Icons.my_location, color: Colors.blue, size: 16)),
                  ),
                ]),
            ],
          ),
          // أزرار التحكم
          Positioned(
            right: 12, bottom: 160,
            child: Column(children: [
              FloatingActionButton(heroTag: 'zoom_in', mini: true, onPressed: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1), backgroundColor: AppColors.primary, child: const Icon(Icons.add, color: Colors.white)),
              const SizedBox(height: 6),
              FloatingActionButton(heroTag: 'zoom_out', mini: true, onPressed: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1), backgroundColor: AppColors.primary, child: const Icon(Icons.remove, color: Colors.white)),
            ]),
          ),
          // زر موقعي
          Positioned(left: 12, bottom: 160, child: FloatingActionButton(heroTag: 'my_loc', mini: true, onPressed: _getCurrentLocation, backgroundColor: AppColors.info, child: const Icon(Icons.my_location, color: Colors.white))),
          // شريط المواقع
          Positioned(bottom: 0, left: 0, right: 0, child: _buildLocationsList()),
          // تتبع الطلب
          if (widget.type == 'tracking') Positioned(top: 12, left: 12, right: 12, child: _buildTrackingCard()),
        ],
      ),
    );
  }

  Widget _buildLocationsList() {
    return Container(
      height: 140,
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))]),
      child: Column(children: [
        Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 8), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            itemCount: _currentLocations.length,
            itemBuilder: (context, index) {
              final loc = _currentLocations[index];
              return GestureDetector(
                onTap: () => _goToLocation(loc['lat'], loc['lng']),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _selectedLocation?.latitude == loc['lat'] ? AppColors.primary : Colors.transparent, width: 2),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Icon(_icon, size: 14, color: _getMarkerColor()), const SizedBox(width: 4), Expanded(child: Text(loc['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                    const SizedBox(height: 2),
                    Text(loc['address'], style: const TextStyle(fontSize: 9, color: AppColors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    if (loc['phone'] != null) Row(children: [const Icon(Icons.phone, size: 10, color: AppColors.success), const SizedBox(width: 2), Text(loc['phone'], style: const TextStyle(fontSize: 9, color: AppColors.success))]),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildTrackingCard() {
    final steps = ['تم الطلب', 'قيد التجهيز', 'تم الشحن', 'تم التوصيل'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
      child: Column(children: [
        Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.local_shipping, color: AppColors.primary)), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('طلبك في الطريق!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('رقم الطلب: ${widget.orderId ?? "#SHK-784512"}', style: TextStyle(fontSize: 10, color: AppColors.grey))]))]),
        const SizedBox(height: 12),
        Row(children: List.generate(steps.length, (i) => Expanded(child: Column(children: [Container(width: 14, height: 14, decoration: BoxDecoration(color: i < _currentStep ? AppColors.success : AppColors.grey, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: i < _currentStep ? const Icon(Icons.check, size: 8, color: Colors.white) : null), const SizedBox(height: 4), Text(steps[i], style: TextStyle(fontSize: 8, color: i < _currentStep ? AppColors.success : AppColors.grey))])))),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('⏱️ ', style: TextStyle(fontSize: 16)), Text('الوقت المتوقع: 18 دقيقة', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 13))])),
      ]),
    );
  }

  Color _getMarkerColor() {
    switch (widget.type) {
      case 'hospitals': return AppColors.error;
      case 'pharmacies': return AppColors.success;
      case 'labs': return AppColors.info;
      case 'clinics': return AppColors.purple;
      case 'tracking': return AppColors.primary;
      default: return AppColors.primary;
    }
  }

  void _showLocationDetails(Map<String, dynamic> loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(_icon, color: _getMarkerColor(), size: 28), const SizedBox(width: 10), Expanded(child: Text(loc['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))]),
          const SizedBox(height: 12),
          _detailRow(Icons.location_on, loc['address']),
          if (loc['phone'] != null) _detailRow(Icons.phone, loc['phone']),
          if (loc['hours'] != null) _detailRow(Icons.access_time, loc['hours']),
          if (loc['type'] != null) _detailRow(Icons.category, loc['type']),
          if (loc['beds'] != null) _detailRow(Icons.bed, '${loc['beds']} سرير'),
          if (loc['specialties'] != null) _detailRow(Icons.medical_services, loc['specialties']),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: ElevatedButton.icon(onPressed: () async { final url = Uri.parse('tel:${loc['phone']}'); if (await canLaunchUrl(url)) launchUrl(url); }, icon: const Icon(Icons.call), label: const Text('اتصال'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.success))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.navigation), label: const Text('توجيه'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))),
          ]),
        ]),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [Icon(icon, size: 16, color: AppColors.grey), const SizedBox(width: 8), Expanded(child: Text(text, style: const TextStyle(fontSize: 13)))]),
    );
  }
}
