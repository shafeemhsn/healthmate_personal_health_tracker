import 'package:flutter/material.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new record')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Date'),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  _dateController.text = pickedDate.toString().split(' ')[0];
                }
              },
            ),

            TextFormField(
              decoration: const InputDecoration(label: Text('Steps Walked')),
              keyboardType: TextInputType.number,
              initialValue: '0',
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null ||
                    int.tryParse(value)! <= 0) {
                  return 'Must be a valid, positive number.';
                }
                return null;
              },
              onSaved: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
