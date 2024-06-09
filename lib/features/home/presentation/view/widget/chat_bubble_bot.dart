import 'package:flutter/material.dart';

class ChatBubbleBot extends StatelessWidget {
  const ChatBubbleBot({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding:
            const EdgeInsets.only(bottom: 16, top: 16, left: 16, right: 16),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(0),
              bottomLeft: Radius.circular(32),
            ),
            color: Colors.greenAccent),
        child: Text(
          message,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
