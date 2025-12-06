import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:healthmate_personal_health_tracker/core/utils/date_formatter.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/health_records.dart';

class HealthRecordScreen extends ConsumerStatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  ConsumerState<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends ConsumerState<HealthRecordScreen> {
  final TextEditingController _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _refreshRecords() {
    return ref.read(healthRecordsProvider.notifier).refresh();
  }

  Future<void> _pickFilterDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      final formatted = formatStorageDate(picked);
      _applyFilter(formatted);
    }
  }

  void _clearFilter() {
    _applyFilter('');
  }

  void _applyFilter(String value) {
    ref.read(healthRecordDateFilterProvider.notifier).state = value;
  }

  void _syncFilterController(String value) {
    if (_filterController.text == value) return;
    _filterController.value = _filterController.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _onEditRecord(HealthRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditRecordScreen(existingRecord: record),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterValue = ref.watch(healthRecordDateFilterProvider);
    _syncFilterController(filterValue);

    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle(
          title: "Health Record",
          label: "View and manage your history",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DateFilterField(
              controller: _filterController,
              onChanged: _applyFilter,
              onPickDate: _pickFilterDate,
              onClear: _clearFilter,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: HealthRecordListView(
                onRefresh: _refreshRecords,
                onEditRecord: _onEditRecord,
                onClearFilter: _clearFilter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
