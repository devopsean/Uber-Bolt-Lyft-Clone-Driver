import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cab_driver/datamodels/driver.dart';

User currentFirebaseUser;
final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
final assetsAudioPlayer = AssetsAudioPlayer();
String mapKey = 'AIzaSyB-DXDM28-apXG86HbxwKu6Q7ZI7V0BqS4';
DatabaseReference tripRequestRef;

StreamSubscription<Position> homeTabPositionStream;
StreamSubscription<Position> ridePositionStream;

Position currentPosition;
DatabaseReference rideRef;
Driver currentDriverInfo;