import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/models/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  final TextEditingController textController;
  final FocusNode focusNode;
  final RxBool isSelected;

  const UserTile({
    super.key,
    required this.user,
    required this.textController,
    required this.focusNode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    void requestFocusAfterBuild() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusNode.context != null) {
          focusNode.requestFocus();
        }
      });
    }

    return Obx(
      () => ListTile(
        leading: Checkbox(
          value: isSelected.value,
          onChanged: (value) {
            isSelected.value = value!;
            if (isSelected.value) {
              requestFocusAfterBuild();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
        title: Text(user.name),
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!isSelected.value) {
              isSelected.value = true;
              requestFocusAfterBuild();
            } else {
              focusNode.requestFocus();
            }
          },
          child: AmountTextField(
            textController: textController,
            enabled: isSelected.value,
            focusNode: focusNode,
          ),
        ),
        onTap: () {
          isSelected.toggle();
          if (isSelected.value) {
            requestFocusAfterBuild();
          } else {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
