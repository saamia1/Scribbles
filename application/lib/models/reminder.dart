import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String id;
  final String userID;
  final String title;
  final Timestamp reminderTime;
  bool isNotificationEnabled; // This needs to be outside the constructor for default assignment

  Reminder({
    required this.id,
    required this.userID,
    required this.title,
    required this.reminderTime,
    this.isNotificationEnabled = true, // Correct placement of default value
  });

  set id(String id) {}

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "title": title,
      "reminderTime": reminderTime,
      'isNotificationEnabled': isNotificationEnabled,
    };
  }

  // Implementing fromJson method to create an instance from Firestore data
  static Reminder fromJson(Map<String, dynamic> json, String id) {
    return Reminder(
      id: id,
      userID: json['userID'],
      title: json['title'],
      reminderTime: json['reminderTime'] as Timestamp, // Correct type casting
      isNotificationEnabled: json['isNotificationEnabled'] as bool? ?? false // Correct handling of potential null
    );
  }
}
