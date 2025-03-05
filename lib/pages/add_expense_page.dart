import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/my_form_field.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/add_expense_controller.dart';

class AddExpensePage extends GetView<AddExpenseController> {
  const AddExpensePage({super.key});

  static const String route = "/addExpense";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.addExpense),
      ),
      body: Padding(
        padding: Values.defaultListPadding,
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...MyFormField.defaultForm(label: Strings.title, hint: Strings.title),
              ...MyFormField.defaultForm(label: Strings.amount, hint: "123"),
            ],
          ),
        ),
      ),
    );
  }
}
