import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  String tripID = "";
  MapScreen({Key? key, tripID}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  CameraPosition _camera_position =
      const CameraPosition(target: LatLng(-23.562436, -46.655005), zoom: 18);

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _addMarkers( LatLng latLng) async {

    List<Placemark> addressList = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if( addressList != null && addressList.isNotEmpty ){

      Placemark address = addressList[0];
      String street = address.thoroughfare ?? "";

      Marker marker = Marker(
          markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
          position: latLng,
          infoWindow: InfoWindow(
              title: street
          )
      );

      setState(() {
        _markers.add( marker );

        //Salva no firebase
        Map<String, dynamic> trip = Map();
        trip["title"] = street;
        trip["latitude"] = latLng.latitude;
        trip["longitude"] = latLng.longitude;

        _db.collection("trips")
            .add( trip );

      });

    }

  }
// primeiro metodo que só mostrava o marker na tela
  _showMarkers(LatLng latLng) async {
    List<Placemark> addressList =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (addressList != null && addressList.isNotEmpty) {
      Placemark address = addressList[0];
      String street = address.thoroughfare ?? "";

      Marker marker = Marker(
          markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
          position: latLng,
          infoWindow: InfoWindow(title: street));

      setState(() {
        _markers.add(marker);
      });
    }
  }

  _moveCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_camera_position));
  }

  _addLocalizationListener() {

    const locationSettings = LocationSettings(accuracy: LocationAccuracy.high);
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        _camera_position = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 18);
        _moveCamera();
      });
    });
  }

  _recoverTripById(String tripId) async {

    if( tripId != null ){

      //exibir marcador para id viagem
      DocumentSnapshot documentSnapshot = await _db
          .collection("trips")
          .doc( tripId )
          .get();

      var response = jsonEncode(documentSnapshot.data());
      Map<String, dynamic> data = jsonDecode(response);

      String title = data["title"];
      LatLng latLng = LatLng(
          data["latitude"],
          data["longitude"]
      );

      setState(() {

        Marker marcador = Marker(
            markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
            position: latLng,
            infoWindow: InfoWindow(
                title: title
            )
        );

        _markers.add( marcador );
        _camera_position = CameraPosition(
            target: latLng,
            zoom: 18
        );
        _moveCamera();

      });

    }else{
      _addLocalizationListener();
    }

  }


  @override
  void initState() {
    super.initState();
    _recoverTripById(widget.tripID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: _camera_position,
        onMapCreated: _onMapCreated,
        onLongPress: _addMarkers,
      ),
    );
  }
}
