import 'package:flutter/material.dart';

class SmallIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final String tooltip;

  const SmallIconButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
