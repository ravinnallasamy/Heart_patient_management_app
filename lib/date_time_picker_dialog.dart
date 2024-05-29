import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationReminder {
  final DateTime date;
  final TimeOfDay time;
  final String medicationName;

  MedicationReminder({required this.date, required this.time, required this.medicationName});
}

class DateTimePickerDialog extends StatefulWidget {
  @override
  _DateTimePickerDialogState createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<DateTimePickerDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  List<TimeOfDay> _times = [];
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int? index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (index == null) {
          _times.add(picked);
        } else {
          _times[index] = picked;
        }
      });
    }
  }

  void _addTime() {
    _selectTime(context, null);
  }

  void _removeTime(int index) {
    setState(() {
      _times.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth > 600 ? 24.0 : 12.0;
    double titleFontSize = screenWidth > 600 ? 24.0 : 18.0;
    double contentFontSize = screenWidth > 600 ? 18.0 : 14.0;

    return AlertDialog(
      title: Text(
        'Select Dates and Times',
        style: TextStyle(fontSize: titleFontSize),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: ListBody(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Start Date: ${_dateFormat.format(_startDate)}",
                  style: TextStyle(fontSize: contentFontSize),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text(
                  "End Date: ${_dateFormat.format(_endDate)}",
                  style: TextStyle(fontSize: contentFontSize),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              ..._times.asMap().entries.map((entry) {
                int index = entry.key;
                TimeOfDay time = entry.value;
                return ListTile(
                  title: Text(
                    "Time ${index + 1}: ${time.format(context)}",
                    style: TextStyle(fontSize: contentFontSize),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () => _selectTime(context, index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeTime(index),
                      ),
                    ],
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: _addTime,
                child: Text('Add Time', style: TextStyle(fontSize: contentFontSize)),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel', style: TextStyle(fontSize: contentFontSize)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK', style: TextStyle(fontSize: contentFontSize)),
          onPressed: () {
            final reminders = _generateReminders();
            Navigator.of(context).pop(reminders);
          },
        ),
      ],
    );
  }

  List<MedicationReminder> _generateReminders() {
    List<MedicationReminder> reminders = [];
    for (DateTime date = _startDate;
    date.isBefore(_endDate.add(Duration(days: 1)));
    date = date.add(Duration(days: 1))) {
      for (TimeOfDay time in _times) {
        reminders.add(MedicationReminder(date: date, time: time, medicationName: 'Medication'));
      }
    }
    return reminders;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('DateTime Picker Dialog')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            List<MedicationReminder>? reminders = await showDialog<List<MedicationReminder>>(
              context: context,
              builder: (BuildContext context) => DateTimePickerDialog(),
            );
            if (reminders != null) {
              for (var reminder in reminders) {
                print('Reminder: ${reminder.medicationName} at ${reminder.date} ${reminder.time.format(context)}');
              }
            }
          },
          child: Text('Open DateTime Picker'),
        ),
      ),
    ),
  ));
}
