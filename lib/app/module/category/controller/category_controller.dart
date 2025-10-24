import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/category_model.dart';
import '../service/category_service.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var filteredCategories = <Category>[].obs;
  var selectedIcon = 'assets/icons/categories.png'.obs;
  var name = ''.obs;
  var type = 'Expense'.obs;

  final icons = <String>[];

  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedType = 'Expense'.obs; // Default type

  late TextEditingController categoryNameController;

  var categoryService = CategoryService();

  CategoryController({CategoryService? service})
      : categoryService = service ?? CategoryService();

  @override
  void onInit() async {
    super.onInit();

    categoryNameController = TextEditingController();

    // Fetch once
    _fetchCategories();

    // Debounced filter
    ever(searchQuery, (_) => applyFilter());
    ever(categories, (_) => applyFilter());

    icons.assignAll(categoryService.icons);

  }


  Future<void> createCategory() async {
    Category? category = await categoryService.createCategory(
      name.value.trim(),
      type.value,
      selectedIcon.value,
    );
    if (category != null) {
      categories.add(category);
      reset();
    }
  }

  Future<void> updateMerchant({
    required int id,
    List<String>? fieldsToUpdate,
  }) async {
    Category? category = await categoryService.getCategory(id);

    if (category != null) {
      category.name = name.value.trim();
      category.type = type.value;
      category.icon = selectedIcon.value;

      categoryService.updateCategory(category, fieldsToUpdate);

      // Update locally
      final index = categories.indexWhere((e) => e.id == id);
      if (index != -1) categories[index] = category;
      reset();
    }
  }


  Future<void> _fetchCategories() async {
    isLoading.value = true;
    categories.assignAll(await categoryService.getAllCategories());
    isLoading.value = false;
  }

  void filterCategories(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilter();
  }

  void applyFilter() {
    final query = searchQuery.value.toLowerCase();
    final selected = selectedType.value;

    // Filter first by type, then by search query
    final filtered = categories.where((category) {
      final matchesType = category.type == selected;
      final matchesQuery = category.name.toLowerCase().contains(query);
      return matchesType && matchesQuery;
    }).toList();

    filteredCategories.assignAll(filtered);
  }


  Future<void> deleteCategory(int id) async {
    await categoryService.deleteCategory(id);
    categories.removeWhere((e) => e.id == id);
    reset();
  }

  Future<void> deactivateMerchant(int id) async {
    await categoryService.deactivateCategory(id);
    final index = categories.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedCategory = categories[index].copyWith(isActive: false);
      categories[index] = updatedCategory; // triggers update
    }
    reset();
  }

  Future<void> activateMerchant(int id) async {
    await categoryService.activateCategory(id);
    final index = categories.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedCategory = categories[index].copyWith(isActive: true);
      categories[index] = updatedCategory; // triggers update
    }
    reset();
  }

  Future<bool> isNameExists(String merchantName, String merchantType) async {
    return await categoryService.isNameExists(
      merchantName.trim(),
      merchantType,
    );
  }

  void reset() {
    name.value = '';
    type.value = 'Expense';
    selectedIcon.value = 'assets/icons/categories.png';
    categoryNameController.clear();
  }

  @override
  void onClose() {
    categoryNameController.dispose(); // dispose when controller is removed
    super.onClose();
  }
}
