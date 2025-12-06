import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:healthmate_personal_health_tracker/core/constants/app_strings.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/health_records.dart';

class HealthRecordListView extends ConsumerWidget {
  const HealthRecordListView({
    super.key,
    required this.onRefresh,
    required this.onEditRecord,
    required this.onClearFilter,
  });

  final Future<void> Function() onRefresh;
  final void Function(HealthRecord record) onEditRecord;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recordsState = ref.watch(healthRecordsProvider);
    final filteredState = ref.watch(filteredHealthRecordsProvider);
    final filterValue = ref.watch(healthRecordDateFilterProvider);

    return RefreshIndicator(
      onRefresh: onRefresh,
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
              onClearFilter: filterValue.isEmpty ? null : onClearFilter,
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
                onEdit: () => onEditRecord(record),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
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
                    onPressed: onRefresh,
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
