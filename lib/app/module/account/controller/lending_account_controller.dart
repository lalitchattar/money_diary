import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/account_model.dart';
import 'package:money_diary/app/module/account/service/account_service.dart';
import '../service/lending_account_service.dart';
import 'account_controller.dart';

class LendingAccountController extends GetxController {

  var selectedImage = Rx<File?>(null);
  final String type = 'LENDING';
  var includeInNetWorth = RxBool(false);
  var contactName = RxString('');
  var contactNumber = RxString('');
  var contactEmail = RxString('');
  var initialBalance = RxDouble(0.0);

  late TextEditingController contactNameController;
  late TextEditingController contactNumberController;
  late TextEditingController contactEmailController;
  late TextEditingController initialBalanceController;

  final AccountController accountController = Get.find();

  var lendingAccountService = LendingAccountService();
  var accountService = AccountService();

  LendingAccountController({LendingAccountService? service})
      : lendingAccountService = service ?? LendingAccountService();

  @override
  void onInit() async {
    super.onInit();

    contactNameController = TextEditingController();
    contactNumberController = TextEditingController();
    contactEmailController = TextEditingController();
    initialBalanceController = TextEditingController();

  }

  Future<void> createLendingAccount() async {

    String imagePath =
        selectedImage.value?.path ?? 'assets/icons/bank.png';

    Account? account = await lendingAccountService.createAccount(
        contactName.value,
        contactNumber.value,
        contactEmail.value,
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