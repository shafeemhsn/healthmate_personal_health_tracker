import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:healthmate_personal_health_tracker/core/database/app_database.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/data/repository/health_record_repository.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/data/sources/health_record_dao.dart';

import 'package:healthmate_personal_health_tracker/models/health_record.dart';

class HealthRecordsNotifier
    extends StateNotifier<AsyncValue<List<HealthRecord>>> {
  HealthRecordsNotifier(this._repositoryFuture)
    : super(const AsyncValue.loading()) {
    _loadRecords();
  }

  final Future<HealthRecordRepository> _repositoryFuture;
  HealthRecordRepository? _repository;

  Future<HealthRecordRepository> _getRepository() async {
    return _repository ??= await _repositoryFuture;
  }

  Future<void> _loadRecords() async {
    try {
      final repository = await _getRepository();
      final records = await repository.getHealthRecords();
      state = AsyncValue.data(records);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refresh() async {
    await _loadRecords();
  }

  Future<void> addRecord(HealthRecord record) async {
    final repository = await _getRepository();
    await repository.addHealthRecord(record);
    await _loadRecords();
  }

  Future<void> updateRecord(HealthRecord record) async {
    final repository = await _getRepository();
    await repository.updateHealthRecord(record);
    await _loadRecords();
  }

  Future<void> deleteRecord(int id) async {
    final repository = await _getRepository();
    await repository.deleteHealthRecord(id);
    await _loadRecords();
  }
}

final healthRecordsProvider =
    StateNotifierProvider<
      HealthRecordsNotifier,
      AsyncValue<List<HealthRecord>>
    >((ref) {
      final repositoryFuture = AppDatabase.instance.database.then(
        (db) => HealthRecordRepository(HealthRecordDao(db)),
      );

      return HealthRecordsNotifier(repositoryFuture);
    });

/// Stores the current date filter query (as a raw string).
final healthRecordDateFilterProvider = StateProvider<String>((ref) => '');

/// Derived provider that applies the date filter to the list of records.
final filteredHealthRecordsProvider = Provider<AsyncValue<List<HealthRecord>>>((
  ref,
) {
  final records = ref.watch(healthRecordsProvider);
  final query = ref.watch(healthRecordDateFilterProvider).trim().toLowerCase();

  return records.whenData((list) {
    if (query.isEmpty) return list;
    return list
        .where((record) => record.date.toLowerCase().contains(query))
        .toList();
  });
});
