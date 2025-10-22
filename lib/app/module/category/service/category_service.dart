
import 'package:money_diary/app/data/repository/category_repository.dart';

import '../../../data/model/category_model.dart';
import '../../../utils/app_logger.dart';

class CategoryService {

  var repo = CategoryRepository();

  Future<List<Category>> getAllCategories() async {
    try{
      return await repo.getAllCategories();
    } catch(e, stack) {
      appLogger.e('Error creating label:', error: e, stackTrace: stack);
      return [];
    }

  }


}