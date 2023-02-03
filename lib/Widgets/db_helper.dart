import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  String? _userId = '';
  SharedPreferences? prefs;
  Database? db;

  static String databaseName = "pharam_trax_scanner.db";
  static int databaseVersion = 2;

  // Table #1 name "products" has list of all items
  static String table1 = "products";

  static String table1ColumnId = "id";
  static String table1ColumnPlain1 = "plain1";
  static String table1ColumnCline3 = "cline3";
  static String table1ColumnSline4 = "sline4";
  static String table1ColumnVersion = "version";
  static String table1ColumnIsModified = "is_modified";

  // Table #2 name "scanned_products" has list of all items
  static String table2 = "scanned_products";

  static String table2ColumnUserId = "userId";
  static String table2ColumnId = "id";
  static String table2ColumnBarcodeType = "barcode_type";
  static String table2ColumnDate = "date";

  static Database? _database;

  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentdirectory.path, databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table1 (
        $table1ColumnId TEXT PRIMARY KEY,
        $table1ColumnPlain1 TEXT NOT NULL,
        $table1ColumnCline3 TEXT NOT NULL,
        $table1ColumnSline4 TEXT,
        $table1ColumnVersion TEXT NOT NULL,
        $table1ColumnIsModified TEXT NOT NULL
      )''');
    await db.execute('''
      CREATE TABLE $table2 (
        $table2ColumnUserId TEXT NOT NULL,
       $table2ColumnId TEXT NOT NULL,
        $table2ColumnBarcodeType TEXT NOT NULL,
        $table2ColumnDate TEXT NOT NULL
      )''');
  }

  // Functiuons to perform some functionality with database table #1 name "products"

  Future<int?> insertTable1(Map<String, dynamic> row) async {
    db = await instance.database;
    // if (db !=null) {

    //   // _check = false;
    // }
    return await db!.insert(table1, row);
  }

  Future<int?> updateTable1(Map<String, dynamic> row) async {
    bool _checkValue = false;
    db = await instance.database;
    List<Map<String, dynamic>> check = await fatchTable1();
    for (int i = 0; i < check.length; i++) {
      if (check[i]['${table1ColumnId}'] == row["${table1ColumnId}"]) {
        _checkValue = true;
        print("---------------------");
        print("Find the Record.");
        print("---------------------");
      }
    }
    if (_checkValue) {
      insertTable1(row);
      print("---------------------");
      print("Update the Record.");
      print("---------------------");
      return await db!.update(
          table1,
          {
            '${table1ColumnPlain1}': '${row["${table1ColumnPlain1}"]}',
            '${table1ColumnCline3}': '${row["${table1ColumnCline3}"]}',
            '${table1ColumnSline4}': '${row["${table1ColumnSline4}"]}',
            '${table1ColumnVersion}': '${row["${table1ColumnVersion}"]}',
            '${table1ColumnIsModified}': '${row["${table1ColumnIsModified}"]}'
          },
          where: '${table1ColumnId} = ?',
          whereArgs: ['${row["${table1ColumnId}"]}']);
    } else {
      print("---------------------");
      print("Added the Record.");
      print("---------------------");
      return insertTable1(row);
    }
  }

  Future<List<Map<String, dynamic>>> fatchTable1() async {
    db = await instance.database;
    return await db!.query(table1);
  }

  Future<void> deleteTable1() async {
    db = await instance.database;
    await db!.delete(table1);
  }

  // Functiuons to perform some functionality with database table #2 name "scanned_products"
  Future<int?> insertTable2(Map<String, dynamic> row) async {
    db = await instance.database;
    return await db!.insert(table2, row);
  }

  Future<List<Map<String, dynamic>>> fatchTable2() async {
    prefs = await SharedPreferences.getInstance();
    _userId = prefs!.getString("email").toString();
    db = await instance.database;

    return await db!.query(table2,
        where: '${table2ColumnUserId} = ?', whereArgs: ['${_userId}']);
  }

  Future<void> deleteTable2() async {
    prefs = await SharedPreferences.getInstance();
    _userId = prefs!.getString("email").toString();
    db = await instance.database;

    await db!.delete(table2,
        where: '${table2ColumnUserId} = ?', whereArgs: ['${_userId}']);
  }

  // Other Functiuons
}
