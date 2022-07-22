import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Completer<GoogleMapController> _controller = Completer();

_onMapCreated( GoogleMapController googleMapController){
  _controller.complete( googleMapController);
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Mapas"),),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-22.945516, -43.590930),
            zoom: 16
          ),
          onMapCreated: (GoogleMapController controller){
            _controller.complete( controller );
          },
        ),
      ),
    );
  }
}
