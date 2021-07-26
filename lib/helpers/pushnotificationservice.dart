import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_driver/datamodels/tripdetails.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/widgets/NotificationDialog.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future initialize(context) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      fetchRideInfo(getRideID(message.data), context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('CHECK ONMESSAGEOPENED APP IS ${message.data}');
        fetchRideInfo(getRideID(message.data), context);
      },
    );
  }

  ///GetRide Id
  String getRideID(Map<String, dynamic> message) {
    String rideId = '';

    if (Platform.isAndroid) {
      rideId = message['ride_id'];
      print('ride_id: $rideId');
    } else {
      rideId = message['ride_id'];
      print('ride_id: $rideId');
    }
    return rideId;
  }

  ///FetRide Info
  void fetchRideInfo(String rideID, context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Fetching Details',
            ));
    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideID');
    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      if (snapshot.value != null) {
        assetsAudioPlayer
            .open(
              Audio('sounds/alert.mp3'),
            )
            .then((value) => assetsAudioPlayer.play());
        assetsAudioPlayer.play();
        print('snapshot is ${snapshot.value}');
        double pickupLat =
            double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng =
            double.parse(snapshot.value['location']['longitude'].toString());

        String pickupAddress = snapshot.value['pickup_address'].toString();
        double destinationLat =
            double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng =
            double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddress = snapshot.value['destination_address'];
        String paymentMethod = snapshot.value['payment_method'];
        String riderName = snapshot.value['rider_name'];
        String riderPhone = snapshot.value['rider_phone'];

        TripDetails tripDetails = TripDetails();
        tripDetails.rideID = rideID;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.riderName = riderName;

        tripDetails.riderPhone= riderPhone;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => NotificationDialog(
            tripDetails: tripDetails,
          ),
        );
      } else {
        print('CHECK snapshot might be null');
      }
    });
  }

  Future<String> getToken() async {
    String token = await messaging.getToken();
    print('token: $token');
    DatabaseReference tokenRef = FirebaseDatabase()
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);
    messaging.subscribeToTopic('alldrivers');
    messaging.subscribeToTopic('allusers');
    return token;
  }
}
