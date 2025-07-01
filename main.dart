
import 'package:flutter/material.dart';
import 'services/ai_service.dart';
import 'services/memory_service.dart';

void main() {
  runApp(const ZappyAIApp());
}

class ZappyAIApp extends StatelessWidget {
  const ZappyAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zappy AI',
      theme: ThemeData.dark(),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messages = <String>[];
  final _controller = TextEditingController();

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _messages.add('You: $text'));
    _controller.clear();

    String reply = await AIService.instance.getReply(text);
    setState(() => _messages.add('Zappy: $reply'));
    await MemoryService.instance.addFact(text, reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zappy AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_messages[i]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(
                      hintText: 'Ask anything...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
