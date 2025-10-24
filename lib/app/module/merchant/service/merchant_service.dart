import 'package:money_diary/app/data/model/merchant_model.dart';
import 'package:money_diary/app/data/repository/merchant_repository.dart';

import '../../../utils/app_logger.dart';

class MerchantService {

  var repo = MerchantRepository();

  Future<List<Merchant>> getAllMerchants() async {
    try{
      return await repo.getAllMerchants();
    } catch(e, stack) {
      appLogger.e('Error creating merchant:', error: e, stackTrace: stack);
      return [];
    }

  }

  Future<Merchant?> createMerchant(String name, String type, String icon) async {
    var merchant = Merchant(name: name.trim(), type: type, icon: icon);
    try {
     return await repo.createMerchant(merchant);
    } catch (e, stack) {
      appLogger.e('Error creating merchant:', error: e, stackTrace: stack);
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

  Future<Merchant?> getMerchant(int id) async {
    return await repo.getMerchant(id);
  }

  Future<Merchant?> getMerchantByName(String name, String merchantType) async {
    return await repo.getMerchantByName(name, merchantType);
  }

  Future<void> deactivateMerchant(int id) => repo.deactivateMerchant(id);
  Future<void> activateMerchant(int id) => repo.activateMerchants(id);
  Future<void> deleteMerchant(int id) => repo.deleteMerchant(id);
}