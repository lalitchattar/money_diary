import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'Bank Account';
  var includeInNetWorth = false.obs;

  late TextEditingController accountNameController;
  late TextEditingController accountNumberController;
  late TextEditingController initialBalanceController;

  @override
  void onInit() async {
    super.onInit();

    accountNameController = TextEditingController();
    accountNumberController = TextEditingController();
    initialBalanceController = TextEditingController();

  }

}