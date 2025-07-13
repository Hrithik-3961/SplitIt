import 'package:flutter/material.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/models/user.dart';
import 'package:get/get.dart';

class UserTile extends StatelessWidget {
  final User user;
  final TextEditingController textController;

  const UserTile(
      {super.key,
      required this.user,
      required this.textController});

  @override
  Widget build(BuildContext context) {
    RxBool selected = true.obs;
    return Obx(
      () => ListTile(
        leading: Checkbox(
          value: selected.value,
          onChanged: (_) {},
        ),
        title: Text(user.name),
        trailing:
            AmountTextField(textController: textController),
        onTap: () {
          selected.value = !selected.value;
        },
      ),
    );
  }
}
