import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/group_options_bottom_sheet.dart';
import 'package:splitit/models/groups.dart';
import 'package:splitit/pages/group_overview_page.dart';
import 'package:splitit/pages/cross_group_settle_up_page.dart';
import 'package:splitit/pages/settings_page.dart';
import 'package:splitit/services/all_groups_service.dart';

class AllGroupsController extends GetxController {

  late AllGroupsService _groupsService;
  List<Groups> get groups => _groupsService.groups;
  bool get isLoading => _groupsService.isLoading.value;

  final RxBool showCreateInput = false.obs;
  final RxBool showJoinInput = false.obs;
  final TextEditingController groupTextController = TextEditingController();
  final groupFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _groupsService = Get.put(AllGroupsService());
  }

  @override
  void onClose() {
    groupTextController.dispose();
    super.onClose();
  }

  void onNewGroupOptionsClicked() {
    showCreateInput.value = false;
    showJoinInput.value = false;
    groupTextController.clear();
    Get.bottomSheet(const GroupOptionsBottomSheet());
  }

  void toggleCreateInput(bool value) {
    showCreateInput.value = value;
  }

  void toggleJoinInput(bool value) {
    showJoinInput.value = value;
  }

  void onCreateGroup() async {
    if (groupFormKey.currentState!.validate()) {
      final name = groupTextController.text;
      if (name.isNotEmpty) {
        try {
          await _groupsService.addGroup(name);
          Get.back();
        } catch (e) {
          Get.snackbar("Error", e.toString().replaceAll('Exception: ', ''));
        }
      }
    }
  }

  void onJoinGroup() async {
    if (groupFormKey.currentState!.validate()) {
      final code = groupTextController.text;
      if (code.isNotEmpty) {
        try {
          await _groupsService.joinGroup(code);
          Get.back();
        } catch (e) {
          Get.snackbar("Error", e.toString().replaceAll('Exception: ', ''));
        }
      }
    }
  }

  void navigateToGroupsOverview(String groupId) {
    final group = _groupsService.groups.firstWhere((group) => group.groupId == groupId);
    Get.toNamed("${GroupOverviewPage.route}/$groupId", arguments: group.groupName);
  }

  void navigateToCrossGroupSettleUp() {
    Get.toNamed(CrossGroupSettleUpPage.route);
  }

  void navigateToSettings() {
    Get.toNamed(SettingsPage.route);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllGroupsController());
  }
}
