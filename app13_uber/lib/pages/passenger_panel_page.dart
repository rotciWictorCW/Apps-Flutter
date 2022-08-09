import 'package:app13_uber/model/destination.dart';
import 'package:app13_uber/model/markerz.dart';
import 'package:app13_uber/model/nUser.dart';
import 'package:app13_uber/utils/firebase_user.dart';
import 'package:app13_uber/utils/status_requisition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../model/requisition.dart';

class PassengerPanel extends StatefulWidget {
  const PassengerPanel({Key? key}) : super(key: key);

  @override
  State<PassengerPanel> createState() => _PassengerPanelState();
}

class _PassengerPanelState extends State<PassengerPanel> {
  final TextEditingController _controllerDestination = TextEditingController();

  List<String> menuItens = ["Configurações", "Deslogar"];

  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(-22.890395, -43.228417), zoom: 16);

  Set<Marker> _markers = {};
  String _requisitionId = "";
  Position _passengerLocation = Position(
    longitude: -16,
    latitude: -48,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );

  Map<String, dynamic> _requisitionData = {};
  StreamSubscription<DocumentSnapshot>? _streamSubscriptionRequisitions;
  late StreamSubscription<Position> _streamLocationListener;

  bool _showDestinationAddressBox = true;
  String _textButton = "Chamar Uber";
  Color _buttonColor = const Color(0xff1ebbd8);
  VoidCallback _buttonFunction = () {};

  _logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _itemMenuChoice(String choice) {
    switch (choice) {
      case "Deslogar":
        _logout();
        break;
      case "Configurações":
        break;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _addLocalizationListener() {
    const locationSettings = LocationSettings(accuracy: LocationAccuracy.high);
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (_requisitionId != null && _requisitionId.isNotEmpty) {
        FirebaseUser.updateLocationData(
            _requisitionId, position.latitude, position.longitude, 'passenger');
      } else {
        setState(() {
          _passengerLocation = position;
        });
        _statusUberNotCalled();
      }
      //setState(() {
      // _cameraPosition = CameraPosition(
      //     target: LatLng(position.latitude, position.longitude), zoom: 19);
      // _moveCamera(_cameraPosition);
      //  _showPassengerMarker(position);
      // });
    });
  }

  void _getLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  Future<void> _getLastKnownLocation() async {
    Position? position = await Geolocator.getLastKnownPosition();

    setState(() {
      if (position != null) {
        _cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _moveCamera(_cameraPosition);

        _showPassengerMarker(position);
      }
    });
  }

  Future<void> _moveCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _showPassengerMarker(Position local) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "assets/images/passageiro.png")
        .then((BitmapDescriptor icon) {
      Marker passengerMarker = Marker(
          markerId: const MarkerId("passenger-marker"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: const InfoWindow(title: "My local"),
          icon: icon);

      setState(() {
        _markers.add(passengerMarker);
      });
    });
  }

  Future<void> _callUber() async {
    String destinationAddress = _controllerDestination.text;

    if (destinationAddress.isNotEmpty) {
      List<Location> addressList =
          await locationFromAddress(destinationAddress);

      if (addressList.isNotEmpty) {
        Location position = addressList[0];

        List<Placemark> addresses = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (addresses.isNotEmpty) {
          Placemark address = addresses[0];

          Destination destination = Destination();
          destination.city = address.administrativeArea ?? "";
          destination.postalCode = address.postalCode ?? "";
          destination.neighborhood = address.subLocality ?? "";
          destination.street = address.thoroughfare ?? "";
          destination.number = address.subThoroughfare ?? "";

          destination.latitude = position.latitude;
          destination.longitude = position.longitude;

          String corfirmAddress;
          corfirmAddress = "\n Cidade: ${destination.city}";
          corfirmAddress +=
              "\n Rua: ${destination.street}, ${destination.number}";
          corfirmAddress += "\n Bairro: ${destination.neighborhood}";
          corfirmAddress += "\n Cep: ${destination.postalCode}";

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Confirmação do endereço"),
                  content: Text(corfirmAddress),
                  contentPadding: const EdgeInsets.all(16),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        _saveRequisition(destination);

                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        }
      }
    }
  }

  Future<void> _saveRequisition(Destination destination) async {
    nUser passenger = await FirebaseUser.getLoggedUserData();
    passenger.latitude = _passengerLocation.latitude;
    passenger.longitude = _passengerLocation.longitude;

    Requisition requisition = Requisition();
    requisition.destination = destination;
    requisition.passenger = passenger;
    requisition.status = StatusRequisition.WAITING;

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection('requisitions')
        .doc(requisition.id)
        .set(requisition.toMap());

    // save active requisition
    Map<String, dynamic> activeRequisitionData = {};
    activeRequisitionData['id_requisition'] = requisition.id;
    activeRequisitionData['id_user'] = passenger.userId;
    activeRequisitionData['status'] = StatusRequisition.WAITING;

    await db
        .collection('active_requisition')
        .doc(passenger.userId)
        .set(activeRequisitionData);

    if (_streamSubscriptionRequisitions == null) {
      _addRequisitionListener(requisition.id);
    }
  }

  void _setMainButton(String text, Color color, VoidCallback function) {
    setState(() {
      _textButton = text;
      _buttonColor = color;
      _buttonFunction = function;
    });
  }

  void _statusUberNotCalled() {
    _showDestinationAddressBox = true;

    _setMainButton('Chamar Uber', const Color(0xff1ebbd8), () {
      _callUber();
    });

    if (_passengerLocation != null) {
      Position position = Position(
          longitude: _passengerLocation.longitude,
          latitude: _passengerLocation.latitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0);
      _showPassengerMarker(position);
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);
      _moveCamera(cameraPosition);
    }
  }

  void _statusWaiting() {
    _showDestinationAddressBox = false;

    print("yyy latitude - $_requisitionData['passenger']['destination']['latitude'] longitude - $_requisitionData['passenger']['destination']['longitude'] ");

    _setMainButton('Cancelar', Colors.red, () {
      _cancelUber();
    });

    double passengerLatitude = _requisitionData['passenger']['destination']['latitude'];
    double passengerLongitude = _requisitionData['passenger']['destination']['longitude'];

    Position position = Position(
        longitude: passengerLatitude,
        latitude: passengerLongitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
    _showPassengerMarker(position);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);
    _moveCamera(cameraPosition);
  }

  void _statusOnTheWay() {
    _showDestinationAddressBox = false;

    _setMainButton('Motorista a caminho', Colors.grey, () {});

    double passengerLatitude = _requisitionData['passenger']['latitude'];
    double passengerLongitude = _requisitionData['passenger']['longitude'];

    double driverLatitude = _requisitionData['driver']['latitude'];
    double driverLongitude = _requisitionData['driver']['longitude'];

    Markerz originMarker = Markerz(LatLng(driverLatitude, driverLongitude),
        '/assets/images/motorista.png', 'Local Motorista');

    Markerz destinationMarker = Markerz(
        LatLng(passengerLatitude, passengerLongitude),
        '/assets/images/passageiro.png',
        'Local Passageiro');

    _showCentralizedTwoMarkers(originMarker, destinationMarker);
  }

  void _statusOnTrip() {
    _showDestinationAddressBox = false;

    _setMainButton('Em viagem', Colors.grey, () {});

    double destinationLatitude = _requisitionData['destination']['latitude'];
    double destinationLongitude = _requisitionData['destination']['longitude'];

    double originLatitude = _requisitionData['driver']['latitude'];
    double originLongitude = _requisitionData['driver']['longitude'];

    Markerz originMarker = Markerz(LatLng(originLatitude, originLongitude),
        '/assets/images/motorista.png', 'Local Motorista');

    Markerz destinationMarker = Markerz(
        LatLng(destinationLatitude, destinationLongitude),
        '/assets/images/destino.png',
        'Local Destino');

    _showCentralizedTwoMarkers(originMarker, destinationMarker);
  }

  void _statusFinished() async {
    double destinationLatitude = _requisitionData['destination']['latitude'];
    double destinationLongitude = _requisitionData['destination']['longitude'];

    double originLatitude = _requisitionData['origin']['latitude'];
    double originLongitude = _requisitionData['origin']['longitude'];

    double distanceInMeters = Geolocator.distanceBetween(originLatitude,
        originLongitude, destinationLatitude, destinationLongitude);

    double distanceKm = distanceInMeters / 1000;

    double priceTrip = distanceKm * 8;

    var formatter = NumberFormat('#,###0.00', 'pt_BR');
    var priceTripFormatted = formatter.format(priceTrip);

    _setMainButton('Total --R\$ $priceTripFormatted', Colors.green, () {});

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

  void _statusConfirmed() {
    if (_streamSubscriptionRequisitions != null) {
      _streamSubscriptionRequisitions!.cancel();
      _streamSubscriptionRequisitions = null;
    }

    _showDestinationAddressBox = true;
    _setMainButton('Chamar Uber', const Color(0xff1ebbd8), () {
      _callUber();
    });

    double passengerLatitude = _requisitionData['passenger']['latitude'];
    double passengerLongitude = _requisitionData['passenger']['longitude'];

    Position position = Position(
        longitude: passengerLatitude,
        latitude: passengerLongitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
    _showPassengerMarker(position);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);
    _moveCamera(cameraPosition);

    _requisitionData = {};
  }

  void _showMarker(Position local, String icon, String infoWindow) async {
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

  void _showCentralizedTwoMarkers(Markerz originMarker, Markerz destinationMarker) {
    double originLatitude = originMarker.local.latitude;
    double originLongitude = originMarker.local.longitude;

    double destinationLatitude = originMarker.local.latitude;
    double destinationLongitude = originMarker.local.longitude;

    _showTwoMarkers(originMarker, destinationMarker);

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

  _moveCameraUsingBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _showTwoMarkers(Markerz originMarker, Markerz destinationMarker) {
    LatLng latLngOrigin = originMarker.local;
    LatLng latLngdestination = destinationMarker.local;

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    Set<Marker> listMarkers = {};

    // Driver pin location
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            originMarker.imagePath)
        .then((BitmapDescriptor iconLocation) {
      Marker oMarker = Marker(
          markerId: MarkerId(originMarker.imagePath),
          position: LatLng(latLngOrigin.latitude, latLngdestination.longitude),
          infoWindow: InfoWindow(title: originMarker.title),
          icon: iconLocation);
      listMarkers.add(oMarker);
    });

    // Passenger pin location
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            destinationMarker.imagePath)
        .then((BitmapDescriptor iconLocation) {
      Marker dMarker = Marker(
          markerId: MarkerId(destinationMarker.imagePath),
          position: LatLng(latLngdestination.latitude, latLngdestination.longitude),
          infoWindow: InfoWindow(title: destinationMarker.title),
          icon: iconLocation);
      listMarkers.add(dMarker);
    });

    setState(() {
      _markers = listMarkers;
    });
  }

  _cancelUber() {
    User firebaseUser = FirebaseUser.getCurrentUser();

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('requisitions')
        .doc(_requisitionId)
        .update({'status': StatusRequisition.CANCELED}).then((_) {
      db.collection('active_requisition').doc(firebaseUser.uid).delete();
    });

    _statusUberNotCalled();

    if (_streamSubscriptionRequisitions != null) {
      _streamSubscriptionRequisitions!.cancel();
      _streamSubscriptionRequisitions = null;
    }
  }

  _getActiveRequisition() async {
    User firebaseUser = FirebaseUser.getCurrentUser();

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection('active_requisition').doc(firebaseUser.uid).get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic> data = documentSnapshot.data()!;
      setState(() {
        _requisitionId = data['id_requisition'];
      });
      _addRequisitionListener(_requisitionId);
    } else {
      _statusUberNotCalled();
    }
  }

  _addRequisitionListener(String requisitionId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    _streamSubscriptionRequisitions = db
        .collection('requisitions')
        .doc(requisitionId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        _requisitionData = data;
        String status = data['status'];
        _requisitionId = data['id'];

        switch (status) {
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
          case StatusRequisition.CANCELED:
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocationPermissions();
    _getActiveRequisition();

    //_getLastKnownLocation();
    _addLocalizationListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel passageiro'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _itemMenuChoice,
            itemBuilder: (context) {
              return menuItens.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: false,
            markers: _markers,
          ),
          Visibility(
            visible: _showDestinationAddressBox,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white),
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              icon: Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: const Icon(Icons.location_on),
                              ),
                              hintText: 'Meu local',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 15)),
                        ),
                      ),
                    )),
                Positioned(
                    top: 55,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white),
                        child: TextField(
                          controller: _controllerDestination,
                          decoration: InputDecoration(
                              icon: Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: const Icon(
                                  Icons.local_taxi,
                                  color: Colors.green,
                                ),
                              ),
                              hintText: 'Digite o destino',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 15)),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: RaisedButton(
                  color: _buttonColor,
                  onPressed: _buttonFunction,
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

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionRequisitions?.cancel();
    _streamSubscriptionRequisitions = null;
    _streamLocationListener.cancel();
  }
}
