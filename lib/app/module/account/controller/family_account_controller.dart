import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyMemberAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'Family Member Account';
  var includeInNetWorth = false.obs;

  late TextEditingController memberNameController;
  late TextEditingController relationController;
  late TextEditingController initialBalanceController;

  @override
  void onInit() async {
    super.onInit();

    memberNameController = TextEditingController();
    relationController = TextEditingController();
    initialBalanceController = TextEditingController();

  }

}