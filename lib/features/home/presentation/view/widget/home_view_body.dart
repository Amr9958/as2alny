import 'package:as2lny_app/features/home/presentation/view/widget/custom_text_field.dart';
import 'package:as2lny_app/features/home/presentation/view/widget/send_massages.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;


import '../../../../../core/utils/image_packer.dart';
import '../../../cubit/chat_cubit.dart';
import '../../../cubit/chat_state.dart';
import 'chat_bubble_users.dart';
import 'chat_bubble_bot.dart';

import '../../../../../core/utils/gemini_service.dart';

List<MessagesModel> messages = [];
List<MessagesModel> Previewedmessages = [];

class MessagesModel {
  MessagesModel({
    required this.msg,
    required this.type,
  });
  String msg;
  MessageType type;
}

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
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final TextEditingController controller = TextEditingController();
  String _lastWords = "";

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    _initSpeech();
    // context.read<ChatCubit>().addMessage('Hello', 'bot');
    //To do
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    if (status == PermissionStatus.denied) {
      await Permission.microphone.request();
    }
  }

  void _initSpeech() async {
    bool _speechEnabled = await _speechToText.initialize();
    if (!_speechEnabled) {
      print("Speech recognition not available");
    }
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "ar_ar",
      cancelOnError: false,
      partialResults: false,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(stt.SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      controller.text = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final messagesToShow = state.selectedMessages.isNotEmpty ? state.selectedMessages : state.messages;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messagesToShow.length,
                itemBuilder: (context, index) {
                  final message = messagesToShow[index];
                  final messageType = message['type'] == 'user' ? MessageType.user : MessageType.bot;
                  switch (messageType) {
                    case MessageType.user:
                      return ChatBubbleUsers(
                        message: message['message'],
                      );
                    case MessageType.bot:
                      return ChatBubbleBot(
                        message: message['message'],
                      );
                    default:
                      return ChatBubbleUsers(
                        message: message['message'],
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
                      ImagePackerHelper.pickImage(ImageSource.gallery).then((image) {
                        if (image != null) {
                          setState(() {
                            controller.text = image.path;
                          });
                        }
                      });
                    },
                  ),
                  state.isLoading
                      ? const CircularProgressIndicator()
                      : SendMassages(
                          onPressed: () {
                            final message = controller.text;
                            controller.clear();
                            _lastWords = "";
                           context.read<ChatCubit>().setLoading(true);
                            context.read<ChatCubit>().addMessage(message, 'user');
                            GeminiService.getGeminiResponse(message).then((response) {
                              context.read<ChatCubit>().setLoading(false);
                              context.read<ChatCubit>().addMessage(response ?? 'Error', 'bot');
                              context.read<ChatCubit>().clearSelectedMessages();
                            });
                          },
                        ),
                  FloatingActionButton.small(
                    onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                    tooltip: 'Listen',
                    backgroundColor: Colors.blueGrey,
                    child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}