import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/all_groups_controller.dart';

class GroupOptionsBottomSheet extends StatelessWidget {
  const GroupOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {

    final allGroupsController = Get.find<AllGroupsController>();

    return Container(
      padding: Values.defaultPaddingLarge,
      decoration: Styles.paidByBottomSheetDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            Strings.newGroup,
            style: TextStyle(fontSize: Values.mediumTextSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Values.defaultVerticalGap),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.add)),
            title: const Text(Strings.createAGroup),
            onTap: () => allGroupsController.onGroupOptionClicked(Strings.createAGroup),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.group_add)),
            title: const Text(Strings.joinAGroup),
            onTap: () => allGroupsController.onGroupOptionClicked(Strings.joinAGroup),
          ),
        ],
      ),
    );
  }
}
