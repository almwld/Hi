import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class SmartClinicScreen extends StatefulWidget {
  const SmartClinicScreen({super.key});
  @override
  State<SmartClinicScreen> createState() => _SmartClinicScreenState();
}

class _SmartClinicScreenState extends State<SmartClinicScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chatHistory = [
    {'role': 'bot', 'text': 'مرحباً! أنا مساعدك الصحي الذكي. صِف لي أعراضك وسأساعدك في تحليلها.'},
  ];
  bool _isTyping = false;

  final Map<String, String> _smartReplies = {
    'صداع': 'قد يكون الصداع ناتجاً عن إجهاد، قلة نوم، أو جفاف. هل هناك أعراض أخرى مثل غثيان أو حساسية للضوء؟',
    'حمى': 'ارتفاع درجة الحرارة قد يكون مؤشراً لعدوى. هل قست درجة حرارتك؟ وهل هناك أعراض أخرى؟',
    'سعال': 'هل السعال جاف أم مصحوب ببلغم؟ منذ متى بدأ؟',
    'ألم بطن': 'أين يتركز الألم بالتحديد؟ هل هو حاد أم خفيف؟ منذ متى بدأ؟',
    'إسهال': 'من المهم تعويض السوائل. هل هناك دم في البراز؟ هل سافرت مؤخراً؟',
    'تعب': 'الإرهاق المستمر قد يكون له أسباب متعددة: فقر دم، نقص فيتامينات، أو مشاكل الغدة. هل أجريت فحوصات مؤخراً؟',
  };

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _chatHistory.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    Future.delayed(const Duration(seconds: 2), () {
      String reply = 'شكراً لمشاركة أعراضك. أنصحك بمراجعة طبيب مختص للتشخيص الدقيق. هل هناك شيء آخر يمكنني مساعدتك فيه؟';
      for (var entry in _smartReplies.entries) {
        if (text.contains(entry.key)) {
          reply = entry.value;
          break;
        }
      }
      setState(() {
        _chatHistory.add({'role': 'bot', 'text': reply});
        _isTyping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العيادة الذكية 🤖'), actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: () {})]),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(10), color: AppColors.warning.withOpacity(0.08), child: const Row(children: [Icon(Icons.warning_amber, color: AppColors.warning, size: 16), SizedBox(width: 6), Expanded(child: Text('هذه أداة مساعدة فقط وليست تشخيصاً طبياً نهائياً', style: TextStyle(fontSize: 10, color: AppColors.darkGrey)))])),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _chatHistory.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isTyping && index == _chatHistory.length) {
                return const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(8), child: Text('...يكتب المساعد', style: TextStyle(color: AppColors.grey, fontSize: 11))));
              }
              final msg = _chatHistory[index];
              final isBot = msg['role'] == 'bot';
              return Align(
                alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                  decoration: BoxDecoration(color: isBot ? AppColors.surfaceContainerLow : AppColors.primary, borderRadius: BorderRadius.only(topLeft: const Radius.circular(14), topRight: const Radius.circular(14), bottomLeft: isBot ? Radius.zero : const Radius.circular(14), bottomRight: isBot ? const Radius.circular(14) : Radius.zero)),
                  child: Text(msg['text']!, style: TextStyle(color: isBot ? Colors.black87 : Colors.white, fontSize: 13)),
                ),
              );
            },
          ),
        ),
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -1))]), child: Row(children: [
          Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: 'صف أعراضك هنا...', filled: true, fillColor: AppColors.surfaceContainerLow, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)), onSubmitted: _sendMessage)),
          const SizedBox(width: 6),
          CircleAvatar(backgroundColor: AppColors.primary, child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: () => _sendMessage(_controller.text))),
        ])),
      ]),
    );
  }
}
