import 'package:messaging_app/models/page_request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PagingService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendPagerNotification(String receiverID, PagerRequest pagerRequest) async {
    await firestore.collection('user_notifications').doc(receiverID).set({
      'senderEmail': pagerRequest.senderEmail,
      'recipientEmail': pagerRequest.recipientEmail,
      'location': pagerRequest.location,
      'notificationType': pagerRequest.notificationType,
      'message': pagerRequest.message,
      'timestamp': FieldValue.serverTimestamp(),
      'alert': true  // Flag to indicate new notification
    });
  }
}

void saveTokenToDatabase(String token) {
  // Assume the user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser!.uid;

  FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .update({
      'fcmToken': token,
    });
}

void setupToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    saveTokenToDatabase(token);
  }
}



