import 'package:cloud_firestore/cloud_firestore.dart';

class PagerRequest {
  late String id; 
  final String recipientEmail;
  final String senderID;
  final String senderEmail;
  final Timestamp timestamp;
  final String notificationType;
  final String message;
  final String location;

  PagerRequest({
    required this.id,  
    required this.recipientEmail,
    required this.senderID,
    required this.senderEmail,
    required this.timestamp,
    required this.notificationType,
    required this.message,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id, 
      "recipientEmail": recipientEmail,
      "senderID": senderID,
      "senderEmail": senderEmail,
      "timestamp": timestamp,
      "notificationType": notificationType,
      "message": message,
      "location": location,
    };
  }

  static PagerRequest fromJson(Map<String, dynamic> json) {
    return PagerRequest(
      id: json['id'],
      recipientEmail: json['recipientEmail'],
      senderID: json['senderID'],
      senderEmail: json['senderEmail'],
      timestamp: json['timestamp'] as Timestamp, 
      notificationType: json['notificationType'],
      message: json['message'],
      location: json['location'],
    );
  }
}
