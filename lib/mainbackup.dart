// import 'dart:io';
//
// import 'package:cab_driver/globalvariables.dart';
// import 'package:cab_driver/screens/loginpage.dart';
// import 'package:cab_driver/screens/mainpage.dart';
// import 'package:cab_driver/screens/registration.dart';
// import 'package:cab_driver/screens/vehicleinfo.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:cab_driver/helpers/pushnotificationservice.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final FirebaseApp app =
//   await Firebase.initializeApp(
//     name: 'db2',
//     options: Platform.isIOS
//         ? const FirebaseOptions(
//       appId: '1:784303276461:ios:d269e50caa7362edd82124',
//       apiKey: 'AIzaSyCM-RJyPvjmEFEi5RInptmaFCfgjDIELCA',
//       projectId: 'flutter-firebase-plugins',
//       messagingSenderId: '784303276461',
//       databaseURL:
//       'https://geetaxi-24ea3-default-rtdb.europe-west1.firebasedatabase.app',
//     )
//         : const FirebaseOptions(
//       appId: '1:784303276461:android:bf8e6cf85ede3d06d82124',
//       apiKey: 'AIzaSyB-DXDM28-apXG86HbxwKu6Q7ZI7V0BqS4',
//       messagingSenderId: '297855924061',
//       projectId: 'flutter-firebase-plugins',
//       databaseURL:
//       'https://geetaxi-24ea3-default-rtdb.europe-west1.firebasedatabase.app',
//     ),
//   );
//
//   final FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     'This channel is used for important notifications.', // description
//     importance: Importance.max,
//   );
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   String getRideID(Map<String, dynamic> message) {
//     String rideId = '';
//
//     if (Platform.isAndroid) {
//       rideId = message['data']['ride_id'];
//       print('ride_id: $rideId');
//     } else {
//       rideId = message['ride_id'];
//       print('ride_id: $rideId');
//     }
//     return rideId;
//   }
//
//   void fetchRideInfo(String rideID) {
//     DatabaseReference rideRef =
//     FirebaseDatabase.instance.reference().child('rideRequest/$rideID');
//     rideRef.once().then((DataSnapshot snapshot) {
//       if (snapshot.value != null) {
//         double pickupLat =
//         double.parse(snapshot.value['location']['latitude'].toString());
//         double pickupLng =
//         double.parse(snapshot.value['location']['longitude'].toString());
//
//         String pickupAddress = snapshot.value['pickup_address'].toString();
//         double destinationLat =
//         double.parse(snapshot.value['destination']['latitude'].toString());
//         double destinationLng =
//         double.parse(snapshot.value['destination']['longitude'].toString());
//         String destinationAddress = snapshot.value['payment_method'];
//         print('kpa');
//         print(pickupAddress);
//         print('kpa');
//
//       }
//     });
//   }
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     fetchRideInfo(getRideID(message.data));
//     print("Handling a foreground message ${message.notification.body}");
//     RemoteNotification notification = message.notification;
//     AndroidNotification android = message.notification?.android;
//
//     // If `onMessage` is triggered with a notification, construct our own
//     // local notification to show to users using the created channel.
//     if (notification != null && android != null) {
//       print('Message also contained a notification: ${message.data}');
//       //confirm this works smoothly
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channel.description,
//             icon: android?.smallIcon,
//             // other properties...
//           ),
//         ),
//       );
//     } else {
//       print("CHECK! ISSUES");
//     }
//   });
//
//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     print('background is being handled');
//     fetchRideInfo(getRideID(message.data));
//   }
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   FirebaseMessaging.onMessageOpenedApp.listen(
//         (RemoteMessage message) {
//       fetchRideInfo(getRideID(message.data));
//     },
//   );
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         fontFamily: 'Brand-Regular',
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: LoginPage.id,
//       // (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
//       routes: {
//         MainPage.id: (context) => MainPage(),
//         VehicleInfoPage.id: (context) => VehicleInfoPage(),
//         RegistrationPage.id: (context) => RegistrationPage(),
//         LoginPage.id: (context) => LoginPage()
//       },
//       home: MainPage(),
//     );
//   }
// }
