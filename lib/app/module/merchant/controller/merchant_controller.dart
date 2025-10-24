import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/merchant_model.dart';
import 'package:money_diary/app/module/merchant/service/merchant_service.dart';

class MerchantController extends GetxController {
  var merchants = <Merchant>[].obs;
  var name = ''.obs;
  var type = 'Expense'.obs;
  var selectedImage = Rx<File?>(null);
  final RxList<Merchant> filteredMerchants = <Merchant>[].obs;
  final RxString searchQuery = ''.obs;
  var isLoading = false.obs;

  late TextEditingController merchantNameController;

  var merchantService = MerchantService();

  MerchantController({MerchantService? service})
    : merchantService = service ?? MerchantService();

  @override
  void onInit() async {
    super.onInit();

    merchantNameController = TextEditingController();

    // Fetch once
    _fetchLabels();

    // Debounced filter
    ever(searchQuery, (_) => _applyFilter());
    ever(merchants, (_) => _applyFilter());
  }

  Future<void> _fetchLabels() async {
    isLoading.value = true;
    merchants.assignAll(await merchantService.getAllMerchants());
    isLoading.value = false;
  }

  Future<void> createMerchant() async {
    String imagePath =
        selectedImage.value?.path ?? 'assets/images/default_merchant.png';
    Merchant? merchant = await merchantService.createMerchant(
      name.value.trim(),
      type.value,
      imagePath,
    );
    if (merchant != null) {
      merchants.add(merchant);
      reset();
    }
  }

  Future<void> updateMerchant({
    required int id,
    List<String>? fieldsToUpdate,
  }) async {
    Merchant? merchant = await merchantService.getMerchant(id);

    if (merchant != null) {
      String imagePath =
          selectedImage.value?.path ?? 'assets/images/default_merchant.png';

      merchant.name = name.value.trim();
      merchant.type = type.value;
      merchant.icon = imagePath;

      merchantService.updateMerchant(merchant, fieldsToUpdate);

      // Update locally
      final index = merchants.indexWhere((e) => e.id == id);
      if (index != -1) merchants[index] = merchant;
      reset();
    }
  }

  Future<void> deleteMerchant(int id) async {
    await merchantService.deleteMerchant(id);
    merchants.removeWhere((e) => e.id == id);
    reset();
  }

  Future<void> deactivateMerchant(int id) async {
    await merchantService.deactivateMerchant(id);
    final index = merchants.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedMerchant = merchants[index].copyWith(isActive: false);
      merchants[index] = updatedMerchant; // triggers update
    }
    reset();
  }

  Future<void> activateMerchant(int id) async {
    await merchantService.activateMerchant(id);
    final index = merchants.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedMerchant = merchants[index].copyWith(isActive: true);
      merchants[index] = updatedMerchant; // triggers update
    }
    reset();
  }

  Future<bool> isNameExists(String merchantName, String merchantType) async {
    return await merchantService.isNameExists(
      merchantName.trim(),
      merchantType,
    );
  }

  void _applyFilter() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredMerchants.assignAll(merchants);
    } else {
      filteredMerchants.assignAll(
        merchants.where((l) => l.name.toLowerCase().contains(query)),
      );
    }
  }

  void reset() {
    name.value = '';
    type.value = 'Expense';
    selectedImage.value = null;
    merchantNameController.clear();
  }

  @override
  void onClose() {
    merchantNameController.dispose(); // dispose when controller is removed
    super.onClose();
  }
}
