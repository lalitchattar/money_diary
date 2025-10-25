import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/account_model.dart';
import 'package:money_diary/app/module/account/service/bank_account_servie.dart';

import 'account_controller.dart';

class BankAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'CASH';
  var includeInNetWorth = RxBool(false);
  var accountName = RxString('');
  var accountNumber = RxString('');
  var initialBalance = RxDouble(0.0);

  late TextEditingController accountNameController;
  late TextEditingController accountNumberController;
  late TextEditingController initialBalanceController;

  final AccountController accountController = Get.find();

  var bankAccountService = BankAccountService();

  BankAccountController({BankAccountService? service})
      : bankAccountService = service ?? BankAccountService();

  @override
  void onInit() async {
    super.onInit();

    accountNameController = TextEditingController();
    accountNumberController = TextEditingController();
    initialBalanceController = TextEditingController();

  }

  Future<void> createBankAccount() async {

    String imagePath =
        selectedImage.value?.path ?? 'assets/icons/bank.png';

    Account? account = await bankAccountService.createAccount(
        accountName.value,
        accountNumber.value,
        initialBalance.value,
        includeInNetWorth.value,
        type,
        imagePath);

    if (account != null) {
      accountController.refreshAccountList(type, account);
    }
  }

  Future<bool> isNameExists(String accountName, String accountType) async {
    return bankAccountService.isNameExists(accountName, accountType);
  }

}