import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:healthmate_personal_health_tracker/core/constants/app_strings.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/health_records.dart';

class AddEditRecordScreen extends ConsumerStatefulWidget {
  const AddEditRecordScreen({super.key, this.existingRecord});

  final HealthRecord? existingRecord;

  @override
  ConsumerState<AddEditRecordScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEditRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  var _selectedDate = '';
  late int _enteredSteps;
  late int _enteredCalories;
  late int _enteredWater;

  @override
  void initState() {
    super.initState();
    final record = widget.existingRecord;
    if (record != null) {
      _selectedDate = record.date;
      _dateController.text = record.date;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isEditing = widget.existingRecord != null;
      final newItem = HealthRecord(
        id: widget.existingRecord?.id,
        date: _selectedDate,
        steps: _enteredSteps,
        calories: _enteredCalories,
        water: _enteredWater,
        userId: widget.existingRecord?.userId,
      );

      final navigator = Navigator.of(context);

      if (isEditing) {
        await ref.read(healthRecordsProvider.notifier).updateRecord(newItem);
      } else {
        await ref.read(healthRecordsProvider.notifier).addRecord(newItem);
      }

      navigator.pop();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      if (!mounted) return;
      setState(() {
        _selectedDate = formattedDate;
        _dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.existingRecord != null;

    return Scaffold(
      appBar: AppBar(
        title: ScreenTitle(
          title: isEditing ? "Edit Health Entry" : "Add Health Entry",
          label: isEditing
              ? "Update your daily activities"
              : "Record your daily activities",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? "Edit Your Health Record" : "Add Your Health Record",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // DATE FIELD
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (_selectedDate.isEmpty ||
                            _selectedDate.trim().length <= 1 ||
                            _selectedDate.trim().length > 50) {
                          return 'Please select a date.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedDate = _dateController.text;
                      },
                    ),
                    const SizedBox(height: 16),

                    // STEPS
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue:
                          widget.existingRecord?.steps.toString() ?? '',
                      decoration: InputDecoration(
                        labelText: "Steps Walked",
                        hintText: "e.g., 10000",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return AppStrings.validationPositiveNumber;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredSteps = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),

                    // CALORIES
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue:
                          widget.existingRecord?.calories.toString() ?? '',
                      decoration: InputDecoration(
                        labelText:
                            "Calories Burned (${AppStrings.caloriesUnit})",
                        hintText: AppStrings.exampleValue2000,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return AppStrings.validationPositiveNumber;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredCalories = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),

                    // WATER
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue:
                          widget.existingRecord?.water.toString() ?? '',
                      decoration: InputDecoration(
                        labelText:
                            "Water Intake (${AppStrings.waterUnit})",
                        hintText: AppStrings.exampleValue2000,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return AppStrings.validationPositiveNumber;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredWater = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),

                    // BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: colorScheme.primary,
                            ),
                            onPressed: _saveItem,
                            child: Text(
                              isEditing ? "Save Changes" : "Add Record",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
