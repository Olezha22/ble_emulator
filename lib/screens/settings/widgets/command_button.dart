import 'package:flutter/material.dart';

class CommandButton extends StatelessWidget {
  final String command;
  final Future<void> Function() onPressed;

  const CommandButton({
    super.key,
    required this.command,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
        ),
        child: Text(
          command,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
