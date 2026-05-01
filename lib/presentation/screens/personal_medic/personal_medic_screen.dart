import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class PersonalMedicScreen extends StatefulWidget {
  const PersonalMedicScreen({super.key});
  @override
  State<PersonalMedicScreen> createState() => _PersonalMedicScreenState();
}

class _PersonalMedicScreenState extends State<PersonalMedicScreen> {
  final List<Map<String, String>> _messages = [
    {'role': 'assistant', 'text': 'مرحباً! أنا مسعفك الشخصي. كيف يمكنني مساعدتك؟'},
  ];
  final TextEditingController _controller = TextEditingController();

  final Map<String, String> _quickReplies = {
    'صداع': 'خذ قسطاً من الراحة في مكان هادئ. ضع كمادات باردة على جبهتك. اشرب الماء. إذا استمر الصداع لأكثر من يوم، راجع الطبيب.',
    'جرح': 'اغسل الجرح بماء نظيف. اضغط بقطعة قماش نظيفة لإيقاف النزيف. طهر الجرح. غطِّه بضمادة معقمة.',
    'حروق': 'ضع المنطقة المصابة تحت ماء بارد جار لمدة 20 دقيقة. لا تضع معجون أسنان أو زبدة. غطِّ الحرق بضمادة معقمة.',
    'حمى': 'قس درجة حرارتك. اشرب سوائل بكثرة. خذ باراسيتامول إذا تجاوزت 38.5°. راجع الطبيب إذا استمرت أكثر من 3 أيام.',
    'إسهال': 'اشرب محاليل معالجة الجفاف. تجنب الألبان والأطعمة الدسمة. كل الموز والأرز. راجع الطبيب إذا استمر أكثر من يومين.',
    'تقيؤ': 'توقف عن الأكل لمدة ساعتين. ثم ابدأ برشفات ماء صغيرة. تناول البسكويت المالح تدريجياً.',
    'حساسية': 'تجنب المسبب فوراً. خذ مضاد هيستامين. إذا ظهر تورم في الوجه أو صعوبة تنفس، اتجه للطوارئ فوراً!',
    'لدغة': 'اغسل المكان بالماء والصابون. ضع كمادات باردة. لا تحك المكان. راقب علامات التحسس.',
  ];

  void _ask(String question) {
    setState(() => _messages.add({'role': 'user', 'text': question}));
    _controller.clear();
    Future.delayed(const Duration(seconds: 1), () {
      String reply = 'يرجى استشارة الطبيب للتشخيص الدقيق. هل يمكنني مساعدتك في شيء آخر؟';
      for (var entry in _quickReplies.entries) {
        if (question.contains(entry.key)) { reply = entry.value; break; }
      }
      setState(() => _messages.add({'role': 'assistant', 'text': reply}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المسعف الشخصي ⛑️', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: AppColors.teal, foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, idx) {
              final m = _messages[idx];
              final isUser = m['role'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                  decoration: BoxDecoration(color: isUser ? AppColors.teal : AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                  child: Text(m['text']!, style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 12)),
                ),
              );
            },
          ),
        ),
        // أزرار سريعة
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView(scrollDirection: Axis.horizontal, children: _quickReplies.keys.map((k) => Padding(padding: const EdgeInsets.only(right: 6), child: ActionChip(label: Text(k, style: const TextStyle(fontSize: 10)), onPressed: () => _ask(k)))).toList()),
        ),
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]), child: Row(children: [
          Expanded(child: TextField(controller: _controller, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'صف حالتك...', filled: true, fillColor: AppColors.surfaceContainerLow, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)))),
          const SizedBox(width: 4),
          CircleAvatar(backgroundColor: AppColors.teal, child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 16), onPressed: () => _controller.text.isNotEmpty ? _ask(_controller.text) : null)),
        ])),
      ]),
    );
  }
}
