import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LendingAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'Lending Account';
  var includeInNetWorth = false.obs;

  late TextEditingController contactNameController;
  late TextEditingController contactNumberController;
  late TextEditingController contactEmailController;
  late TextEditingController initialBalanceController;

  @override
  void onInit() async {
    super.onInit();

    contactNameController = TextEditingController();
    contactNumberController = TextEditingController();
    contactEmailController = TextEditingController();
    initialBalanceController = TextEditingController();

  }

}