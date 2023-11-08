import 'dart:io';
import 'package:scan_o_matic/data/scan_dto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory databasePath = await getApplicationDocumentsDirectory();
    String path = join(databasePath.path, "scans.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    /* Create databases */
    await db.execute("""CREATE TABLE IF NOT EXISTS scans(
    sid INTEGER PRIMARY KEY AUTOINCREMENT,
    scan TEXT);""");
  }

  Future<List<SavedScan>> getScans() async {
    Database db = await instance.database;
    var scans = await db.query('scans', orderBy: 'sid');
    List<SavedScan> scanList =
        scans.isNotEmpty ? scans.map((c) => SavedScan.fromMap(c)).toList() : [];
    return scanList;
  }

  void deleteScan(int sid) async {
    Database db = await instance.database;
    await db.delete('scans', where: 'sid = $sid');
  }

  void addScan(String scan) async {
    Database db = await instance.database;
    await db.rawInsert("INSERT INTO scans (scan) VALUES ('$scan');");
  }
}
