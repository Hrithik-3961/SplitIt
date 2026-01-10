import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/models/user.dart';

class UserTile extends StatelessWidget {
  final User user;
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

    return Obx(
      () => ListTile(
        leading: Checkbox(
          value: isSelected.value,
          onChanged: (value) {
            isSelected.value = value!;
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
          },
        ),
        title: Text(user.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSharesEditable)
              IntrinsicWidth(
                child: TextFormField(
                  controller: shareController,
                  enabled: isSelected.value,
                  focusNode: shareFocusNode,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: Styles.shareOrPercentageInputDecoration,
                ),
              ),
            if (isPercentageEditable)
              IntrinsicWidth(
                child: TextFormField(
                  controller: percentageController,
                  enabled: isSelected.value,
                  focusNode: percentageFocusNode,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: Styles.shareOrPercentageInputDecoration,
                  onChanged: onPercentageChanged,
                ),
              ),
            if (isSharesEditable || isPercentageEditable) const SizedBox(width: 12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
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
              },
              child: AmountTextField(
                textController: amountController,
                enabled: isSelected.value && isAmountManuallyEditable,
                focusNode: amountFocusNode,
              ),
            ),
          ],
        ),
        onTap: () {
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
        },
      ),
    );
  }
}
