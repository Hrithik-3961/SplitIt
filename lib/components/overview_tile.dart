import 'package:flutter/material.dart';
import 'package:splitit/models/user.dart';

class OverviewTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const OverviewTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(user.name),
        trailing: Text(
          "${user.totalAmountOwed > 0 ? "+" : "-"} ${user.totalAmountOwed.abs()}",
          style: TextStyle(
              color: user.totalAmountOwed > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
