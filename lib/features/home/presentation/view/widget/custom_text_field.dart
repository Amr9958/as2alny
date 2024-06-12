import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController controller,
    this.onPressed,
  }) : _controller = controller;

  final TextEditingController _controller;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        maxLines: null,
        controller: _controller,
        decoration: InputDecoration(
          suffixIcon:
              IconButton(onPressed: onPressed, icon: const Icon(Icons.image)),
          border: const OutlineInputBorder(),
          labelText: 'Enter your message',
        ),
      ),
    );
  }
}
