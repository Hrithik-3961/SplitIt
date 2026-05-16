import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/models/group_members.dart';

class UserTile extends StatelessWidget {
  final GroupMembers user;
  final TextEditingController amountController;
  final TextEditingController shareController;
  final TextEditingController percentageController;
  final FocusNode amountFocusNode;
  final FocusNode shareFocusNode;
  final FocusNode percentageFocusNode;
  final RxBool isSelected;
  final bool isAmountManuallyEditable;
  final bool isSharesEditable;
  final bool isPercentageEditable;
  final Function(String) onPercentageChanged;
  final Function(String) onAmountChanged;

  const UserTile({
    super.key,
    required this.user,
    required this.amountController,
    required this.shareController,
    required this.percentageController,
    required this.amountFocusNode,
    required this.shareFocusNode,
    required this.percentageFocusNode,
    required this.isSelected,
    required this.isAmountManuallyEditable,
    required this.isSharesEditable,
    required this.isPercentageEditable,
    required this.onPercentageChanged,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    void requestFocusAfterBuild(FocusNode focusNode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusNode.context != null) {
          focusNode.requestFocus();
        }
      });
    }

    void handleTap() {
      isSelected.toggle();
      if (isSelected.value) {
        if (isAmountManuallyEditable) {
          requestFocusAfterBuild(amountFocusNode);
        } else if (isSharesEditable) {
          requestFocusAfterBuild(shareFocusNode);
        } else if (isPercentageEditable) {
          requestFocusAfterBuild(percentageFocusNode);
        }
      } else {
        FocusScope.of(context).unfocus();
      }
    }

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: Values.bottomPaddingSmall,
        decoration: BoxDecoration(
          color: isSelected.value 
              ? Get.theme.primaryColor.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Values.borderRadius),
          border: Border.all(
            color: isSelected.value 
                ? Get.theme.primaryColor.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
          ),
        ),
        child: ListTile(
          onTap: handleTap,
          contentPadding: Values.defaultContentPadding,
          leading: Checkbox(
            visualDensity: VisualDensity.compact,
            value: isSelected.value,
            onChanged: (value) => handleTap(),
          ),
          title: Text(
            user.name,
            style: TextStyle(
              fontWeight: isSelected.value ? FontWeight.bold : FontWeight.normal,
              color: isSelected.value ? Get.theme.primaryColor : Get.theme.colorScheme.onSurface,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSharesEditable)
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: shareController,
                    enabled: isSelected.value,
                    focusNode: shareFocusNode,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: Styles.sharesInputFormatters,
                    decoration: Styles.shareInputDecoration,
                  ),
                ),
              if (isPercentageEditable)
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: percentageController,
                    enabled: isSelected.value,
                    focusNode: percentageFocusNode,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: Styles.percentageInputFormatters,
                    decoration: Styles.percentageInputDecoration,
                    onChanged: onPercentageChanged,
                  ),
                ),
              if (isSharesEditable || isPercentageEditable) 
                const SizedBox(width: Values.defaultHorizontalGap),
              AmountTextField(
                textController: amountController,
                enabled: isSelected.value && isAmountManuallyEditable,
                focusNode: amountFocusNode,
                onChanged: onAmountChanged,
                fullWidth: false,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected.value ? MyColors.success : MyColors.hint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
