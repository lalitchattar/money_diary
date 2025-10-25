import 'package:money_diary/app/data/model/account_model.dart';
import 'package:money_diary/app/data/repository/account_repository.dart';

import '../../../utils/app_logger.dart';

class LendingAccountService {

  final repo = AccountRepository();

  Future<Account?> createAccount(
    String contactName,
    String contactNumber,
    String contactEmail,
    double initialBalance,
    bool includeInNetWorth,
    String type,
    String icon,
  ) async {
    var account = Account(name: contactName, initialBalance: initialBalance, currentBalance: initialBalance, type: type, icon: icon, includeInNetWorth: includeInNetWorth);
    try {
      account = await repo.createAccount(account);
      return account;
    } catch (e, stack) {
      appLogger.e('Error creating account:', error: e, stackTrace: stack);
      rethrow;
    }
  }

}
