import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

Map<int, String> scripts = {
  1: ''' CREATE TABLE  lista_leitura (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo_livro TEXT
          );'''
};

class SQLite {
  static Database? db;

  Future<Database> GetDatabase() async {
    if (db == null) {
      return await InitializeDatabase();
    } else {
      return db!;
    }
  }

  Future<Database> InitializeDatabase() async {
    var db = await openDatabase(
        path.join(await getDatabasesPath(), 'database.db'),
        version: scripts.length,
        onCreate: (Database db, int version) async {
          for (var i = 1; i <= scripts.length; i++) {
            await db.execute(scripts[i]!);
            debugPrint(scripts[i]!);
          }
        }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
        debugPrint(scripts[i]!);
      }
    });
    return db;
  }
}