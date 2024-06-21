import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../cubit/chat_cubit.dart';
import '../../cubit/chat_state.dart';
import 'widget/home_view_body.dart'; // استيراد Cubit

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('As2lny App'),
      ),
      body: const ChatScreenBody(),
      drawer: const ChatDrawer(),
    );
  }
}

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 150,
            child: DrawerHeader(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Saved Messages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {
                // مسح قائمة الرسائل والصندوق
                context.read<ChatCubit>().clearMessages();
              },
              child: Text('Clear'),
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var userMessages = context.read<ChatCubit>().getUserMessages();
                return ListView.builder(
                  itemCount: userMessages.length,
                  itemBuilder: (context, index) {
                    final userMessage = userMessages[index];
                    return GestureDetector(
                        onLongPress: () {
                          _showOptions(context, index, userMessage);
                        },
                        child: ListTile(
                          title: Text(
                            "${userMessage['message']}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            context.read<ChatCubit>().selectMessagePair(index);
                          },
                          onLongPress: () {},
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(
      BuildContext context, int index, Map<String, dynamic> userMessage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () {
                  _shareMessage(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  _deleteMessage(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareMessage(BuildContext context, int index) {
    final box = Hive.box('messagesBox');
    final userMessage = box.getAt(index * 2)['message'];
    final botMessage = box.getAt(index * 2 + 1)['message'];
    Share.share('Q: $userMessage\nA: $botMessage');
    Navigator.pop(context);
  }

  void _deleteMessage(BuildContext context, int index) {
    final box = Hive.box('messagesBox');
    box.deleteAt(index * 2); // delete user message
    box.deleteAt(index *
        2); // delete bot message (index remains the same after deletion)
    context.read<ChatCubit>().emit(ChatState(
        messages: List<Map<String, dynamic>>.from(box.values),
        isLoading: false,
        selectedMessages: []));
    Navigator.pop(context);
  }
}
