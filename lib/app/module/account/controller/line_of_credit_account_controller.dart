import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineOfCreditAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'Line of Credit Account';
  var includeInNetWorth = false.obs;

  late TextEditingController accountNameController;
  late TextEditingController accountNumberController;
  late TextEditingController startingDueAmountController;
  late TextEditingController creditLimitController;

  @override
  void onInit() async {
    super.onInit();

    accountNameController = TextEditingController();
    accountNumberController = TextEditingController();
    startingDueAmountController = TextEditingController();
    creditLimitController = TextEditingController();

  }

}