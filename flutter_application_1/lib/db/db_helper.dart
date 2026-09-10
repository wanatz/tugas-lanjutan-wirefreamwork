import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_cart.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE master_products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE local_cart (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (product_id) REFERENCES master_products (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertProduct(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(
      'master_products',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('master_products', orderBy: 'name ASC');
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('master_products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCart(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(
      'local_cart',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('local_cart');
  }

  Future<int> updateCartQuantity(String id, int quantity) async {
    final db = await database;
    return await db.update(
      'local_cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(String id) async {
    final db = await database;
    return await db.delete('local_cart', where: 'id = ?', whereArgs: [id]);
  }
}