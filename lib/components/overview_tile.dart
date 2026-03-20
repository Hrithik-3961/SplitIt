import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/utils/base_util.dart';

class OverviewTile extends StatelessWidget {
  final GroupMembers user;
  final VoidCallback onTap;

  const OverviewTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String prefix = "";
    Color color = Colors.black;
    if (user.balance > 0) {
      prefix = "+";
      color = Colors.green;
    } else if (user.balance < 0) {
      prefix = "-";
      color = Colors.red;
    }

    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(user.name),
        trailing: Text(
          "$prefix ${BaseUtil.getFormattedCurrency(user.balance.abs().toString())}",
          style: Get.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
