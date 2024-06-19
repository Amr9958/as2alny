import 'package:as2lny_app/features/home/presentation/view/widget/custom_text_field.dart';
import 'package:as2lny_app/features/home/presentation/view/widget/send_massages.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../../core/utils/image_packer.dart';
import 'chat_bubble_users.dart';
import 'chat_bubble_bot.dart';

import '../../../../../core/utils/gemini_service.dart';

List<String> messages = [];
  final TextEditingController controller = TextEditingController();

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
  //init the hive box
  var box = Hive.box('messagesBox');
  /////////////////
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    _initSpeech(); // تهيئة SpeechToText
    _sendMessage('Hello', MessageType.bot);
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
        break;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  void _loadMessages() async {
    var box = Hive.box('messagesBox');
    setState(() {
      messages = box.values.map((msg) {
        String prefix = msg['type'] == 'user' ? "You: " : "Bot: ";
        return "$prefix${msg['message']}";
      }).toList();
    });
  }

  Future<void> _sendMessage(String message, MessageType messageType) async {
    if (message.trim().isEmpty)
      return; // تعديل هذا السطر للتأكد من أن الرسالة ليست فارغة

    String prefix = messageType == MessageType.user ? "You: " : "Bot: ";

    setState(() {
      messages.add("$prefix$message");
      _isLoading = true;
    });

    final response = await GeminiService.getGeminiResponse(message);

    setState(() {
      messages.add(" ${response ?? 'Error'}");
      _isLoading = false;
    });
    box.add({
      "message": message,
      "type": messageType == MessageType.user ? "user" : "bot"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
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
              CustomTextField(
                controller: controller,
                onPressed: () {
                  ImagePackerHelper.pickImage(ImageSource.gallery)
                      .then((image) {
                    if (image != null) {
                      setState(() {
                        controller.text = image.path;
                      });
                    }
                  });
                },
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SendMassages(
                      onPressed: () {
                        final message = controller.text;
                        controller.clear();
                        _lastWords = "";
                        _sendMessage(message, MessageType.user);
                      },
                    ),
              FloatingActionButton.small(
                onPressed:
                    // If not yet listening for speech start, otherwise stop
                    _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                tooltip: 'Listen',
                backgroundColor: Colors.blueGrey,
                child: Icon(
                    _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "ar_ar",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      controller.text = _lastWords;
    });
  }
}
