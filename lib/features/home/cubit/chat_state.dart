import 'package:equatable/equatable.dart';

class ChatState extends Equatable{
  final List<Map<String, dynamic>> messages;
  final List<Map<String, dynamic>> selectedMessages;
  final bool isLoading;

  const ChatState({required this.messages, required this.isLoading, required this.selectedMessages});
  
  @override
  // TODO: implement props
  List<Object?> get props => [messages, isLoading, selectedMessages];
}