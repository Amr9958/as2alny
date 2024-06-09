<<<<<<< HEAD
=======
import 'dart:developer';

import 'package:as2lny_app/features/home/presentation/view/widget/custom_text_field.dart';
import 'package:as2lny_app/features/home/presentation/view/widget/send_massages.dart';
>>>>>>> 4e9222b389653380030add88362f04357741962b
import 'package:flutter/material.dart';

import 'chat_bubble_users.dart';
import 'chat_bubble_bot.dart';
import 'custom_text_field.dart';
import 'send_massages.dart';
import '../../../../../core/utils/gemini_service.dart';

enum MessageType {
  bot,
  user,
}

class ChatScreenBody extends StatefulWidget {
  const ChatScreenBody({super.key});

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _messages = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _sendMessage('Hello', MessageType.bot);
  }

  Future<void> _sendMessage(String message, MessageType messageType) async {
    if (message.isEmpty) return;

    String prefix = messageType == MessageType.user ? "You: " : "Bot: ";

    setState(() {
      _messages.add("$prefix$message");
      _isLoading = true;
    });
    log('$_messages');

    final response = await GeminiService.getGeminiResponse(message);

    setState(() {
      _messages.add(" ${response ?? 'Error'}");
      _isLoading = false;

      log('$_isLoading');
    });
    log('$_messages');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final messageType = message.startsWith('You')
                  ? MessageType.user
                  : MessageType.bot;

              switch (messageType) {
                case MessageType.user:
                  return ChatBubbleUsers(
                    message: message,
                  );
                case MessageType.bot:
                  return ChatBubbleBot(
                    message: message,
                  );
                default:
                  return ChatBubbleUsers(
                    message: message,
                  );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CustomTextField(controller: _controller),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SendMassages(
                      onPressed: () {
                        final message = _controller.text;
                        _controller.clear();
                        _sendMessage(message, MessageType.user);
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
