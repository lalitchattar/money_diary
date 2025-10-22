import 'dart:io';

import 'package:get/get.dart';
import 'package:money_diary/app/data/model/merchant_model.dart';
import 'package:money_diary/app/module/merchant/service/merchant_service.dart';

class MerchantController extends GetxController {
  var merchants = <Merchant>[].obs;
  var name = ''.obs;
  var type = 'Expense'.obs;
  var selectedImage = Rx<File?>(null);
  var isLoading = false.obs;

  var merchantService = MerchantService();

  @override
  void onInit() async {
    if(merchants.isEmpty) {
      await getAllMerchants();
    }
    super.onInit();
  }

  Future<void> getAllMerchants() async {
    isLoading.value = true;
    final result = await merchantService.getAllMerchants();
    merchants();
    merchants.assignAll(result);
    isLoading.value = false;
  }

  Future<void> createMerchant() async {
    String imagePath = selectedImage.value?.path ?? 'assets/images/default_merchant.png';
    Merchant merchant = await merchantService.createMerchant(name.value.trim(), type.value, imagePath);
    merchants.add(merchant);
  }

  Future<void> updateLabel({int? id, List<String>? fieldsToUpdate}) async {

    final merchant = Merchant( id: id, name: name.value, type: type.value, icon: selectedImage.value!.path );
    // Update in database
    await merchantService.updateMerchant(merchant, fieldsToUpdate);

    // Find index of the existing label in the list
    final index = merchants.indexWhere((lbl) => lbl.id == merchant.id);
    if (index != -1) {
      // Update the label in memory (this auto-refreshes UI because it's an RxList)
      merchants[index] = merchant;
    } else {
      // (optional) if not found, just add it
      merchants.add(merchant);
    }
  }


  Future<bool> isNameExists(String merchantName, String merchantType) async {
    return await merchantService.isNameExists(merchantName.trim(), merchantType);
  }

  void reset() {
    name.value = '';
    type.value = 'Expense';
    selectedImage.value = null;
  }
}
