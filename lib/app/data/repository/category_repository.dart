

import '../../utils/app_logger.dart';
import '../db/database_helper.dart';
import '../model/category_model.dart';
import '../model/merchant_model.dart';

class CategoryRepository {
  final dbHelper = DatabaseHelper();

  Future<Merchant> createMerchant(Merchant merchant) async {
    try {
      final db = await dbHelper.database;
      await db.insert('merchants', merchant.toMap());
      return merchant; // Return the merchant after inserting
    } catch (e, stack) {
      appLogger.e('Error creating merchant: ${merchant.name}', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> updateMerchant(Merchant merchant, {List<String>? fieldsToUpdate}) async {
    try {
      final db = await dbHelper.database;

      // Convert entire model to map
      final fullMap = merchant.toMap();

      // If specific fields provided → filter only those
      final updateMap = fieldsToUpdate != null && fieldsToUpdate.isNotEmpty
          ? Map.fromEntries(
        fullMap.entries.where((e) => fieldsToUpdate.contains(e.key)),
      )
          : fullMap; // else, update all fields
      await db.update(
        'merchants',
        updateMap,
        where: 'id = ?',
        whereArgs: [merchant.id],
      );
    } catch (e, stack) {
      appLogger.e(
        'Error updating merchant id: ${merchant.id}',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query('categories', where: 'is_deleted = ?', whereArgs: [0]);
      return maps.map((map) => Category.fromMap(map)).toList();
    } catch (e, stack) {
      appLogger.e('Error fetching all category', error: e, stackTrace: stack);
      return [];
    }
  }

  Future<Merchant?> getMerchantById(int id) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'merchants',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return Merchant.fromMap(result.first);
      } else {
        return null;
      }
    } catch (e, stack) {
      appLogger.e('Error activating merchant id: $id', error: e, stackTrace: stack);
      return null;
    }
  }

  Future<Merchant?> getMerchantByName(String name, String merchantType) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'merchants',
        where: 'name = ? and type = ? and is_deleted = ?',
        whereArgs: [name, merchantType, 0],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return Merchant.fromMap(result.first);
      } else {
        return null;
      }
    } catch (e, stack) {
      appLogger.e('Error activating merchant id: $name', error: e, stackTrace: stack);
      return null;
    }
  }

  Future<int> deleteMerchant(int id) async {
    try {
      final db = await dbHelper.database;
      return await db.update(
        'merchants',
        {'is_deleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, stack) {
      appLogger.e('Error activating merchant id: $id', error: e, stackTrace: stack);
      return 0;
    }
  }

  Future<int> deactivateMerchant(int id) async {
    try {
      final db = await dbHelper.database;
      return await db.update(
        'merchants',
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, stack) {
      appLogger.e('Error deactivating merchant id: $id', error: e, stackTrace: stack);
      return 0;
    }
  }

  Future<int> activateMerchants(int id) async {
    try {
      final db = await dbHelper.database;
      return await db.update(
        'merchants',
        {'is_active': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, stack) {
      appLogger.e('Error activating merchant id: $id', error: e, stackTrace: stack);
      return 0;
    }
  }

  Future<void> dispose() async {
    await dbHelper.close();
  }
}
