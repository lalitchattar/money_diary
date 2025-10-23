import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'money_diary.db');
    return await openDatabase(
      path,
      version: 1, // Increment version if adding new table
      onCreate: (db, version) async {
        // Settings table already exists in old version; we create anyway for new installs
        await _createSettingsTable(db);
        await _createLabelTable(db);
        await _createMerchantTable(db);
        await _createCategoryTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
      },
    );
  }

  Future<void> _createSettingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<void> _createLabelTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS labels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL,         
        is_active INTEGER DEFAULT 1,
        is_deleted INTEGER DEFAULT 0,
        transaction_count INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT
      )
    ''');
  }

  Future<void> _createMerchantTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS merchants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL, 
        icon TEXT NOT NULL,        
        is_active INTEGER DEFAULT 1,
        is_deleted INTEGER DEFAULT 0,
        transaction_count INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT
      )
    ''');
  }

  Future<void> _createCategoryTable(Database db) async {

    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      icon TEXT NOT NULL,         
      is_active INTEGER DEFAULT 1,
      is_deleted INTEGER DEFAULT 0,
      transaction_count INTEGER DEFAULT 0,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT
    )
   ''');


    await db.execute('''
      INSERT INTO categories (id, name, type, icon, is_active, is_deleted, transaction_count, created_at, updated_at) VALUES
        (1, 'Beauty', 'Expense', 'assets/icons/beauty.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (2, 'Bills', 'Expense', 'assets/icons/bills.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (3, 'Television', 'Expense', 'assets/icons/television.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (4, 'Electricity', 'Expense', 'assets/icons/electricity.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (5, 'Water', 'Expense', 'assets/icons/water-tap.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (6, 'Books', 'Expense', 'assets/icons/books.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (7, 'Clothes', 'Expense', 'assets/icons/t-shirts.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (8, 'Dining', 'Expense', 'assets/icons/dinner.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (9, 'Donations', 'Expense', 'assets/icons/donation.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (10, 'Education', 'Expense', 'assets/icons/education.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (11, 'Entertainment', 'Expense', 'assets/icons/entertainment.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (12, 'Movie', 'Expense', 'assets/icons/movie.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (13, 'Food & Drink', 'Expense', 'assets/icons/food-and-drink.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (14, 'Fuel', 'Expense', 'assets/icons/fuel.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (15, 'Gas', 'Expense', 'assets/icons/gas.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (16, 'Groceries', 'Expense', 'assets/icons/groceries.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (17, 'Health', 'Expense', 'assets/icons/health.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (18, 'Medicine', 'Expense', 'assets/icons/medicine.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (19, 'Rent', 'Expense', 'assets/icons/rent.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (20, 'Housekeeping', 'Expense', 'assets/icons/housekeeping.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (21, 'Insurance', 'Expense', 'assets/icons/insurance.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (22, 'Jewellery', 'Expense', 'assets/icons/jewellery.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (23, 'Kids', 'Expense', 'assets/icons/kids.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (24, 'Maintenance', 'Expense', 'assets/icons/maintenance.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (25, 'Recharge', 'Expense', 'assets/icons/recharge.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (26, 'Shopping', 'Expense', 'assets/icons/shopping.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (27, 'Electronics', 'Expense', 'assets/icons/electronics.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (28, 'Stationery', 'Expense', 'assets/icons/stationery.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (29, 'Transport', 'Expense', 'assets/icons/transport.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (30, 'Tax', 'Expense', 'assets/icons/tax.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL),
        (31, 'Travel', 'Expense', 'assets/icons/travel.png', 1, 0, 0, CURRENT_TIMESTAMP, NULL);

    ''');
  }


    /// Optional: Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
