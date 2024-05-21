import 'package:firebase_core/firebase_core.dart';
import 'package:messaging_app/pages/splash_page.dart';
// import 'package:messaging_app/services/auth/auth_gate.dart';
import 'package:messaging_app/firebase_options.dart';
import 'package:messaging_app/themes/light_mode.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app/services/paging/paging_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:messaging_app/services/notification/notification_service_paging.dart";



// Define a global navigator key
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      theme:lightMode,
    ); // MaterialApp
  }
}
