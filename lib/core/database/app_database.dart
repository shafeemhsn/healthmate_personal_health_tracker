import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:healthmate_personal_health_tracker/core/database/health_record_table.dart';

class AppDatabase {
  static Database? _db;
  static final AppDatabase instance = AppDatabase._constructor();

  AppDatabase._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDataBase();
    return _db!;
  }

  Future<Database> getDataBase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'health_mate_db.db');

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await _createHealthRecordsTable(db);
      },
      onOpen: (db) async {
        await _createHealthRecordsTable(db);
      },
    );
    return database;
  }

  Future<void> _createHealthRecordsTable(Database db) async {
    await db.execute(''' 
        CREATE TABLE IF NOT EXISTS ${HealthRecordTable.name} (
        ${HealthRecordTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${HealthRecordTable.columnDate} TEXT NOT NULL,
        ${HealthRecordTable.columnSteps} INTEGER NOT NULL,
        ${HealthRecordTable.columnCalories} INTEGER NOT NULL,
        ${HealthRecordTable.columnWater} INTEGER NOT NULL,
        ${HealthRecordTable.columnUserId} INTEGER 
        )
        ''');
  }
}
