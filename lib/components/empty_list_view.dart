import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/values.dart';

class EmptyListView extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? child;
  const EmptyListView({super.key, required this.icon, required this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: Values.extraLargeIconSize, color: Get.theme.hintColor.withValues(alpha: 0.5)),
          const SizedBox(height: Values.defaultVerticalGap / 2),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: Values.defaultTextSize),
          ),

          if (child != null) ...[
            const SizedBox(height: Values.defaultVerticalGap),
            child!,
          ],

        ],
      ),
    );
  }
}
