import 'package:healthmate_personal_health_tracker/feature/health_records/data/sources/health_record_dao.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/data/models/health_record.dart';

class HealthRecordRepository {
  final HealthRecordDao dao;

  HealthRecordRepository(this.dao);

  Future<void> addHealthRecord(HealthRecord record) {
    return dao.insert(record);
  }

  Future<void> updateHealthRecord(HealthRecord record) {
    return dao.update(record);
  }

  Future<List<HealthRecord>> getHealthRecords() {
    return dao.getAll();
  }

  Future<void> deleteHealthRecord(int id) {
    return dao.delete(id);
  }
}
