import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/utils/base_util.dart';

class OverviewTile extends StatelessWidget {
  final GroupMembers user;
  final VoidCallback onTap;

  const OverviewTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color balanceColor = MyColors.hint;
    String balanceText = BaseUtil.getFormattedCurrency(user.balance.abs().toString());
    IconData balanceIcon = Icons.remove;

    if (user.balance > 0) {
      balanceColor = MyColors.success;
      balanceText = "+ $balanceText";
      balanceIcon = Icons.arrow_upward;
    } else if (user.balance < 0) {
      balanceColor = MyColors.error;
      balanceText = "- $balanceText";
      balanceIcon = Icons.arrow_downward;
    }

    return Card(
      margin: Values.defaultMarginSmall,
      elevation: 0,
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: Values.defaultContentPadding,
        leading: CircleAvatar(
          backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            user.name[0].toUpperCase(),
            style: TextStyle(color: Get.theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.name,
          style: Styles.titleStyle,
        ),
        subtitle: Text(
          user.balance == 0 ? Strings.settledUp : (user.balance > 0 ? Strings.lentMoney : Strings.borrowedMoney),
          style: Styles.subtitleStyle,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              balanceText,
              style: TextStyle(
                color: balanceColor,
                fontWeight: FontWeight.bold,
                fontSize: Values.defaultTextSize,
              ),
            ),
            if (user.balance != 0)
              Icon(balanceIcon, size: Values.extraSmallIconSize, color: balanceColor),
          ],
        ),
      ),
    );
  }
}
