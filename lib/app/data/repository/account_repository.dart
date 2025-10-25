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
    try {
      final db = await dbHelper.database;
      final id = await db.insert('accounts', account.toMap());
      return account.copyWith(id: id);
    } catch (e, stack) {
      appLogger.e(
        'Error creating account: ${account.name}',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
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

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await dbHelper.database;
    return db.insert('accounts', data);
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    final db = await dbHelper.database;
    return db.update('accounts', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> softDelete(int id) async {
    final db = await dbHelper.database;
    return db.update(
      'accounts',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await dbHelper.database;
    return db.query('accounts', where: 'is_deleted = ?', whereArgs: [0]);
  }

  Future<List<Map<String, dynamic>>> getByType(String type) async {
    final db = await dbHelper.database;
    return db.query(
      'accounts',
      where: 'type = ? AND is_deleted = ?',
      whereArgs: [type, 0],
    );
  }

  Future<void> dispose() async {
    await dbHelper.close();
  }
}
