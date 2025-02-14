import 'package:flutter/material.dart';

class MemberTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MemberTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}
