import 'package:flutter/material.dart';

import 'package:healthmate_personal_health_tracker/core/utils/date_formatter.dart';
import 'package:healthmate_personal_health_tracker/core/constants/app_strings.dart';

class DateFilterField extends StatelessWidget {
  const DateFilterField({
    super.key,
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
