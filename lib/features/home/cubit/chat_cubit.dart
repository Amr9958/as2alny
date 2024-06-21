import 'package:as2lny_app/features/home/cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState(messages: [], isLoading: false, selectedMessages: []));

  void addMessage(String message, String type) {
    final newMessage = {"message": message, "type": type};
    final box = Hive.box('messagesBox');

    // Store message in Hive box
    box.add(newMessage);

    // Update state
    final updatedMessages = List<Map<String, dynamic>>.from(state.messages)
      ..add(newMessage);
    emit(ChatState(messages: updatedMessages, isLoading: state.isLoading, selectedMessages: state.selectedMessages));
  }

  List<Map<String, dynamic>> getUserMessages() {
    final box = Hive.box('messagesBox');
    return box.values
        .where((message) => message['type'] == 'user')
        .map((message) => Map<String, dynamic>.from(message as Map))
        .toList();
  }

  void clearMessages() {
    final box = Hive.box('messagesBox');
    box.clear();

    emit(ChatState(messages: [], isLoading: state.isLoading, selectedMessages: []));
  }

  void setLoading(bool isLoading) {
    emit(ChatState(messages: state.messages, isLoading: isLoading, selectedMessages: state.selectedMessages));
  }

  void selectMessagePair(int index) {
    final box = Hive.box('messagesBox');
    final userMessage = Map<String, dynamic>.from(box.getAt(index * 2) as Map);
    final botMessage = Map<String, dynamic>.from(box.getAt(index * 2 + 1) as Map);
    emit(ChatState(messages: state.messages, isLoading: state.isLoading, selectedMessages: [userMessage, botMessage]));
  }
    void clearSelectedMessages() {
    emit(ChatState(messages: state.messages, isLoading: state.isLoading, selectedMessages: []));
  }
}