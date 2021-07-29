import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteUtil {

  static int version = 1;

  static final sqliteContext = SqliteUtil();

  static SqliteUtil getInstance() {
    return sqliteContext;
  }

  createDb(String sql, String dbName) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    await openDatabase(path, version: version,
        onCreate: (Database db, int version) async {
      await db.execute(sql);
      print('create success');
      await db.close();
    });
  }

  deleteDb(String dbName) async {
    String path = await _getDbPath(dbName);
    await deleteDatabase(path);
    print('delete db');
  }


  _getDbPath(String dbName) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    print(path);
    return path;
  }

  Future<Database> openDb(String dbName) async {
    var path = await _getDbPath(dbName);
    Database db = await openDatabase(path);
    print('open');
    return db;
  }

  insert(String dbName, String sql, List arg) async {
    Database db = await openDb(dbName);
    var response = await db.transaction<int>((txn) async {
      int count = await txn.rawInsert(sql, arg);
      print(count);
      return count;
    });
    await db.close();
    print('insert');
    return response;
  }

  delete(String dbName, String sql, List arg) async {
    Database db = await openDb(dbName);
    int count = await db.rawDelete(sql, arg);
    await db.close();
    print('delete');
    print(count);
    return count;
  }

  Future update(String dbName, String sql, List arg) async {
    Database db = await openDb(dbName);
    int count = await db.rawUpdate(sql, arg);
    await db.close();
    print('update');
    print(count);
    return count;
  }

  query(String dbName, String sql) async {
    Database db = await openDb(dbName);
    List<Map> list = await db.rawQuery(sql);
    print('query');
    print(list);
    await db.close();
    return list;
  }


}