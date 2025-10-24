import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'Cash Account';
  var includeInNetWorth = false.obs;

  late TextEditingController accountNameController;
  late TextEditingController initialBalanceController;

  @override
  void onInit() async {
    super.onInit();

    accountNameController = TextEditingController();
    initialBalanceController = TextEditingController();

  }

}