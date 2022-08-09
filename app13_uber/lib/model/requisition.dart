import 'package:app13_uber/model/destination.dart';
import 'package:app13_uber/model/nUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requisition {

  late String _id;
  late String _status;
  late nUser _passenger;
  late nUser _driver;
  late Destination _destination;

  Requisition() {

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference ref = db.collection('requisitions').doc();
    id = ref.id;

  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> passengerData = {
      'name': passenger.name,
      'email': passenger.email,
      'userType': passenger.userType,
      'userId': passenger.userId,
      'latitude': passenger.latitude,
      'longitude': passenger.longitude,
    };

    Map<String, dynamic> destinationData = {
      'street': destination.street,
      'number': destination.number,
      'neighborhood': destination.neighborhood,
      'postalCode': destination.postalCode,
      'latitude': destination.latitude,
      'longitude': destination.longitude,
    };

    Map<String, dynamic> requisitionData = {
      'id': id,
      'status': status,
      'passenger': passengerData,
      'driver': null,
      'destination': destinationData
    };

    return requisitionData;
  }

  Destination get destination => _destination;

  set destination(Destination value) {
    _destination = value;
  }

  nUser get driver => _driver;

  set driver(nUser value) {
    _driver = value;
  }

  nUser get passenger => _passenger;

  set passenger(nUser value) {
    _passenger = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
