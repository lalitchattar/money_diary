import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/account_model.dart';
import '../service/account_service.dart';
import '../service/cash_account_service.dart';
import 'account_controller.dart';

class CashAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'CASH';
  var includeInNetWorth = RxBool(false);
  var accountName = RxString('');
  var initialBalance = RxDouble(0.0);

  late TextEditingController accountNameController;
  late TextEditingController initialBalanceController;

  final AccountController accountController = Get.find();

  var accountService = AccountService();
  var cashAccountService = CashAccountService();

  @override
  void onInit() async {
    super.onInit();

    accountNameController = TextEditingController();
    initialBalanceController = TextEditingController();

  }

  Future<void> createCashAccount() async {

    String imagePath =
        selectedImage.value?.path ?? 'assets/icons/bank.png';

    Account? account = await cashAccountService.createAccount(
        accountName.value,
        initialBalance.value,
        includeInNetWorth.value,
        type,
        imagePath);

    if (account != null) {
      accountController.refreshAccountList(type, account);
    }
  }

  Future<bool> isNameExists(String accountName, String accountType) async {
    return accountService.isNameExists(accountName, accountType);
  }

}