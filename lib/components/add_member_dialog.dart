import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/name_form_field.dart';
import 'package:splitit/components/option_divider.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/utils/common_validator.dart';

class AddMemberDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String inviteCode;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback onPressed;

  const AddMemberDialog({
    super.key,
    required this.formKey,
    required this.inviteCode,
    required this.nameController,
    required this.phoneController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: AlertDialog(
        title: const Text(Strings.addMember),
        content: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Strings.joinByCodeInfo,
                  style: TextStyle(
                      fontSize: Values.smallTextSize, color: MyColors.hint),
                ),
                const SizedBox(height: Values.defaultHorizontalGap / 2),
                Center(
                  child: SelectableText(
                    inviteCode,
                    style: Styles.codeTextStyle,
                  ),
                ),
                const OptionDivider(),
                const Text(
                  Strings.addByPhoneInfo,
                  style: TextStyle(
                      fontSize: Values.smallTextSize, color: MyColors.hint),
                ),
                const SizedBox(
                  height: Values.defaultVerticalGap,
                ),
                NameFormField(
                    controller: nameController,
                    inputDecoration: Styles.nameInputDecoration(),
                ),
                const SizedBox(
                  height: Values.defaultVerticalGap / 2,
                ),
                TextFormField(
                  controller: phoneController,
                  inputFormatters: Styles.phoneNumberInputFormatters,
                  decoration: Styles.phoneNumberInputDecoration,
                  keyboardType: TextInputType.phone,
                  validator: CommonValidator.validatePhoneNumber,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.clear();
              phoneController.clear();
              Get.back();
            },
            child: const Text(Strings.cancel),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text(Strings.add),
          ),
        ],
      ),
    );
  }
}
