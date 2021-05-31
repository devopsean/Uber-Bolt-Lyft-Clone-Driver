import 'dart:io';

import 'package:cab_driver/globalvariables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (Platform.isAndroid){
        String rideID = message.data['data']['ride_id'];
        print('ride_id: $rideID');
      }

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');
    DatabaseReference tokenRef = FirebaseDatabase()
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);
    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }
}
