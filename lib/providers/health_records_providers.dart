import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:healthmate_personal_health_tracker/models/health_record.dart';
import 'package:healthmate_personal_health_tracker/services/database_service.dart';

class HealthRecordsNotifier
    extends StateNotifier<AsyncValue<List<HealthRecord>>> {
  HealthRecordsNotifier(this._databaseService)
    : super(const AsyncValue.loading()) {
    _loadRecords();
  }

  final DatabaseService _databaseService;

  Future<void> _loadRecords() async {
    try {
      final records = await _databaseService.getHealthRecords();
      state = AsyncValue.data(records);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refresh() async {
    await _loadRecords();
  }

  Future<void> addRecord(HealthRecord record) async {
    await _databaseService.addHealthRecord(record);
    await _loadRecords();
  }

  Future<void> updateRecord(HealthRecord record) async {
    await _databaseService.updateHealthRecord(record);
    await _loadRecords();
  }

  Future<void> deleteRecord(int id) async {
    await _databaseService.deleteHealthRecord(id);
    await _loadRecords();
  }
}

final healthRecordsProvider =
    StateNotifierProvider<
      HealthRecordsNotifier,
      AsyncValue<List<HealthRecord>>
    >((ref) => HealthRecordsNotifier(DatabaseService.instance));

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
