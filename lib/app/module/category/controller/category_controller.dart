import 'package:get/get.dart';
import 'package:money_diary/app/data/model/category_model.dart';
import 'package:money_diary/app/data/model/merchant_model.dart';

import '../service/category_service.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var isLoading = false.obs;


  var categoryService = CategoryService();

  @override
  void onInit() async {
    if(categories.isEmpty) {
      await getAllCategories();
    }
    super.onInit();
  }

  Future<void> getAllCategories() async {
    isLoading.value = true;
    final result = await categoryService.getAllCategories();
    categories.assignAll(result);
    isLoading.value = false;
  }

  void reset() {

  }


}
