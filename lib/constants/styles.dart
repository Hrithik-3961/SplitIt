import 'package:flutter/material.dart';

import 'package:splitit/utils/base_util.dart';

class Styles {

  static get expenseInputDecoration => InputDecoration(
      hintText: BaseUtil.getFormattedCurrency(""), border: InputBorder.none);

  static get shareOrPercentageInputDecoration => const InputDecoration(
    isDense: true,
    border: UnderlineInputBorder(),
  );
}
