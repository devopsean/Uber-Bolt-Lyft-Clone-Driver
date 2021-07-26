import 'package:firebase_database/firebase_database.dart';

class History {
  String pickup;
  String destination;
  String fares, status, createdAt, paymentMethod;

  History({
    this.pickup,
    this.destination,
    this.fares,
    this.paymentMethod,
    this.status,
    this.createdAt,
  });

  History.fromSnapshot(DataSnapshot snapshot) {
    pickup = snapshot.value['pickup_address'];
    destination = snapshot.value['destination_address'];

    fares = snapshot.value['fares'].toString();
    createdAt = snapshot.value['created_at'];
    status = snapshot.value['status'];
    paymentMethod = snapshot.value['payment_method'];
  }
}
