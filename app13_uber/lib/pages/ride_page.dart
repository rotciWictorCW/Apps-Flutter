import 'dart:async';

import 'package:app13_uber/model/nUser.dart';
import 'package:app13_uber/utils/firebase_user.dart';
import 'package:app13_uber/utils/status_requisition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Ride extends StatefulWidget {
  final String requisitionId;

  Ride({required this.requisitionId, Key? key}) : super(key: key);

  @override
  State<Ride> createState() => _RideState();
}

class _RideState extends State<Ride> {
  final Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(-23.5, -46.6));
  Set<Marker> _markers = {};
  late Map<String, dynamic>? _requisitionData;
  late String _requisitionId;
  late Position _driverLocation;
  String _statusRequisition = StatusRequisition.WAITING;

  // Controls for screen exibition
  String _textButton = 'Aceitar corrida';
  Color _buttonColor = const Color(0xff1ebbd8);
  Function _buttonFunction = () {};
  String _statusMessage = '';

  _setMainButton(String text, Color color, Function function) {
    setState(() {
      _textButton = text;
      _buttonColor = color;
      _buttonFunction = function;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _addLocationListener() {
    const locationSettings =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (_requisitionId != null && _requisitionId.isNotEmpty) {
        if (_statusRequisition != StatusRequisition.WAITING) {
          // Update driver location
          FirebaseUser.updateLocationData(
              _requisitionId, position.latitude, position.longitude, 'driver');
        } else {
          setState(() {
            _driverLocation = position;
          });
          _statusWaiting();
        }
      }
    });
  }

  _getLastLocationKnown() async {
    await Geolocator.requestPermission();
    Position? position = await Geolocator.getLastKnownPosition();

    if (position != null) {
      _driverLocation = position;
    }
  }

  _moveCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _showMarker(Position local, String icon, String infoWindow) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio), icon)
        .then((BitmapDescriptor bitmapDescriptor) {
      Marker passengerMarker = Marker(
          markerId: MarkerId(icon),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: infoWindow),
          icon: bitmapDescriptor);

      setState(() {
        _markers.add(passengerMarker);
      });
    });
  }

  void _requisitionRecover() async {
    String requisitionId = widget.requisitionId;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await db.collection("requisitions").doc(requisitionId).get();
  }

  _addRequisitionListener() async {
    await Geolocator.requestPermission();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('requisitions')
        .doc(_requisitionId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        _requisitionData = snapshot.data();

        Map<String, dynamic>? data = snapshot.data();
        _statusRequisition = data?['status'];

        switch (_statusRequisition) {
          case StatusRequisition.WAITING:
            _statusWaiting();
            break;
          case StatusRequisition.ONTHEWAY:
            _statusOnTheWay();
            break;
          case StatusRequisition.TRIP:
            _statusOnTrip();
            break;
          case StatusRequisition.FINALIZED:
            _statusFinished();
            break;
          case StatusRequisition.CONFIRMED:
            _statusConfirmed();
            break;
        }
      }
    });
  }

  _statusWaiting() {
    _setMainButton('Aceitar corrida', const Color(0xff1ebbd8), () {
      _acceptRide();
    });

    if (_driverLocation != null) {
      double driverLatitude = _driverLocation.latitude;
      double driverLongitude = _driverLocation.longitude;

      Position position = Position(
          longitude: driverLongitude,
          latitude: driverLatitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0);
      _showMarker(position, '/assets/images/motorista.png', 'Motorista');

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);
      _moveCamera(cameraPosition);
    }
  }

  _statusOnTheWay() {
    _statusMessage = 'A caminho do passageiro';

    _setMainButton('Iniciar corrida', const Color(0xff1ebbd8), () {
      _startRide();
    });

    print("a caminho do passageiro $_requisitionData");
    double passengerLatitude = _requisitionData?['passenger']['latitude'];
    double passengerLongitude = _requisitionData?['passenger']['longitude'];

    double driverLatitude = _requisitionData?['driver']['latitude'];
    double driverLongitude = _requisitionData?['driver']['longitude'];

    _showTwoMarkers(LatLng(driverLatitude, driverLongitude),
        LatLng(passengerLatitude, passengerLongitude));

    late double northEastLatitude,
        northEastLongitude,
        southWestLatitude,
        southWestLongitude;

    if (driverLatitude <= passengerLatitude) {
      southWestLatitude = driverLatitude;
      northEastLatitude = passengerLatitude;
    } else {
      southWestLatitude = passengerLatitude;
      northEastLatitude = driverLatitude;
    }

    if (driverLongitude <= passengerLongitude) {
      southWestLongitude = driverLongitude;
      northEastLongitude = passengerLongitude;
    } else {
      southWestLongitude = driverLongitude;
      northEastLongitude = passengerLongitude;
    }

    _moveCameraUsingBounds(LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude)));
  }

  _finishRide() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('requisitions')
        .doc(_requisitionId)
        .update({'status': StatusRequisition.FINALIZED});

    String idPassenger = _requisitionData?['passenger']['userId'];
    db
        .collection('active_requisition')
        .doc(idPassenger)
        .update({'status': StatusRequisition.FINALIZED});

    String idDriver = _requisitionData?['driver']['userId'];
    db
        .collection('active_requisition_driver')
        .doc(idDriver)
        .update({'status': StatusRequisition.FINALIZED});
  }

  _statusFinished() async {
    // Calculating ride cost
    double destinationLatitude = _requisitionData?['destination']['latitude'];
    double destinationLongitude = _requisitionData?['destination']['longitude'];

    double originLatitude = _requisitionData?['origin']['latitude'];
    double originLongitude = _requisitionData?['origin']['longitude'];

    double distanceInMeters = Geolocator.distanceBetween(originLatitude,
        originLongitude, destinationLatitude, destinationLongitude);

    double distanceKm = distanceInMeters / 1000;

    double priceTrip = distanceKm * 8;

    var formater = NumberFormat('#,###0.00', 'pt_BR');
    var priceTripFormated = formater.format(priceTrip);

    _statusMessage = 'Viagem finalizada';

    _setMainButton(
        'Confirmar --R\$ $priceTripFormated', const Color(0xff1ebbd8), () {
      _confirmRide();
    });

    _markers = {};
    Position position = Position(
        longitude: destinationLongitude,
        latitude: destinationLatitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
    _showMarker(position, '/assets/images/destino.png', 'Destino');

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);
    _moveCamera(cameraPosition);
  }

  _statusConfirmed() {
    Navigator.pushReplacementNamed(context, '/panel-driver');
  }

  _confirmRide() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('requisitions')
        .doc(_requisitionId)
        .update({'status': StatusRequisition.CONFIRMED});

    String idPassenger = _requisitionData?['passenger']['userId'];
    db.collection('active_requisition').doc(idPassenger).delete();

    String idDriver = _requisitionData?['driver']['userId'];
    db.collection('active_requisition_driver').doc(idDriver).delete();
  }

  _statusOnTrip() {
    _statusMessage = 'Em viagem';

    _setMainButton('Finalizar Corrida', const Color(0xff1ebbd8), () {
      _finishRide();
    });

    double destinationLatitude = _requisitionData?['destination']['latitude'];
    double destinationLongitude = _requisitionData?['destination']['longitude'];

    double originLatitude = _requisitionData?['driver']['latitude'];
    double originLongitude = _requisitionData?['driver']['longitude'];

    _showTwoMarkers(LatLng(originLatitude, originLongitude),
        LatLng(destinationLatitude, destinationLongitude));

    late double northEastLatitude,
        northEastLongitude,
        southWestLatitude,
        southWestLongitude;

    if (originLatitude <= destinationLatitude) {
      southWestLatitude = originLatitude;
      northEastLatitude = destinationLatitude;
    } else {
      southWestLatitude = destinationLatitude;
      northEastLatitude = originLatitude;
    }

    if (originLongitude <= destinationLongitude) {
      southWestLongitude = originLongitude;
      northEastLongitude = destinationLongitude;
    } else {
      southWestLongitude = originLongitude;
      northEastLongitude = destinationLongitude;
    }

    _moveCameraUsingBounds(LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude)));
  }

  _startRide() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('requisitions').doc(_requisitionId).update({
      'origin': {
        'latitude': _requisitionData?['driver']['latitude'],
        'longitude': _requisitionData?['driver']['longitude'],
      },
      'status': StatusRequisition.TRIP
    });

    String idPassenger = _requisitionData?['passenger']['userId'];
    db
        .collection('active_requisition')
        .doc(idPassenger)
        .update({'status': StatusRequisition.TRIP});

    String idDriver = _requisitionData?['driver']['userId'];
    db
        .collection('active_requisition_driver')
        .doc(idDriver)
        .update({'status': StatusRequisition.TRIP});
  }

  _moveCameraUsingBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _showTwoMarkers(LatLng driverPosition, LatLng passengerPosition) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    Set<Marker> listMarkers = {};

    // Driver pin location
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "assets/images/motorista.png")
        .then((BitmapDescriptor icon) {
      Marker driverMarker = Marker(
          markerId: const MarkerId("driver-marker"),
          position: LatLng(driverPosition.latitude, driverPosition.longitude),
          infoWindow: const InfoWindow(title: "My local"),
          icon: icon);
      listMarkers.add(driverMarker);
    });

    // Passenger pin location
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "assets/images/passageiro.png")
        .then((BitmapDescriptor icon) {
      Marker passengerMarker = Marker(
          markerId: const MarkerId("passenger-marker"),
          position:
              LatLng(passengerPosition.latitude, passengerPosition.longitude),
          infoWindow: const InfoWindow(title: "My local"),
          icon: icon);
      listMarkers.add(passengerMarker);
    });

    setState(() {
      _markers = listMarkers;
    });
  }

  _acceptRide() async {
    // Get driver's data
    nUser driver = await FirebaseUser.getLoggedUserData();
    if (_driverLocation != null) {
      driver.latitude = _driverLocation.latitude;
      driver.longitude = _driverLocation.longitude;

      FirebaseFirestore db = FirebaseFirestore.instance;
      String requisitionId = _requisitionData?['id'];

      db.collection('requisitions').doc(requisitionId).update({
        'driver': driver.toMap(),
        'status': StatusRequisition.ONTHEWAY
      }).then((_) {
        String idPassenger = _requisitionData?['passenger']['userId'];
        db
            .collection('active_requisition')
            .doc(idPassenger)
            .update({'status': StatusRequisition.ONTHEWAY});

        String idDriver = driver.userId;
        db.collection('active_requisition_driver').doc(idDriver).set({
          'id_requisition': requisitionId,
          'id_user': idDriver,
          'status': StatusRequisition.ONTHEWAY
        });
      });
    }
  }

  @override
  initState() {
    super.initState();

    _requisitionId = widget.requisitionId;

    _addRequisitionListener();

    //_getLastLocationKnown();
    _addLocationListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel corrida - $_statusMessage'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _cameraPosition,
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: false,
            markers: _markers,
          ),
          Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: RaisedButton(
                  color: _buttonColor,
                  onPressed: _buttonFunction as VoidCallback,
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  child: Text(
                    _textButton,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
