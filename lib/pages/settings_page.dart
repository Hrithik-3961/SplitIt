import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/name_form_field.dart';
import 'package:splitit/components/small_icon_button.dart';
import 'package:splitit/components/upgrade_account_card.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  static const String route = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.settings),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: Values.defaultPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight - (Values.defaultPadding.vertical),
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildProfileSection(context),
                    const SizedBox(height: Values.defaultVerticalGap),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: MyColors.error),
                      title: const Text(Strings.logout,
                          style: TextStyle(color: MyColors.error)),
                      onTap: controller.logout,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text(Strings.privacyPolicy),
                      trailing: const Icon(Icons.open_in_new, size: Values.smallIconSize),
                      onTap: controller.openPrivacyPolicy,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.delete_forever_outlined),
                      title: const Text(Strings.dataDeletion),
                      trailing: const Icon(Icons.open_in_new, size: Values.smallIconSize),
                      onTap: controller.openDataDeletion,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.no_accounts_outlined, color: MyColors.error),
                      title: const Text(Strings.deleteAccount,
                          style: TextStyle(color: MyColors.error)),
                      onTap: controller.deleteAccount,
                    ),
                    const Divider(),
                    const Spacer(),
                    Center(
                      child: Padding(
                        padding: Values.defaultPaddingSmall,
                        child: Obx(() => Text(
                              "${Strings.version}: ${controller.version.value}",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: Values.smallTextSize),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildProfileSection(BuildContext context) {
    return [
      const Text(
        Strings.profile,
        style: TextStyle(
          fontSize: Values.mediumTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: Values.defaultHorizontalGap),
      Card(
        child: Padding(
          padding: Values.defaultPaddingMedium,
          child: Column(
            children: [
              _nameRow,
              const Divider(),
              Obx(() => _infoRow),
            ],
          ),
        ),
      ),
      Obx(() {
        if (controller.user.value.isGuest) {
          return const UpgradeAccountCard();
        }
        return const SizedBox.shrink();
      }),
    ];
  }

  Widget get _nameRow {
    return Obx(() {
      final isEditing = controller.isEditingName.value;

      return ListTile(
        leading: const Icon(Icons.person_outline, color: MyColors.hint),
        title: Form(
            key: controller.nameFormKey,
            child: NameFormField(
                controller: controller.nameController,
                inputDecoration: isEditing
                    ? Styles.editableNameInputDecoration
                    : Styles.readOnlyNameInputDecoration,
                readOnly: !isEditing)
            ),
        trailing: isEditing
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmallIconButton(
                    icon: const Icon(Icons.close, color: MyColors.error),
                    onPressed: controller.toggleEditName,
                    tooltip: Strings.cancel,
                  ),
                  const SizedBox(
                    width: Values.defaultHorizontalGap,
                  ),
                  SmallIconButton(
                    icon: const Icon(Icons.check, color: MyColors.success),
                    onPressed: controller.onUpdateName,
                    tooltip: Strings.update,
                  ),
                ],
              )
            : SmallIconButton(
                icon:
                    const Icon(Icons.edit_outlined, size: Values.smallIconSize),
                onPressed: controller.toggleEditName,
                tooltip: Strings.editName,
              ),
      );
    });
  }

  Widget get _infoRow => ListTile(
        leading: const Icon(Icons.phone_outlined, color: MyColors.hint),
        title: const Text(
          Strings.phoneNumber,
          style:
              TextStyle(color: MyColors.hint, fontSize: Values.smallTextSize),
        ),
        subtitle: Text(
          controller.user.value.isGuest
              ? "Guest User"
              : (controller.user.value.phone ?? "N/A"),
          style: const TextStyle(fontSize: Values.defaultTextSize),
        ),
        trailing: const Icon(Icons.lock_outline,
            size: Values.smallIconSize, color: MyColors.hint),
      );
}
