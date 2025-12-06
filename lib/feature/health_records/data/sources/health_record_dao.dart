import 'package:healthmate_personal_health_tracker/models/health_record.dart';
import 'package:healthmate_personal_health_tracker/core/database/health_record_table.dart';
import 'package:sqflite/sqflite.dart';

class HealthRecordDao {
  final Database db;

  HealthRecordDao(this.db);

  Future<void> insert(HealthRecord healthRecord) async {
    await db.insert(HealthRecordTable.name, {
      HealthRecordTable.columnDate: healthRecord.date,
      HealthRecordTable.columnSteps: healthRecord.steps,
      HealthRecordTable.columnCalories: healthRecord.calories,
      HealthRecordTable.columnWater: healthRecord.water,
      HealthRecordTable.columnUserId: healthRecord.userId,
    });
  }

  Future<void> update(HealthRecord healthRecord) async {
    await db.update(
      HealthRecordTable.name,
      {
        HealthRecordTable.columnDate: healthRecord.date,
        HealthRecordTable.columnSteps: healthRecord.steps,
        HealthRecordTable.columnCalories: healthRecord.calories,
        HealthRecordTable.columnWater: healthRecord.water,
        HealthRecordTable.columnUserId: healthRecord.userId,
      },
      where: '${HealthRecordTable.columnId} = ?',
      whereArgs: [healthRecord.id],
    );
  }

  Future<List<HealthRecord>> getAll() async {
    final data = await db.query(HealthRecordTable.name);

    return data
        .map(
          (row) => HealthRecord(
            id: row[HealthRecordTable.columnId] as int,
            date: row[HealthRecordTable.columnDate] as String,
            steps: row[HealthRecordTable.columnSteps] as int,
            calories: row[HealthRecordTable.columnCalories] as int,
            water: row[HealthRecordTable.columnWater] as int,
            userId: row[HealthRecordTable.columnUserId] as int?,
          ),
        )
        .toList();
  }

  Future<void> delete(int id) async {
    await db.delete(
      HealthRecordTable.name,
      where: '${HealthRecordTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
