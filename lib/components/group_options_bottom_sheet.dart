import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/form_button.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/all_groups_controller.dart';

class GroupOptionsBottomSheet extends GetView<AllGroupsController> {
  const GroupOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Styles.paidByBottomSheetDecoration,
      child: Form(
        key: controller.groupFormKey,
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Values.defaultHorizontalGap * 2),
              Text(
                controller.showCreateInput.value
                    ? Strings.createAGroup
                    : (controller.showJoinInput.value
                        ? Strings.joinAGroup
                        : Strings.newGroup),
                style: const TextStyle(
                    fontSize: Values.mediumTextSize,
                    fontWeight: FontWeight.bold),
              ),

              // Default state
              if (!controller.showCreateInput.value &&
                  !controller.showJoinInput.value) ...[
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.add)),
                  title: const Text(Strings.createAGroup),
                  onTap: () => controller.toggleCreateInput(true),
                ),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.group_add)),
                  title: const Text(Strings.joinAGroup),
                  onTap: () => controller.toggleJoinInput(true),
                ),
              ]
              // After clicking an option
              else ...[
                Padding(
                  padding: Values.defaultPadding,
                  child: TextFormField(
                    controller: controller.groupTextController,
                    decoration: Styles.expenseTitleDecoration.copyWith(
                      hintText: controller.showCreateInput.value
                          ? Strings.enterGroupName
                          : Strings.enterGroupCode,
                    ),
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return controller.showCreateInput.value
                            ? Strings.enterGroupName
                            : Strings.enterGroupCode;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: Values.defaultPadding,
                  child: FormButton(
                    onPressed: () {
                      if (controller.showCreateInput.value) {
                        controller.onCreateGroup();
                      } else {
                        controller.onJoinGroup();
                      }
                    },
                    text: controller.showCreateInput.value
                        ? Strings.create
                        : Strings.join,
                  ),
                ),
              ],
              const SizedBox(height: Values.defaultVerticalGap),
            ],
          ),
        ),
      ),
    );
  }
}
