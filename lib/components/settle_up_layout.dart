import 'package:flutter/material.dart';
import 'package:splitit/components/empty_list_view.dart';
import 'package:splitit/components/settle_up_item.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';

class SettleUpLayout extends StatelessWidget {
  final String title;
  final bool isLoading;
  final bool isEmpty;
  final int itemCount;
  final SettleUpItem Function(BuildContext, int) itemBuilder;

  const SettleUpLayout({
    super.key,
    required this.title,
    this.isLoading = false,
    required this.isEmpty,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isEmpty) {
      return const EmptyListView(
        icon: Icons.check_circle_outline,
        text: Strings.settledUp,
      );
    }

    return ListView.builder(
      padding: Values.defaultPadding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
