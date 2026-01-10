import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
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

    return InkWell(
      onTap: handleTap,
      child: Padding(
        padding: Values.userTilePadding,
        child: Obx(
          () => Row(
            children: [
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: isSelected.value,
                onChanged: (value) => handleTap(),
              ),
              Expanded(
                flex: 50,
                child: Text(user.name, overflow: TextOverflow.ellipsis),
              ),
              const Spacer(),
              if (isSharesEditable)
                SizedBox(
                  width: 50,
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
                SizedBox(
                  width: 70,
                  child: TextFormField(
                    controller: percentageController,
                    enabled: isSelected.value,
                    focusNode: percentageFocusNode,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: Styles.shareOrPercentageInputDecoration.copyWith(
                      suffixText: '%',
                    ),
                    onChanged: onPercentageChanged,
                  ),
                ),

              if (isSharesEditable || isPercentageEditable) const SizedBox(width: Values.defaultGap),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: handleTap,
                child: AmountTextField(
                  textController: amountController,
                  enabled: isSelected.value && isAmountManuallyEditable,
                  focusNode: amountFocusNode,
                  onChanged: onAmountChanged,
                  fullWidth: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
