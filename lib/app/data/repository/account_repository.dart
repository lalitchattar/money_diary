import 'package:money_diary/app/data/model/account_model.dart';

import '../../utils/app_logger.dart';
import '../db/database_helper.dart';

class AccountRepository {
  final dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    final db = await dbHelper.database;
    return db.query('accounts', where: 'is_deleted = ?', whereArgs: [0]);
  }

  Future<Account> createAccount(Account account) async {
    final db = await dbHelper.database;
    
    return db.transaction<Account>((txn) async {
      try {
        final id = await txn.insert('accounts', account.toMap());
        final newAccount = account.copyWith(id: id);

        if (newAccount.type.toUpperCase() == 'LENDING') {
          await txn.insert('lending_details', newAccount.toLendingMap());
        }
        return newAccount;
      } catch (e, stack) {
        appLogger.e(
          'Error creating account: ${account.name}',
          error: e,
          stackTrace: stack,
        );
        rethrow;
      }
    });

  }

  Future<Account?> getAccountByName(String name, String accountType) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'accounts',
        where: 'LOWER(name) = LOWER(?) and type = ? and is_deleted = ?',
        whereArgs: [name, accountType, 0],
        limit: 1,
      );

      if (result.isNotEmpty) {
        switch (accountType) {
          case "CASH":
            return Account.fromBankJson(result.first);
          default:
            return null;
        }
      } else {
        return null;
      }
    } catch (e, stack) {
      appLogger.e(
        'Error activating merchant id: $name',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<void> saveLendingAccountDetails(Account account) async {
    try {
      final db = await dbHelper.database;
      await db.insert('lending_details', account.toLendingMap());
    } catch (e, stack) {
      appLogger.e(
        'Error creating account: ${account.name}',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<void> dispose() async {
    await dbHelper.close();
  }
}
