import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Enter your message',
        ),
      ),
    );
  }
}
