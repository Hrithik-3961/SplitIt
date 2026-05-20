import 'package:flutter/material.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/models/suggested_payment.dart';
import 'package:splitit/utils/base_util.dart';

class SettleUpItem extends StatelessWidget {
  final SuggestedPayment suggestion;
  final VoidCallback onSettle;
  final List<Widget>? children;

  const SettleUpItem({
    super.key,
    required this.suggestion,
    required this.onSettle,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = Row(
      children: [
        Expanded(
          child: Text(
            suggestion.fromName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Icon(Icons.arrow_forward, size: Values.smallIconSize),
        const SizedBox(width: Values.defaultHorizontalGap),
        Expanded(
          child: Text(
            suggestion.toName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    final subtitle = Text(
      BaseUtil.getFormattedCurrency(suggestion.amount.toStringAsFixed(2)),
      style: const TextStyle(
        fontSize: Values.defaultTextSize,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );

    if (children != null) {
      return Card(
        margin: Values.bottomPaddingSmall,
        child: ExpansionTile(
          title: title,
          subtitle: subtitle,
          children: [
            ...children!,
            Padding(
              padding: Values.defaultPadding,
              child: ElevatedButton(
                onPressed: onSettle,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text(Strings.settleUp),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: Values.bottomPaddingSmall,
      child: ListTile(
        title: title,
        subtitle: subtitle,
        trailing: ElevatedButton(
          onPressed: onSettle,
          child: const Text(Strings.settleUp),
        ),
      ),
    );
  }
}
