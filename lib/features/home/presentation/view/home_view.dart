import 'package:as2lny_app/features/home/presentation/view/widget/home_view_body.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('As2lny App'),
      ),
      body: const ChatScreenBody(),
    );
  }
}
  // appBar:
