import 'dart:io';

import 'package:cab_driver/datamodels/tripdetails.dart';
import 'package:cab_driver/dataprovider.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/screens/loginpage.dart';
import 'package:cab_driver/screens/mainpage.dart';
import 'package:cab_driver/screens/registration.dart';
import 'package:cab_driver/screens/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            appId: '1:784303276461:ios:d269e50caa7362edd82124',
            apiKey: 'YOUR API KEY HERE',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '784303276461',
            databaseURL:
                'https://geetaxi-24ea3-default-rtdb.europe-west1.firebasedatabase.app',
          )
        : const FirebaseOptions(
            appId: '1:784303276461:android:bf8e6cf85ede3d06d82124',
            apiKey: 'YOUR API KEY HERE',
            messagingSenderId: '297855924061',
            projectId: 'flutter-firebase-plugins',
            databaseURL:
                'https://geetaxi-24ea3-default-rtdb.europe-west1.firebasedatabase.app',
          ),
  );

  final FirebaseMessaging messaging = FirebaseMessaging.instance;



  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
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
void fetchRideInfo(String rideID) {
  DatabaseReference rideRef =
      FirebaseDatabase.instance.reference().child('rideRequest/$rideID');
  rideRef.once().then((DataSnapshot snapshot) {
    if (snapshot.value != null) {
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

      TripDetails tripDetails = TripDetails();
      tripDetails.rideID = rideID;
      tripDetails.pickupAddress = pickupAddress;
      tripDetails.destinationAddress = destinationAddress;
      tripDetails.pickup = LatLng(pickupLat, pickupLng);
      tripDetails.destination = LatLng(destinationLat, destinationLng);
      tripDetails.paymentMethod = paymentMethod;
      print(tripDetails.destinationAddress);
    } else {
      print('CHECK snapshot might be null');
    }
  });
}

///Background Notifications
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('background is being handled');
  await Firebase.initializeApp();

  fetchRideInfo(getRideID(message.data));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: RegistrationPage.id,
        // (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
        routes: {
          MainPage.id: (context) => MainPage(),
          VehicleInfoPage.id: (context) => VehicleInfoPage(),
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage()
        },
        // home: MainPage(),
      ),
    );
  }
}
