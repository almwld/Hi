import 'package:flutter/material.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': "Assalamualaikum! 😊\nHow can I help you today?", 'isMe': false, 'time': '9:30 AM'},
    {'text': "Waalaikumassalam Dr. Ayesha.\nI've been having a headache and mild fever since yesterday.", 'isMe': true, 'time': '9:31 AM'},
    {'text': "I'm sorry to hear that. 😔\nCan you tell me your temperature and any other symptoms?", 'isMe': false, 'time': '9:32 AM'},
    {'text': "My temperature was 100.4°F this morning.\nAlso feeling body ache and a bit of fatigue.", 'isMe': true, 'time': '9:33 AM'},
    {'text': "Thanks for the information.\nPlease see my recommendations below.", 'isMe': false, 'time': '9:35 AM', 'attachment': 'Prescription & Recommendations\nPDF • 245 KB'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: const [CircleAvatar(radius: 18, child: Icon(Icons.person, size: 18)), SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Dr. Ayesha Rahman', style: TextStyle(fontSize: 14)), Text('⭐ 4.9 (128 reviews)', style: TextStyle(fontSize: 10, color: AppColors.grey))])]),
        actions: [IconButton(icon: const Icon(Icons.video_call), onPressed: () {}), IconButton(icon: const Icon(Icons.call), onPressed: () {})],
      ),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(12), color: AppColors.primary.withOpacity(0.05), child: const Row(children: [Icon(Icons.lock, color: AppColors.grey, size: 14), SizedBox(width: 4), Text('Your consultation is private and secure', style: TextStyle(fontSize: 11, color: AppColors.grey))], mainAxisAlignment: MainAxisAlignment.center)),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return Align(
                alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: msg['isMe'] ? AppColors.primary : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: msg['isMe'] ? const Radius.circular(16) : Radius.zero,
                      bottomRight: msg['isMe'] ? Radius.zero : const Radius.circular(16),
                    ),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(msg['text'], style: TextStyle(color: msg['isMe'] ? Colors.white : Colors.black87, fontSize: 13)),
                    if (msg['attachment'] != null) ...[
                      const SizedBox(height: 8),
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: msg['isMe'] ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 20), const SizedBox(width: 8), Expanded(child: Text(msg['attachment'], style: TextStyle(fontSize: 10, color: msg['isMe'] ? Colors.white : Colors.black87)))])),
                    ],
                    const SizedBox(height: 4),
                    Text(msg['time'], style: TextStyle(fontSize: 9, color: msg['isMe'] ? Colors.white60 : AppColors.grey), textAlign: TextAlign.right),
                  ]),
                ),
              );
            },
          ),
        ),
        // شريط الإدخال
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
          child: Row(children: [
            IconButton(icon: const Icon(Icons.attach_file, color: AppColors.grey), onPressed: () {}),
            Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: 'Type a message...', filled: true, fillColor: AppColors.surfaceContainerLow, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)))),
            const SizedBox(width: 4),
            CircleAvatar(backgroundColor: AppColors.primary, child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: () { if (_controller.text.isNotEmpty) { setState(() => _messages.add({'text': _controller.text, 'isMe': true, 'time': 'Now'})); _controller.clear(); } })),
          ]),
        ),
      ]),
    );
  }
}
