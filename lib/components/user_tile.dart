import 'package:flutter/material.dart';
import 'package:splitit/models/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
    );
  }
}
