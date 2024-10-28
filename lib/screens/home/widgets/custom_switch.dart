import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool isSwitched;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.isSwitched,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.5,
          child: Switch(
            value: isSwitched,
            onChanged: onChanged,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}

