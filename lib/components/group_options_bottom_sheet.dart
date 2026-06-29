import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/base_bottom_sheet.dart';
import 'package:splitit/components/form_button.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/all_groups_controller.dart';

class GroupOptionsBottomSheet extends GetView<AllGroupsController> {
  const GroupOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isInputVisible = RxBool(false);
    return Obx(() {
      isInputVisible.value =
          controller.showCreateInput.value || controller.showJoinInput.value;

      return BaseBottomSheet(
        formKey: controller.groupFormKey,
        showSecondary: isInputVisible,
        primaryTitle: Strings.newGroup,
        secondaryTitle: controller.showCreateInput.value
            ? Strings.createAGroup
            : Strings.joinAGroup,
        primaryChildren: _primaryChildren,
        secondaryChildren: _secondaryChildren,
      );
    });
  }

  List<Widget> get _primaryChildren =>
     [
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
    ];


  List<Widget> get _secondaryChildren =>
     [
      Padding(
        padding: Values.mediumVerticalPadding,
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
      FormButton(
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
    ];


}
