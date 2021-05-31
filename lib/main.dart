import 'dart:io';

import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/screens/loginpage.dart';
import 'package:cab_driver/screens/mainpage.dart';
import 'package:cab_driver/screens/registration.dart';
import 'package:cab_driver/screens/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cab_driver/helpers/pushnotificationservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            appId: '1:784303276461:ios:d269e50caa7362edd82124',
            apiKey: 'AIzaSyCM-RJyPvjmEFEi5RInptmaFCfgjDIELCA',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '784303276461',
            databaseURL:
                'https://geetaxi-24ea3-default-rtdb.europe-west1.firebasedatabase.app',
          )
        : const FirebaseOptions(
            appId: '1:784303276461:android:0666fe7d2a396070d82124',
            apiKey: 'AIzaSyB-DXDM28-apXG86HbxwKu6Q7ZI7V0BqS4',
            messagingSenderId: '297855924061',
            projectId: 'flutter-firebase-plugins',
            databaseURL:
                'https://geetaxi-24ea3-default-rtdb.europe-west1.firebasedatabase.app',
          ),
  );

  currentFirebaseUser = await FirebaseAuth.instance.currentUser;
  // From firebase documentation
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  RemoteMessage initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
      routes: {
        MainPage.id: (context) => MainPage(),
        VehicleInfoPage.id: (context) => VehicleInfoPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        LoginPage.id: (context) => LoginPage()
      },
      home: MainPage(),
    );
  }
}
