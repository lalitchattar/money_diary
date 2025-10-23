import 'package:get/get.dart';
import 'package:money_diary/app/data/model/category_model.dart';
import '../service/category_service.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var filteredCategories = <Category>[].obs;

  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedType = 'Expense'.obs; // Default type

  var categoryService = CategoryService();

  @override
  void onInit() async {
    if (categories.isEmpty) {
      await getAllCategories();
    }
    super.onInit();
  }

  Future<void> getAllCategories() async {
    isLoading.value = true;
    final result = await categoryService.getAllCategories();
    categories.assignAll(result);
    applyFilters();
    isLoading.value = false;
  }

  void filterCategories(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilters();
  }

  void applyFilters() {
    var list = categories.where((cat) {
      final matchesSearch = cat.name.toLowerCase().contains(searchQuery.value);
      final matchesType =
          cat.type.toLowerCase() == selectedType.value.toLowerCase();
      return matchesSearch && matchesType;
    }).toList();
    filteredCategories.assignAll(list);
  }

  void reset() {}
}
