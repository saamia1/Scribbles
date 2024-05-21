import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth/auth_service.dart';
import 'package:messaging_app/services/reminder/reminder_service.dart';
import 'package:messaging_app/models/reminder.dart';
import 'package:intl/intl.dart';

class ReminderPage extends StatefulWidget {
  final String userID;

  const ReminderPage({super.key, required this.userID});

  @override
  // ignore: library_private_types_in_public_api
  _ReminderPageState createState() => _ReminderPageState();
}


class _ReminderPageState extends State<ReminderPage> {
  late List<Reminder> reminders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reminders'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: StreamBuilder<List<Reminder>>(
        stream: ReminderService().getReminders(widget.userID),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          reminders = snapshot.data!;
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              var reminder = reminders[index];
              var formattedDate = DateFormat('yyyy-MM-dd – hh:mm a').format(reminder.reminderTime.toDate());

              return ListTile(
                title: Text(reminder.title),
                subtitle: Text(formattedDate),  // Show formatted date
                onTap: () => _showEditReminderDialog(context, reminder, index),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: reminder.isNotificationEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          reminders[index].isNotificationEnabled = value;
                        });
                        ReminderService().toggleReminderNotification(reminder.id, value);
                      },
                    ),
                    IconButton(
                      // ignore: prefer_const_constructors
                      icon: Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, reminder, index),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

void _showAddReminderDialog(BuildContext context) async {
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDate;

  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Add New Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Enter reminder title"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime now = DateTime.now();
                // Show date picker
                selectedDate = await showDatePicker(
                  context: dialogContext,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  TimeOfDay initialTime = const TimeOfDay(hour: 0, minute: 0);
                  // Only restrict time for today's date
                  if (selectedDate!.year == now.year &&
                      selectedDate!.month == now.month &&
                      selectedDate!.day == now.day) {
                    initialTime = TimeOfDay.fromDateTime(now);
                  }
                  // Show time picker
                  final TimeOfDay? selectedTime = await showTimePicker(
                    // ignore: use_build_context_synchronously
                    context: dialogContext,
                    initialTime: initialTime,
                  );
                  if (selectedTime != null) {
                    selectedDate = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                  }
                }
              },
              child: const Text('Select Date and Time'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              if (titleController.text.isNotEmpty && selectedDate != null && selectedDate!.isAfter(DateTime.now())) {
                Reminder newReminder = Reminder(
                  userID: AuthService().getCurrentUser()?.uid ?? '',
                  title: titleController.text,
                  reminderTime: Timestamp.fromDate(selectedDate!),
                  id: '',
                );
                _tryAddReminder(newReminder);
                Navigator.of(dialogContext).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot set a reminder in the past. Please select a future date and time.'))
                );
              }
            },
          ),
        ],
      );
    },
  );
}


void _tryAddReminder(Reminder reminder) async {
    try {
      await ReminderService().addReminder(reminder);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder added successfully!'))
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

void _confirmDelete(BuildContext context, Reminder reminder, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Reminder"),
        content: const Text("Are you sure you want to delete this reminder?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Delete"),
            onPressed: () {
              _deleteReminder(reminder.id, index, context);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _deleteReminder(String reminderId, int index, BuildContext context) async {
  try {
    await FirebaseFirestore.instance.collection('reminders').doc(reminderId).delete();
    if (!mounted) return;
    setState(() {
      reminders.removeAt(index);
    });
    ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
      content: Text('Reminder deleted successfully'),
    ));
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
      content: Text('Error deleting reminder: $e'),
    ));
  }
}

void _showEditReminderDialog(BuildContext context, Reminder reminder, int index) async {
  TextEditingController titleController = TextEditingController(text: reminder.title);
  DateTime selectedDate = reminder.reminderTime.toDate();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Enter reminder title"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime? newDate; // Local variable to hold the potentially new date and time
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    // ignore: use_build_context_synchronously
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(pickedDate),
                  );
                  if (pickedTime != null) {
                    newDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    selectedDate = newDate; // Update the selectedDate only if new values are chosen
                  }
                }
              },
              child: const Text('Select Date and Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save Changes'),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                Reminder updatedReminder = Reminder(
                  id: reminder.id, // keep the original ID
                  userID: reminder.userID, // keep the original user ID
                  title: titleController.text,
                  reminderTime: Timestamp.fromDate(selectedDate),
                  isNotificationEnabled: reminder.isNotificationEnabled, // keep original state
                );
                ReminderService().updateReminder(updatedReminder);
                Navigator.of(context).pop();
                setState(() {
                  reminders[index] = updatedReminder;  // Update the local list to reflect changes
                });
              }
            },
          ),
        ],
      );
    },
  );
}


}