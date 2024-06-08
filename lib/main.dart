import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(ChatGPTApp());

class ChatGPTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'as2alny App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add("You: $message");
      _isLoading = true;
    });

    final response = await _getChatGPTResponse(message);

    setState(() {
      _messages.add("Bot: ${response ?? 'Error'}");
      _isLoading = false;
    });
  }

  Future<String?> _getChatGPTResponse(String message) async {
    final apiKey = 'your-openai-api-key'; // Replace with your OpenAI API key
    final url = Uri.parse(
        'https://api.openai.com/v1/engines/davinci-codex/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      'prompt': message,
      'max_tokens': 150,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      return responseBody['choices'][0]['text'].trim();
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('As2alny App'),
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
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
