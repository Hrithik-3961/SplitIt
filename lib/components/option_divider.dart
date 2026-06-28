import 'package:flutter/material.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';

class OptionDivider extends StatelessWidget {
  const OptionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: Values.defaultVerticalPadding,
      child: Column(
        children: [
          SizedBox(height: Values.defaultHorizontalGap),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: Values.defaultContentPadding,
                child: Text(Strings.or),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: Values.defaultHorizontalGap),
        ],
      ),
    );
  }
}
