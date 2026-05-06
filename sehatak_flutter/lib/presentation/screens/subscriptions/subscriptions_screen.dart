import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});
  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _selectedPlan = 2; // الباقة الذهبية افتراضياً

  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الباقات والاشتراكات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tab, isScrollable: true,
          indicatorColor: Colors.white, indicatorWeight: 3,
          labelColor: Colors.white, unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(text: 'الباقات'),
            Tab(text: 'الاستشارات'),
            Tab(text: 'العروض'),
            Tab(text: 'حسابي'),
          ],
        ),
      ),
      body: TabBarView(controller: _tab, children: [
        _buildPlansTab(),
        _buildConsultationsTab(),
        _buildOffersTab(),
        _buildMyAccountTab(),
      ]),
    );
  }

  // ========== 1. تبويب الباقات ==========
  Widget _buildPlansTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('اختر الباقة المناسبة لك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('وفر أكثر مع الباقات السنوية - خصم يصل إلى 40%', style: TextStyle(color: AppColors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        
        // الباقة المجانية
        _planCard(
          title: 'الباقة المجانية', emoji: '🆓',
          price: '0', period: 'للأبد',
          color: AppColors.grey,
          features: [
            '✅ 3 استشارات مجانية شهرياً',
            '✅ سجل صحي إلكتروني',
            '✅ تذكير بالمواعيد',
            '✅ تصفح الأدوية والأسعار',
            '❌ استشارات غير محدودة',
            '❌ تحاليل منزلية',
            '❌ أولوية في الحجز',
          ],
          selected: _selectedPlan == 0,
        ),
        const SizedBox(height: 12),
        
        // الباقة الفضية
        _planCard(
          title: 'الباقة الفضية', emoji: '🥈',
          price: '3,000', period: 'شهرياً',
          color: AppColors.info,
          features: [
            '✅ 10 استشارات شهرياً',
            '✅ خصم 20% على الأدوية',
            '✅ تحليل منزلي مجاني شهرياً',
            '✅ متابعة دورية مع طبيب',
            '✅ تقارير صحية شهرية',
            '✅ سجل صحي متقدم',
            '❌ استشارات غير محدودة',
            '❌ أولوية قصوى',
          ],
          selected: _selectedPlan == 1,
        ),
        const SizedBox(height: 12),
        
        // الباقة الذهبية ⭐
        _planCard(
          title: 'الباقة الذهبية', emoji: '🥇',
          price: '4,900', period: 'شهرياً',
          color: AppColors.amber,
          isPopular: true,
          discount: 'وفر 40% سنوياً - 35,000 ر.ي فقط',
          features: [
            '✅ استشارات غير محدودة 24/7',
            '✅ خصم 35% على جميع الأدوية',
            '✅ تحاليل منزلية مجانية',
            '✅ أولوية في الحجز',
            '✅ طبيب شخصي مخصص',
            '✅ تقارير صحية أسبوعية',
            '✅ فيديوهات تثقيفية حصرية',
            '✅ دعم فني VIP',
          ],
          selected: _selectedPlan == 2,
        ),
        const SizedBox(height: 12),
        
        // باقة العائلة
        _planCard(
          title: 'باقة العائلة', emoji: '👨‍👩‍👧‍👦',
          price: '7,500', period: 'شهرياً',
          color: AppColors.purple,
          features: [
            '✅ كل مميزات الذهبية',
            '✅ حتى 5 أفراد من العائلة',
            '✅ استشارات أطفال مجانية',
            '✅ متابعة حمل وولادة',
            '✅ تطعيمات مجانية للأطفال',
            '✅ طبيب عائلة مخصص',
            '✅ خصم 50% على الأدوية',
            '✅ تقارير عائلية شاملة',
          ],
          selected: _selectedPlan == 3,
        ),
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _planCard({
    required String title, required String emoji,
    required String price, required String period,
    required Color color, required List<String> features,
    bool isPopular = false, String? discount, bool selected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? color : Colors.transparent, width: selected ? 2 : 0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (isPopular)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.amber, borderRadius: BorderRadius.circular(20)),
            child: const Text('🌟 الأكثر شيوعاً', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            if (discount != null) Text(discount, style: const TextStyle(fontSize: 10, color: AppColors.success)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('$price ر.ي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text('/$period', style: const TextStyle(fontSize: 10, color: AppColors.grey)),
          ]),
        ]),
        const Divider(height: 20),
        ...features.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(f, style: TextStyle(fontSize: 12, color: f.startsWith('✅') ? AppColors.success : f.startsWith('❌') ? AppColors.grey : AppColors.darkGrey)),
        )),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, height: 46,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: selected ? color : AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(selected ? 'باقتك الحالية' : 'اشترك الآن', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }

  // ========== 2. تبويب الاستشارات ==========
  Widget _buildConsultationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('أسعار الاستشارات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('اختر نوع الاستشارة المناسبة', style: TextStyle(color: AppColors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        
        _consultationCard('💬', 'استشارة نصية', 'تواصل مع الطبيب عبر الرسائل النصية', '1,500', 'خلال ساعة', AppColors.info),
        _consultationCard('📞', 'استشارة صوتية', 'مكالمة صوتية مباشرة', '3,000', 'خلال 15 دقيقة', AppColors.success),
        _consultationCard('📹', 'استشارة مرئية', 'مكالمة فيديو مباشرة', '5,000', 'خلال 5 دقائق', AppColors.primary),
        _consultationCard('🚨', 'استشارة طارئة', 'استشارة فورية للحالات الطارئة', '8,000', 'فوري', AppColors.error),
        _consultationCard('🏠', 'زيارة منزلية', 'زيارة طبيب إلى منزلك', '10,000', 'خلال ساعتين', AppColors.purple),
        _consultationCard('🩺', 'كشف عام', 'فحص طبي شامل', '4,000', 'خلال 30 دقيقة', AppColors.teal),
      ]),
    );
  }

  Widget _consultationCard(String emoji, String title, String desc, String price, String speed, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
      child: Row(children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.grey)), Text('⏱️ $speed', style: const TextStyle(fontSize: 10, color: AppColors.grey))])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('$price ر.ي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, minimumSize: const Size(70, 28), padding: const EdgeInsets.symmetric(horizontal: 10), textStyle: const TextStyle(fontSize: 11)).copyWith(elevation: MaterialStateProperty.all(0)), child: const Text('احجز')),
        ]),
      ]),
    );
  }

  // ========== 3. تبويب العروض ==========
  Widget _buildOffersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('عروض حصرية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('لفترة محدودة - سارع بالحجز', style: TextStyle(color: AppColors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        
        // عرض 1
        _offerCard('🎉', 'خصم 50% على الباقة الذهبية', 'للثلاثة أشهر الأولى', '4,900', '2,450', AppColors.amber, 'ينتهي خلال 7 أيام'),
        _offerCard('👨‍👩‍👧‍👦', 'باقة العائلة + استشارات مجانية', 'شهر مجاناً عند الاشتراك السنوي', '7,500', '0', AppColors.purple, 'العرض محدود'),
        _offerCard('🏥', 'فحص شامل مجاني', 'مع أي باقة سنوية - تحاليل + كشف', '15,000', 'مجاناً', AppColors.success, 'لأول 100 مشترك'),
        _offerCard('💊', 'خصم 40% على الأدوية', 'للمشتركين في الباقة الذهبية', 'خصم', '40%', AppColors.info, 'طوال مدة الاشتراك'),
        _offerCard('📱', 'استشارة مجانية', 'عند تحميل التطبيق لأول مرة', '3,000', 'مجاناً', AppColors.primary, 'للمستخدمين الجدد'),
        _offerCard('👶', 'متابعة أطفال مجانية', 'حتى عمر 5 سنوات مع باقة العائلة', '10,000', 'مجاناً', AppColors.teal, 'يشمل التطعيمات'),
      ]),
    );
  }

  Widget _offerCard(String emoji, String title, String desc, String oldPrice, String newPrice, Color color, String badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.05), color.withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(badge, style: TextStyle(fontSize: 9, color: color))),
        ]),
        const SizedBox(height: 4),
        Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.grey)),
        const SizedBox(height: 10),
        Row(children: [
          Text(oldPrice, style: const TextStyle(fontSize: 13, color: AppColors.grey, decoration: TextDecoration.lineThrough)),
          const SizedBox(width: 8),
          Text(newPrice, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const Spacer(),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, minimumSize: const Size(90, 30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('استفد الآن')),
        ]),
      ]),
    );
  }

  // ========== 4. تبويب حسابي ==========
  Widget _buildMyAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('اشتراكي الحالي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        
        // بطاقة الاشتراك الحالي
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.amber, Color(0xFFFF8F00)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: [
            const Icon(Icons.workspace_premium, color: Colors.white, size: 50),
            const SizedBox(height: 8),
            const Text('الباقة الذهبية', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('سارية حتى 6 يونيو 2026', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle, color: Colors.white, size: 18), SizedBox(width: 6), Text('الدفع التالي: 6 يونيو - 4,900 ر.ي', style: TextStyle(color: Colors.white, fontSize: 12))])),
          ]),
        ),
        const SizedBox(height: 16),
        
        // إحصائيات
        Row(children: [
          _statCard('استشارات متبقية', 'غير محدود', Icons.chat, AppColors.info),
          const SizedBox(width: 8),
          _statCard('توفير هذا الشهر', '2,450 ر.ي', Icons.savings, AppColors.success),
          const SizedBox(width: 8),
          _statCard('ترقية متاحة', 'باقة العائلة', Icons.upgrade, AppColors.purple),
        ]),
        const SizedBox(height: 20),
        
        // خيارات الدفع
        const Text('طرق الدفع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _paymentMethod('💳', 'فلوسك', '**** 4582'),
        _paymentMethod('💰', 'كاش', '**** 7891'),
        _paymentMethod('📱', 'جوالي', '**** 3456'),
        const SizedBox(height: 20),
        
        // إدارة الاشتراك
        const Text('إدارة الاشتراك', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListTile(leading: const Icon(Icons.upgrade, color: AppColors.primary), title: const Text('ترقية الباقة'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}),
        ListTile(leading: const Icon(Icons.pause_circle, color: AppColors.warning), title: const Text('تجميد الاشتراك'), subtitle: const Text('حتى 3 أشهر'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}),
        ListTile(leading: const Icon(Icons.cancel, color: AppColors.error), title: const Text('إلغاء الاشتراك'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}),
      ]),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [Icon(icon, color: color, size: 24), const SizedBox(height: 6), Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)), const SizedBox(height: 2), Text(title, style: const TextStyle(fontSize: 9, color: AppColors.grey), textAlign: TextAlign.center)]),
      ),
    );
  }

  Widget _paymentMethod(String emoji, String name, String number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 24)), const SizedBox(width: 10), Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))), Text(number, style: const TextStyle(color: AppColors.grey, fontSize: 12))]),
    );
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }
}
