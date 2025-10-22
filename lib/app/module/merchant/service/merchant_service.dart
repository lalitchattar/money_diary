import 'package:money_diary/app/data/model/merchant_model.dart';
import 'package:money_diary/app/data/repository/merchant_repository.dart';

import '../../../utils/app_logger.dart';

class MerchantService {

  var repo = MerchantRepository();

  Future<List<Merchant>> getAllMerchants() async {
    try{
      return await repo.getAllMerchants();
    } catch(e, stack) {
      appLogger.e('Error creating label:', error: e, stackTrace: stack);
      return [];
    }

  }

  Future<Merchant> createMerchant(String name, String type, String icon) async {
    var merchant = Merchant(name: name.trim(), type: type, icon: icon);
    try {
      await repo.createMerchant(merchant);
      return merchant; // Return the merchant so caller can use it
    } catch (e, stack) {
      appLogger.e('Error creating label:', error: e, stackTrace: stack);
      rethrow;
    }
  }


  Future<bool> isNameExists(String merchantName, String merchantType) async {
    final merchant = await repo.getMerchantByName(merchantName.trim(), merchantType);
    return merchant != null;
  }

  Future<void> updateMerchant(Merchant merchant, List<String>? fieldsToUpdate) async {
    try {
      await repo.updateMerchant(merchant, fieldsToUpdate: fieldsToUpdate);
    } catch (e, stack) {
      appLogger.e('Error updating merchant:', error: e, stackTrace: stack);
      rethrow;
    }
  }
}