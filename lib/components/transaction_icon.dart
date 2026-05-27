import 'package:flutter/material.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/enums/icon_size.dart';

class TransactionIcon extends StatelessWidget {
  final bool isPayment;
  final IconSize? iconSize;
  const TransactionIcon({super.key, required this.isPayment, this.iconSize = IconSize.small});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: iconSize == IconSize.large ? Values.defaultPadding : Values.defaultPaddingSmall,
      decoration: BoxDecoration(
        color: (isPayment ? MyColors.success : MyColors.info).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPayment ? Icons.payment : Icons.receipt_long,
        color: isPayment ? MyColors.success : MyColors.info,
        size: iconSize == IconSize.large ? Values.largeIconSize : Values.mediumIconSize,
      ),
    );
  }
}
