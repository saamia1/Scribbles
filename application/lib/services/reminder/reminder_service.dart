import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/models/reminder.dart';
import 'package:messaging_app/services/notification/notification_service.dart';

class ReminderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Reminder>> getReminders(String userID) {
    return _db.collection('reminders')
      .where('userID', isEqualTo: userID)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => 
        Reminder.fromJson(doc.data(), doc.id)  // Ensuring correct usage of fromJson
      ).toList());
  }

  Future<void> addReminder(Reminder reminder) async {
    // Check for duplicate reminder
    final QuerySnapshot existingReminders = await _db.collection('reminders')
      .where('userID', isEqualTo: reminder.userID)
      .where('title', isEqualTo: reminder.title)
      .where('reminderTime', isEqualTo: reminder.reminderTime)
      .get();

    if (existingReminders.docs.isNotEmpty) {
      throw Exception("You are creating a duplicate reminder.");
    } else {
      // Add new reminder if no duplicates are found
      DocumentReference docRef = await _db.collection('reminders').add(reminder.toMap());
      reminder.id = docRef.id; // Ensure the ID is set after creation
      await NotificationService().scheduleNotification(reminder);
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _db.collection('reminders').doc(reminder.id).update(reminder.toMap());
    // Optionally re-schedule the notification if necessary
    if (reminder.isNotificationEnabled) {
      await NotificationService().scheduleNotification(reminder);
    }
  }

  Future<void> toggleReminderNotification(String reminderId, bool isEnabled) async {
    var notificationId = reminderId.hashCode;
    await _db.collection('reminders').doc(reminderId).update({
      'isNotificationEnabled': isEnabled
    });
    if (isEnabled) {
      DocumentSnapshot snapshot = await _db.collection('reminders').doc(reminderId).get();
      if (snapshot.exists) {
        Reminder reminder = Reminder.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
        await NotificationService().scheduleNotification(reminder);
      }
    } else {
      // Adjusting cancellation to use a string ID if that's your strategy
      await NotificationService().cancelNotification(notificationId);
    }
  }
}
