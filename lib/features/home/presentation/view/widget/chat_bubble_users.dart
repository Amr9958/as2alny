import 'package:flutter/material.dart';

class ChatBubbleUsers extends StatelessWidget {
  const ChatBubbleUsers({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding:
            const EdgeInsets.only(bottom: 16, top: 16, left: 16, right: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
            bottomLeft: Radius.circular(0),
          ),
          color: Colors.green,
        ),
        child: SizedBox(child: Text(message)),
      ),
    );
  }
}
