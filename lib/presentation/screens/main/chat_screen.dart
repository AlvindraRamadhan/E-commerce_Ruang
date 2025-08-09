import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.insert(0, {"role": "user", "content": userMessage});
      _isLoading = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(milliseconds: 1500));

    // FIX: Tambahkan pengecekan 'mounted' setelah proses async
    if (!mounted) return;

    final locale = context.read<LocaleProvider>().locale;

    setState(() {
      _messages.insert(0, {
        "role": "gemini",
        "content": AppStrings.get(locale, 'chatPlaceholder'),
        "isPlaceholder": true
      });
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(locale, 'chatTitle'))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                final isPlaceholder = message['isPlaceholder'] ?? false;

                if (!isPlaceholder) {
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message['content']!,
                        style: TextStyle(
                            color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Lottie.asset('assets/images/error_animation.json',
                            height: 150),
                        const SizedBox(height: 8),
                        Text(message['content']!, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: AppStrings.get(locale, 'chatHint'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
