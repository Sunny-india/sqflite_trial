import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  SQLHelper._();
  static Database? _database;
  static Future getDatabase() async {
    if (_database != null) {
      return _database;
    } else {
      return _database = await initDatabase();
    }
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'ecommerce.db');
    return _database =
        await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Customers (
    id INTEGER PRIMARY KEY,
    name TEXT,
    phone TEXT,
    city TEXT
    )
    ''');
    print('Customers table created here');
  }

  static Future addCustomers(Customers customers) async {
    Database db = await getDatabase();
    int added = await db.insert('Customers', customers.toMap());
    if (added > 0) {
      print('Your Customer with ${customers.id} is generated successfully');
      print(await db.query('Customers'));
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCustomers() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query('Customers');
    return List.generate(maps.length, (index) {
      return Customers(
              id: maps[index]['id'],
              name: maps[index]['name'],
              phone: maps[index]['phone'],
              city: maps[index]['city'])
          .toMap();
    });
  }

  static Future updateCustomers(Customers customer) async {
    Database db = await getDatabase();
    await db.update('Customers', customer.toMap(),
        where: 'id = ?', whereArgs: [customer.id]);
  }

  static Future deleteSingleCustomer(int id) async {
    Database database = await getDatabase();
    await database.delete(
      'Customers',
      where: 'id = ?',
      whereArgs: ['id'],
    );
  }
}

class Customers {
  int? id;
  String name, phone, city;
  Customers(
      {this.id, required this.name, required this.city, required this.phone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone, 'city': city};
  }
}
