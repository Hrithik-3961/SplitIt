import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/values.dart';

class GroupsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const GroupsTile({super.key, required this.title, required this.onTap});

  String _getInitials(String text) {
    List<String> words =
        text.isNotEmpty ? text.trim().split(RegExp(' +')) : List.empty();

    return "${words.first[0].capitalize}${words.last[0].capitalize}";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: Values.groupsTilePadding,
        child: Row(
          children: [
            Card(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: SizedBox(
                  width: Values.groupIconSize,
                  height: Values.groupIconSize,
                  child: Center(
                    child: Text(
                      _getInitials(title),
                      style: const TextStyle(fontSize: Values.groupsIconFontSize),
                    ),
                  )),
            ),
            const SizedBox(width: Values.defaultGap),
            Text(title, style: const TextStyle(fontSize: Values.groupListTextSize),)
          ],
        ),
      ),
    );
  }
}
