import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../../utils/app_logger.dart'; //

class GeneralSettingRepository {
  final dbHelper = DatabaseHelper();

  /// Save or update a setting
  Future<void> setSetting(String key, String value) async {
    try {
      final db = await dbHelper.database;
      await db.insert(
        'settings',
        {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, stack) {
      appLogger.e('Error setting key: $key', error: e, stackTrace: stack);
    }
  }

  /// Fetch a single setting value by key
  Future<String?> getSetting(String key) async {
    try {
      final db = await dbHelper.database;
      final result =
      await db.query('settings', where: 'key = ?', whereArgs: [key], limit: 1);

      if (result.isNotEmpty) {
        return result.first['value'] as String?;
      }
      return null;
    } catch (e, stack) {
      appLogger.e('Error fetching setting key: $key', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Get all settings as a key-value map
  Future<Map<String, String>> getAllSettings() async {
    try {
      final db = await dbHelper.database;
      final result = await db.query('settings');
      return {
        for (var row in result)
          row['key'] as String: row['value'] as String,
      };
    } catch (e, stack) {
      appLogger.e('Error fetching all settings', error: e, stackTrace: stack);
      return {};
    }
  }

  /// Initialize default settings if they don't exist
  Future<void> initDefaultSettings() async {
    try {
      final existing = await getAllSettings();

      if (!existing.containsKey('currencySymbol')) {
        await setSetting('currencySymbol', '₹');
      }
      if (!existing.containsKey('currency')) {
        await setSetting('currency', 'IND');
      }
      if (!existing.containsKey('dateFormat')) {
        await setSetting('dateFormat', 'dd/MM/yyyy');
      }
      if (!existing.containsKey('decimalPlaces')) {
        await setSetting('decimalPlaces', '2');
      }
      if (!existing.containsKey('firstDay')) {
        await setSetting('firstDay', 'Monday');
      }
      if (!existing.containsKey('language')) {
        await setSetting('language', 'English');
      }
      if (!existing.containsKey('languageDisplay')) {
        await setSetting('languageDisplay', 'English');
      }
      if (!existing.containsKey('themeMode')) {
        await setSetting('themeMode', 'ThemeMode.system');
      }
    } catch (e, stack) {
      appLogger.e('Error initializing default settings', error: e, stackTrace: stack);
    }

    print("Created all settings");
  }

  /// Optional cleanup
  Future<void> dispose() async {
    await dbHelper.close();
  }
}
