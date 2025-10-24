import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditCardAccountController extends GetxController {

  final String type = 'Credit Card Account';
  final currentStep = 0.obs;

  // Step 1
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final creditLimitController = TextEditingController();
  final selectedImage = Rx<File?>(null);

  // Step 2
  final outstandingAmountController = TextEditingController();
  final billGeneration = RxInt(1);
  final billDueDate = RxInt(1);
  //for display
  final billGenerationDateDisplayController = TextEditingController();
  final billDueDateDisplayController = TextEditingController();

  final includeInNetWorth = false.obs;

  // Step 3
  final billReminder = false.obs;
  final cardUtilization = RxDouble(30.0);
  final generateBillReminder = RxBool(false);
  final utilizationAlert = RxBool(false);

  void nextStep() {
    if (currentStep.value < 3) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void saveAccount() {
    Get.snackbar("Success", "Account saved successfully!",
        snackPosition: SnackPosition.BOTTOM);
  }

}