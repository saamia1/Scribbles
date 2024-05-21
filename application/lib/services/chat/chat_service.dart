import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:messaging_app/models/message.dart';

import 'package:logging/logging.dart';
import '../auth/auth_service.dart';  // Ensure you have AuthService for current user check if needed

class ChatService {
  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; 
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthService _authService;

  ChatService(this._authService);

  //get user stream 
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      if (kDebugMode) {
        print("Snapshot received: ${snapshot.docs.length} documents");
      } // Debug statement
      return snapshot.docs.map((doc) {
        final user = doc.data();
        if (kDebugMode) {
          print("User data: $user");
        } // Debug statement
        return user;
      }).toList();
    });
  }

  //send messages
  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //get chat room id
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    await _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("message")
    .add(newMessage.toMap());

  }

  //get messages 
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
   
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("message")
    .orderBy("timestamp", descending: false)
    .snapshots();
  }


  // ADDED BY ME
  
  final _logger = Logger('ChatService');

  Future<void> sendPagingNotification({
  required String receiverID,
  required String recipientEmail,
  required String location,
  required String notificationType,
  required String customMessage
}) async {
  String senderEmail = _authService.getCurrentUser()?.email ?? "Unknown";
  try {
    // Writing directly to a recipient-specific document
    await FirebaseFirestore.instance.collection('user_notifications').doc(receiverID).set({
      'senderEmail': senderEmail,
      'recipientEmail': recipientEmail,
      'location': location,
      'notificationType': notificationType,
      'message': customMessage,
      'timestamp': FieldValue.serverTimestamp(),
      'alert': true  // Flag to indicate new notification for the client to trigger a local notification
    });
    debugPrint('Notification sent successfully');
  } catch (e) {
    debugPrint('Error sending notification: $e');
    throw Exception('Failed to send notification');
  }
}
  Future<void> sendNotification(Map<String, String> pageRequest) async {
    _logger.info('Sending paging request to ${pageRequest['recipient']}');
    // Logic to send the notification
  }
}