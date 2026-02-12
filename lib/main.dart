import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/my_app_view.dart';
import 'services/shared_prefrence_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    await initializeFirebaseAndNotifications();
    // await setupStripe();
    await SharedPreferencesService().init();
    runApp(const MyApp());
  } catch (e) {
    debugPrint("Error during app initialization: $e");
  }
}

Future<void> initializeFirebaseAndNotifications() async {
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyD6iYLTuyfaJrSSw_RVNVte8c1_kX1pb4c",
          appId: "1:1018647566315:android:dbbbb8827ea66f8cdaebae",
          messagingSenderId: "1018647566315",
          projectId: "motivational-app-786e5",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    // Request notification permission
    await FirebaseMessaging.instance.requestPermission();

    // Retrieve FCM token
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token: $token");
  } catch (e) {
    debugPrint("Error during Firebase or Notification setup: $e");
  }
}
