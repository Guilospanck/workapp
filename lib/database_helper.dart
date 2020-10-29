import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DatabaseHelper {
  static final _databaseName = "logindb.db";
  static final _databaseVersion = 1;

  static final table = 'logintable';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnPass = 'pass';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPass TEXT NOT NULL
          )
          ''');
  }

  insert(String name, String pass) async {
    Database db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnPass: pass
    };
    int insertCount = await db.insert(DatabaseHelper.table, row);

    // int insertCount = await db.rawUpdate('''
    // INSERT INTO ${DatabaseHelper.table}(${DatabaseHelper.columnName}, ${DatabaseHelper.columnPass})
    // VALUES(?, ?)
    // ''', [name, pass]);
    print(await db.query(DatabaseHelper.table));
    return insertCount;
  }

  queryDatabase() async {
    Database db = await DatabaseHelper.instance.database;
    return (await db.query(DatabaseHelper.table));
  }

  verifyUserCredentials(String user, String pass) async {
    Database db = await DatabaseHelper.instance.database;
    var count = await db.query(DatabaseHelper.table,
        where: 'name = ? AND pass = ?', whereArgs: [user, pass]);

    return count;
  }

  deleteEverything() async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawDelete('DELETE FROM ${DatabaseHelper.table}');
  }

  update(int idToUpdate, String newUser, String newPass) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DatabaseHelper.instance.database;

    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: newUser,
      DatabaseHelper.columnPass: newPass
    };

    // We'll update the first row just as an example
    int id = idToUpdate;

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseHelper.table, row,
        where: '${DatabaseHelper.columnId} = ?', whereArgs: [id]);

    return updateCount;
  }
}
