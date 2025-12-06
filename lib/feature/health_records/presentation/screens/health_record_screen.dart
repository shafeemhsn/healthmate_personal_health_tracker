import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:healthmate_personal_health_tracker/core/constants/app_strings.dart';
import 'package:healthmate_personal_health_tracker/core/utils/date_formatter.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/data/models/health_record.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/presentation/widgets/screen_title.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/presentation/screens/add_edit_record_screen.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/presentation/state/health_records_providers.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/presentation/widgets/record_card.dart';

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
      ref.read(healthRecordDateFilterProvider.notifier).state = formatted;
    }
  }

  void _clearFilter() {
    ref.read(healthRecordDateFilterProvider.notifier).state = '';
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
    final theme = Theme.of(context);
    final recordsState = ref.watch(healthRecordsProvider);
    final filteredState = ref.watch(filteredHealthRecordsProvider);
    final filterValue = ref.watch(healthRecordDateFilterProvider);

    if (_filterController.text != filterValue) {
      _filterController.value = _filterController.value.copyWith(
        text: filterValue,
        selection: TextSelection.collapsed(offset: filterValue.length),
      );
    }

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
            _DateFilter(
              controller: _filterController,
              onChanged: (value) =>
                  ref.read(healthRecordDateFilterProvider.notifier).state =
                      value,
              onPickDate: _pickFilterDate,
              onClear: _clearFilter,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshRecords,
                child: filteredState.when(
                  data: (filtered) {
                    final baseRecords =
                        recordsState.asData?.value ?? const <HealthRecord>[];
                    if (baseRecords.isEmpty) {
                      return const _EmptyState(
                        message: 'No records yet. Add your first entry.',
                      );
                    }

                    if (filtered.isEmpty) {
                      return _EmptyState(
                        message: 'No records match this date filter.',
                        hint: 'Try a different date or clear the filter.',
                        onClearFilter: filterValue.isEmpty
                            ? null
                            : _clearFilter,
                      );
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final record = filtered[index];
                        return RecordCard(
                          record: record,
                          onDelete: record.id != null
                              ? () => ref
                                    .read(healthRecordsProvider.notifier)
                                    .deleteRecord(record.id!)
                              : () {},
                          onEdit: () => _onEditRecord(record),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Unable to load records',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _refreshRecords,
                            child: const Text(AppStrings.retry),
                          ),
                        ],
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateFilter extends StatelessWidget {
  const _DateFilter({
    required this.controller,
    required this.onChanged,
    required this.onPickDate,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onPickDate;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Filter by date',
        hintText: storageDatePattern,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
                tooltip: AppStrings.clearFilter,
              ),
            IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: onPickDate,
              tooltip: 'Pick date',
            ),
          ],
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, this.hint, this.onClearFilter});

  final String message;
  final String? hint;
  final VoidCallback? onClearFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widgets = <Widget>[
      Text(
        message,
        style: theme.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    ];

    if (hint != null) {
      widgets.addAll([
        const SizedBox(height: 6),
        Text(
          hint!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ]);
    }

    if (onClearFilter != null) {
      widgets.addAll([
        const SizedBox(height: 10),
        TextButton(
          onPressed: onClearFilter,
          child: const Text(AppStrings.clearFilter),
        ),
      ]);
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: widgets),
        ),
      ],
    );
  }
}
