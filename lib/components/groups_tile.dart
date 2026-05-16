import 'package:flutter/material.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/constants/styles.dart';

class GroupsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const GroupsTile({super.key, required this.title, required this.onTap});

  String _getInitials(String text) {
    if (text.isEmpty) return "";
    List<String> words = text.trim().split(RegExp(' +'));
    if (words.length == 1) return words.first[0].toUpperCase();
    return "${words.first[0]}${words.last[0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorIndex = title.hashCode % Colors.primaries.length;
    final avatarColor = Colors.primaries[colorIndex];

    return Card(
      margin: Values.bottomPaddingSmall,
      child: ListTile(
        onTap: onTap,
        contentPadding: Values.defaultPaddingMedium,
        leading: CircleAvatar(
          radius: Values.mediumIconSize,
          backgroundColor: avatarColor.withValues(alpha: 0.1),
          child: Text(
            _getInitials(title),
            style: TextStyle(
              fontSize: Values.mediumTextSize,
              fontWeight: FontWeight.bold,
              color: avatarColor,
            ),
          ),
        ),
        title: Text(
          title,
          style: Styles.titleStyle,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
