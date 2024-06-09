import 'package:flutter/material.dart';

class SendMassages extends StatelessWidget {
  const SendMassages({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: onPressed,
    );
  }
}
