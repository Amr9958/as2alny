import 'dart:developer';

import 'package:as2lny_app/features/home/presentation/view/widget/custom_text_field.dart';
import 'package:as2lny_app/features/home/presentation/view/widget/send_massages.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/api_service.dart';
import '../../../../../core/utils/gemini_service.dart';

class ChatScreenBody extends StatefulWidget {
  const ChatScreenBody({super.key});

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _messages = [];

  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add("You: $message");

      _isLoading = true;
    });
    log('$_messages');

    final response = await GeminiService.getGeminiResponse(message);

    setState(() {
      _messages.add("Bot: ${response ?? 'Error'}");

      _isLoading = false;

      log('$_isLoading');
    });
    log('$_messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('As2lny App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomTextField(controller: _controller),
                SendMassages(
                  onPressed: () {
                    final message = _controller.text;
                    _controller.clear();
                    _sendMessage(message);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
