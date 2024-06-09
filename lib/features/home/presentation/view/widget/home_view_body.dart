import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

    final response = await _getGeminiResponse(message);

    setState(() {
      _messages.add("Bot: ${response ?? 'Error'}");

      _isLoading = false;
    });
  }

  Future<String?> _getGeminiResponse(String message) async {
    final apiKey =
        Platform.environment['AIzaSyD0TDsH61VwRdjNGkfZ4BAOLYIZ72n7-lY{\rtf1}'];

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey!);

    final content = [Content.text(_controller.text)];

    try {
      final response = await model.generateContent(content);

      print('the response is ' + '${response.text}');

      return response.text;
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('As2alny App'),
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
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
