
import 'package:money_diary/app/data/repository/category_repository.dart';

import '../../../data/model/category_model.dart';
import '../../../utils/app_logger.dart';

class CategoryService {

  var repo = CategoryRepository();

  Future<List<Category>> getAllCategories() async {
    try{
      return await repo.getAllCategories();
    } catch(e, stack) {
      appLogger.e('Error creating category:', error: e, stackTrace: stack);
      return [];
    }

  }

  Future<Category?> createCategory(String name, String type, String icon) async {
    var category = Category(name: name.trim(), type: type, icon: icon);
    try {
      return await repo.createCategory(category);
    } catch (e, stack) {
      appLogger.e('Error creating category:', error: e, stackTrace: stack);
      rethrow;
    }
  }


  Future<bool> isNameExists(String categoryName, String categoryType) async {
    final category = await repo.getCategoryByName(categoryName.trim(), categoryType);
    return category != null;
  }

  Future<void> updateCategory(Category category, List<String>? fieldsToUpdate) async {
    try {
      await repo.updateCategory(category, fieldsToUpdate: fieldsToUpdate);
    } catch (e, stack) {
      appLogger.e('Error updating category:', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<Category?> getCategory(int id) async {
    return await repo.getCategory(id);
  }

  Future<Category?> getCategoryByName(String name, String categoryType) async {
    return await repo.getCategoryByName(name, categoryType);
  }

  Future<void> deactivateCategory(int id) => repo.deactivateCategory(id);
  Future<void> activateCategory(int id) => repo.activateCategory(id);
  Future<void> deleteCategory(int id) => repo.deleteCategory(id);


}