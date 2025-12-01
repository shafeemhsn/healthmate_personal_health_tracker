import 'package:healthmate_personal_health_tracker/models/health_record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  final String _healthRecordsTableName = 'health_records';

  final String _idColumnName = 'id';
  final String _dateColumnName = 'date';
  final String _stepsColumnName = 'steps';
  final String _caloriesColumnName = 'calories';
  final String _waterColumnName = 'water';
  final String _healthUserIdColumnName = 'userId';

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
        CREATE TABLE IF NOT EXISTS $_healthRecordsTableName (
        $_idColumnName INTEGER PRIMARY KEY,
        $_dateColumnName TEXT NOT NULL,
        $_stepsColumnName INTEGER NOT NULL,
        $_caloriesColumnName INTEGER NOT NULL,
        $_waterColumnName INTEGER NOT NULL,
        $_healthUserIdColumnName INTEGER 
        )
        ''');
  }

  void addHealthRecord(HealthRecord healthRecord) async {
    final db = await database;
    await db.insert(_healthRecordsTableName, {
      _idColumnName: healthRecord.id,
      _dateColumnName: healthRecord.date,
      _stepsColumnName: healthRecord.steps,
      _caloriesColumnName: healthRecord.calories,
      _waterColumnName: healthRecord.water,
      _healthUserIdColumnName: healthRecord.userId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateHealthRecord(HealthRecord healthRecord) async {
    final db = await database;
    await db.update(
      _healthRecordsTableName,
      {
        _dateColumnName: healthRecord.date,
        _stepsColumnName: healthRecord.steps,
        _caloriesColumnName: healthRecord.calories,
        _waterColumnName: healthRecord.water,
        _healthUserIdColumnName: healthRecord.userId,
      },
      where: '$_idColumnName = ?',
      whereArgs: [healthRecord.id],
    );
  }

  Future<List<HealthRecord>> getHealthRecords() async {
    final db = await database;
    final data = await db.query(_healthRecordsTableName);

    return data
        .map(
          (row) => HealthRecord(
            id: row[_idColumnName] as int,
            date: row[_dateColumnName] as String,
            steps: row[_stepsColumnName] as int,
            calories: row[_caloriesColumnName] as int,
            water: row[_waterColumnName] as int,
            userId: row[_healthUserIdColumnName] as int?,
          ),
        )
        .toList();
  }

  Future<void> deleteHealthRecord(int id) async {
    final db = await database;

    await db.delete(
      _healthRecordsTableName,
      where: '$_idColumnName = ?',
      whereArgs: [id],
    );
  }
}
