import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/account_model.dart';
import 'package:money_diary/app/module/account/service/account_service.dart';

import '../service/wallet_account_service.dart';
import 'account_controller.dart';

class WalletAccountController extends GetxController {

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

  var walletAccountService = WalletAccountService();
  var accountService = AccountService();

  WalletAccountController({WalletAccountService? service})
      : walletAccountService = service ?? WalletAccountService();

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

    Account? account = await walletAccountService.createAccount(
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
    return accountService.isNameExists(accountName, accountType);
  }

}