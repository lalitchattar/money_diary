import 'package:money_diary/app/data/model/account_model.dart';
import 'package:money_diary/app/data/repository/account_repository.dart';

import '../../../utils/app_logger.dart';

class BankAccountService {

  final repo = AccountRepository();

  Future<Account?> createAccount(
    String name,
    String accountNumber,
    double initialBalance,
    bool includeInNetWorth,
    String type,
    String icon,
  ) async {
    var account = Account(name: name, accountNumber: accountNumber, initialBalance: initialBalance, currentBalance: initialBalance, type: type, icon: icon, includeInNetWorth: includeInNetWorth);
    try {
      return await repo.createAccount(account);
    } catch (e, stack) {
      appLogger.e('Error creating account:', error: e, stackTrace: stack);
      rethrow;
    }
  }


  Future<bool> isNameExists(String accountName, String accountType) async {
    final merchant = await repo.getAccountByName(accountName.trim(), accountType);
    return merchant != null;
  }
}
