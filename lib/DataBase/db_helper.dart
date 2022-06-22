import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import '../model/user_model.dart';

class DbHelper {
  static Database? _db;

  static const String DB_Name = 'appentus.db';
  static const String Table_user = 'user';
  static const int Version = 1;
  static const String D_imageFIle = 'image_file';
  static const String D_UserName = 'user_name';
  static const String D_Email = 'email';
  static const String D_Number = 'number';
  static const String D_Password = 'password';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_user ("
        " $D_imageFIle TEXT, "
        " $D_UserName TEXT, "
        " $D_Email TEXT, "
        " $D_Number TEXT,"
        " $D_Password TEXT, "
        " PRIMARY KEY ($D_Email)"
        ")");
  }

  Future<int?> saveData(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient?.insert(Table_user, user.toMap());
    return res;
  }

  Future<UserModel?> getLoginUser(String emailID, String password) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT * FROM $Table_user WHERE "
        "$D_Email = '$emailID' AND "
        "$D_Password = '$password'");

    if (res!.length > 0) {
      return UserModel.fromMap(res!.first);
    }

    return null;
  }

  Future<int?> updateUser(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient?.update(Table_user, user.toMap(),
        where: '$D_Email = ?', whereArgs: [user.username]);
    return res;
  }

  Future<int> deleteUser(String userName) async {
    var dbClient = await db;
    var res = await dbClient!
        .delete(Table_user, where: '$D_Email = ?', whereArgs: [userName]);
    return res;
  }
}
